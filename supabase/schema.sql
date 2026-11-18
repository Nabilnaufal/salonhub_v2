-- ============================================================================
-- SalonHub v2 — Skema database Supabase
-- Jalankan sekali di Supabase SQL Editor (project kosong).
-- Isi: auth profil, katalog toko, booking, chat, RLS, Storage foto, RPC.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- ENUM
-- ---------------------------------------------------------------------------
create type public.user_role as enum ('customer', 'mitra', 'admin');

-- booked     = dipesan customer, belum dikonfirmasi mitra (label "Baru")
-- waiting    = diterima mitra, menunggu customer datang
-- on_process = sedang dikerjakan barber
create type public.booking_status as enum (
  'booked',
  'waiting',
  'on_process',
  'finished',
  'cancelled'
);

create type public.payment_status as enum ('pending', 'paid', 'failed', 'refunded');

-- ---------------------------------------------------------------------------
-- PROFILES (1 baris per auth.users)
-- ---------------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null default '',
  email text,
  phone text,
  avatar_url text,
  role public.user_role not null default 'customer',
  notifications_enabled boolean not null default true,
  order_notifications boolean not null default true,
  sound_notifications boolean not null default true,
  promo_notifications boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Profil dibuat otomatis saat sign up. Role diambil dari metadata (`role`),
-- sehingga aplikasi mitra cukup signUp dengan data {'role': 'mitra'}.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, phone, avatar_url, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.email,
    new.phone,
    new.raw_user_meta_data ->> 'avatar_url',
    case
      when new.raw_user_meta_data ->> 'role' = 'mitra' then 'mitra'::public.user_role
      else 'customer'::public.user_role
    end
  );
  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- SHOPS
-- ---------------------------------------------------------------------------
create table public.shops (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references public.profiles (id) on delete set null,
  name text not null,
  slug text unique,
  description text not null default '',
  address text not null default '',
  phone text,
  image_url text,
  gallery text[] not null default '{}',
  facilities text[] not null default '{}',
  latitude double precision,
  longitude double precision,
  is_open boolean not null default true,
  is_verified boolean not null default false,
  rating numeric(2, 1) not null default 0 check (rating between 0 and 5),
  review_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index shops_owner_idx on public.shops (owner_id);
-- Satu akun mitra hanya boleh memiliki satu toko.
create unique index shops_one_per_owner on public.shops (owner_id)
  where owner_id is not null;

-- day_of_week: 0 = Senin ... 6 = Minggu
create table public.shop_opening_hours (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops (id) on delete cascade,
  day_of_week smallint not null check (day_of_week between 0 and 6),
  open_time time,
  close_time time,
  is_closed boolean not null default false,
  unique (shop_id, day_of_week)
);

-- ---------------------------------------------------------------------------
-- LAYANAN & BARBER
-- ---------------------------------------------------------------------------
create table public.shop_services (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops (id) on delete cascade,
  name text not null,
  description text not null default '',
  price integer not null check (price >= 0),
  duration_minutes integer not null check (duration_minutes > 0),
  image_url text,
  is_active boolean not null default true,
  total_bookings integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index shop_services_shop_idx on public.shop_services (shop_id) where is_active;

create table public.barbers (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops (id) on delete cascade,
  profile_id uuid references public.profiles (id) on delete set null,
  name text not null,
  role text not null default 'Barber',
  image_url text,
  rating numeric(2, 1) not null default 0 check (rating between 0 and 5),
  is_active boolean not null default true,
  shift_start time,
  shift_end time,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index barbers_shop_idx on public.barbers (shop_id) where is_active;

-- ---------------------------------------------------------------------------
-- BOOKING
-- ---------------------------------------------------------------------------
create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,                     -- SBH-YYMMDD-HHMI
  customer_id uuid references public.profiles (id) on delete restrict,
  walk_in_name text,                             -- pesanan walk-in tanpa akun
  shop_id uuid not null references public.shops (id) on delete restrict,
  barber_id uuid references public.barbers (id) on delete set null,
  status public.booking_status not null default 'booked',
  scheduled_at timestamptz not null,
  note text not null default '',
  payment_method text,
  is_paid boolean not null default false,
  subtotal integer not null default 0 check (subtotal >= 0),
  service_fee integer not null default 0 check (service_fee >= 0),
  total_price integer generated always as (subtotal + service_fee) stored,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint booking_has_customer check (customer_id is not null or walk_in_name is not null)
);

create index bookings_customer_idx on public.bookings (customer_id, created_at desc);
create index bookings_shop_idx on public.bookings (shop_id, scheduled_at);
create index bookings_status_idx on public.bookings (status);
create index bookings_scheduled_idx on public.bookings (shop_id, (scheduled_at at time zone 'Asia/Jakarta'));

-- Snapshot nama & harga saat booking.
create table public.booking_items (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings (id) on delete cascade,
  service_id uuid references public.shop_services (id) on delete set null,
  name text not null,
  price integer not null check (price >= 0),
  duration_minutes integer not null check (duration_minutes > 0)
);

create index booking_items_booking_idx on public.booking_items (booking_id);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null unique references public.bookings (id) on delete cascade,
  method text not null,                          -- qris, bca, mandiri, bri, bni, cash
  amount integer not null check (amount >= 0),
  status public.payment_status not null default 'pending',
  reference text,
  paid_at timestamptz,
  created_at timestamptz not null default now()
);

create index payments_booking_idx on public.payments (booking_id);

-- ---------------------------------------------------------------------------
-- REVIEW & FAVORITE
-- ---------------------------------------------------------------------------
create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid unique references public.bookings (id) on delete set null,
  shop_id uuid not null references public.shops (id) on delete cascade,
  customer_id uuid not null references public.profiles (id) on delete cascade,
  rating smallint not null check (rating between 1 and 5),
  comment text not null default '',
  reply text,
  replied_at timestamptz,
  created_at timestamptz not null default now()
);

create index reviews_shop_idx on public.reviews (shop_id, created_at desc);

create table public.favorites (
  customer_id uuid not null references public.profiles (id) on delete cascade,
  shop_id uuid not null references public.shops (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (customer_id, shop_id)
);

-- ---------------------------------------------------------------------------
-- CHAT
-- ---------------------------------------------------------------------------
create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles (id) on delete cascade,
  shop_id uuid not null references public.shops (id) on delete cascade,
  last_message text not null default '',
  last_message_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  unique (customer_id, shop_id)
);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  sender_id uuid not null references public.profiles (id) on delete cascade,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index messages_conversation_idx on public.messages (conversation_id, created_at);

-- ---------------------------------------------------------------------------
-- PESAN BANTUAN (layar Bantuan)
-- ---------------------------------------------------------------------------
create table public.support_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  name text not null,
  email text not null,
  body text not null,
  created_at timestamptz not null default now()
);

create index support_messages_user_idx on public.support_messages (user_id, created_at desc);

-- ---------------------------------------------------------------------------
-- HELPER FUNCTIONS (dipakai policy)
-- ---------------------------------------------------------------------------
create or replace function public.owns_shop(target uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.shops s
    where s.id = target and s.owner_id = auth.uid()
  );
$$;

create or replace function public.in_conversation(target uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.conversations c
    where c.id = target
      and (c.customer_id = auth.uid() or public.owns_shop(c.shop_id))
  );
$$;

-- ---------------------------------------------------------------------------
-- TRIGGER updated_at
-- ---------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();
create trigger shops_updated_at before update on public.shops
  for each row execute function public.set_updated_at();
create trigger shop_services_updated_at before update on public.shop_services
  for each row execute function public.set_updated_at();
create trigger barbers_updated_at before update on public.barbers
  for each row execute function public.set_updated_at();
create trigger bookings_updated_at before update on public.bookings
  for each row execute function public.set_updated_at();

-- Customer hanya boleh membatalkan pesanannya. Nominal, status lunas, dan
-- status pengerjaan hanya boleh diubah pemilik toko / backend service_role.
create or replace function public.guard_booking_write()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null
     or public.owns_shop(case when tg_op = 'DELETE' then old.shop_id else new.shop_id end) then
    return new;
  end if;

  if tg_op = 'INSERT' then
    new.is_paid := false;
    new.status := 'booked';
    return new;
  end if;

  new.subtotal := old.subtotal;
  new.service_fee := old.service_fee;
  -- Demo: customer hanya boleh menandai lunas, bukan membatalkan status itu.
  new.is_paid := old.is_paid or new.is_paid;
  new.customer_id := old.customer_id;
  new.walk_in_name := old.walk_in_name;
  new.shop_id := old.shop_id;
  if new.status is distinct from old.status and new.status <> 'cancelled' then
    new.status := old.status;
  end if;
  return new;
end;
$$;

create trigger bookings_guard_write before insert or update on public.bookings
  for each row execute function public.guard_booking_write();

-- ---------------------------------------------------------------------------
-- TRIGGER rating toko
-- ---------------------------------------------------------------------------
create or replace function public.sync_shop_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target uuid;
begin
  if tg_op = 'DELETE' then
    target := old.shop_id;
  else
    target := new.shop_id;
  end if;
  update public.shops s
  set rating = coalesce(
        (select round(avg(r.rating)::numeric, 1) from public.reviews r where r.shop_id = target),
        0
      ),
      review_count = (select count(*) from public.reviews r where r.shop_id = target)
  where s.id = target;
  return null;
end;
$$;

create trigger reviews_sync_shop_rating
after insert or update or delete on public.reviews
for each row execute function public.sync_shop_rating();

-- ---------------------------------------------------------------------------
-- TRIGGER ringkasan percakapan
-- ---------------------------------------------------------------------------
create or replace function public.touch_conversation()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.conversations
  set last_message = new.body,
      last_message_at = new.created_at
  where id = new.conversation_id;
  return null;
end;
$$;

create trigger messages_touch_conversation
after insert on public.messages
for each row execute function public.touch_conversation();

-- ---------------------------------------------------------------------------
-- TRIGGER pembayaran: catat baris `payments` saat booking ditandai lunas.
-- ---------------------------------------------------------------------------
create or replace function public.record_payment()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.is_paid and (tg_op = 'INSERT' or not old.is_paid) then
    insert into public.payments (booking_id, method, amount, status, paid_at)
    values (
      new.id,
      coalesce(new.payment_method, 'cash'),
      new.total_price,
      'paid',
      now()
    )
    on conflict do nothing;
  end if;
  return null;
end;
$$;

create trigger bookings_record_payment
after insert or update of is_paid on public.bookings
for each row execute function public.record_payment();

-- ============================================================================
-- GRANT
-- ============================================================================
grant usage on schema public to anon, authenticated;

-- Tamu hanya boleh membaca katalog.
grant select on public.shops, public.shop_opening_hours, public.shop_services,
  public.barbers, public.reviews to anon;

grant select, insert, update, delete on all tables in schema public to authenticated;

-- Kolom profil yang boleh diubah sendiri (role/email tidak).
revoke update on public.profiles from authenticated;
grant update (
  full_name, phone, avatar_url,
  notifications_enabled, order_notifications, sound_notifications,
  promo_notifications
) on public.profiles to authenticated;

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
alter table public.profiles enable row level security;
alter table public.shops enable row level security;
alter table public.shop_opening_hours enable row level security;
alter table public.shop_services enable row level security;
alter table public.barbers enable row level security;
alter table public.bookings enable row level security;
alter table public.booking_items enable row level security;
alter table public.payments enable row level security;
alter table public.reviews enable row level security;
alter table public.favorites enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.support_messages enable row level security;

create policy "profiles read own" on public.profiles
  for select to authenticated using (id = auth.uid());
create policy "profiles update own" on public.profiles
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
-- Mitra boleh melihat kontak customer yang pernah booking di tokonya.
create policy "profiles readable by shop owner" on public.profiles
  for select to authenticated
  using (
    exists (
      select 1 from public.bookings b
      join public.shops s on s.id = b.shop_id
      where b.customer_id = profiles.id and s.owner_id = auth.uid()
    )
  );

-- View nama & avatar untuk chat/ulasan (tanpa email/phone).
create view public.public_profiles
with (security_invoker = off) as
  select id, full_name, avatar_url from public.profiles;

grant select on public.public_profiles to anon, authenticated;

create policy "shops readable" on public.shops
  for select to anon, authenticated using (true);
create policy "shops insert own" on public.shops
  for insert to authenticated with check (owner_id = auth.uid());
create policy "shops update own" on public.shops
  for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "shops delete own" on public.shops
  for delete to authenticated using (owner_id = auth.uid());

create policy "opening hours readable" on public.shop_opening_hours
  for select to anon, authenticated using (true);
create policy "opening hours manage" on public.shop_opening_hours
  for all to authenticated using (public.owns_shop(shop_id)) with check (public.owns_shop(shop_id));

create policy "services readable" on public.shop_services
  for select to anon, authenticated using (true);
create policy "services manage" on public.shop_services
  for all to authenticated using (public.owns_shop(shop_id)) with check (public.owns_shop(shop_id));

create policy "barbers readable" on public.barbers
  for select to anon, authenticated using (true);
create policy "barbers manage" on public.barbers
  for all to authenticated using (public.owns_shop(shop_id)) with check (public.owns_shop(shop_id));

-- Insert pesanan hanya lewat RPC create_booking() (harga dihitung server).
create policy "bookings read own" on public.bookings
  for select to authenticated
  using (customer_id = auth.uid() or public.owns_shop(shop_id));
create policy "bookings update participants" on public.bookings
  for update to authenticated
  using (customer_id = auth.uid() or public.owns_shop(shop_id))
  with check (customer_id = auth.uid() or public.owns_shop(shop_id));

create policy "booking items read" on public.booking_items
  for select to authenticated
  using (exists (
    select 1 from public.bookings b
    where b.id = booking_id
      and (b.customer_id = auth.uid() or public.owns_shop(b.shop_id))
  ));

create policy "payments read" on public.payments
  for select to authenticated
  using (exists (
    select 1 from public.bookings b
    where b.id = booking_id
      and (b.customer_id = auth.uid() or public.owns_shop(b.shop_id))
  ));

create policy "reviews readable" on public.reviews
  for select to anon, authenticated using (true);
create policy "reviews insert own" on public.reviews
  for insert to authenticated
  with check (
    customer_id = auth.uid()
    and exists (
      select 1 from public.bookings b
      where b.shop_id = reviews.shop_id and b.customer_id = auth.uid()
    )
  );
create policy "reviews update" on public.reviews
  for update to authenticated
  using (customer_id = auth.uid() or public.owns_shop(shop_id))
  with check (customer_id = auth.uid() or public.owns_shop(shop_id));
create policy "reviews delete own" on public.reviews
  for delete to authenticated using (customer_id = auth.uid());

create policy "favorites own" on public.favorites
  for all to authenticated
  using (customer_id = auth.uid()) with check (customer_id = auth.uid());

create policy "conversations read" on public.conversations
  for select to authenticated
  using (customer_id = auth.uid() or public.owns_shop(shop_id));
create policy "conversations insert" on public.conversations
  for insert to authenticated
  with check (customer_id = auth.uid() or public.owns_shop(shop_id));
create policy "conversations update" on public.conversations
  for update to authenticated
  using (customer_id = auth.uid() or public.owns_shop(shop_id));

create policy "messages read" on public.messages
  for select to authenticated using (public.in_conversation(conversation_id));
create policy "messages insert" on public.messages
  for insert to authenticated
  with check (sender_id = auth.uid() and public.in_conversation(conversation_id));
create policy "messages mark read" on public.messages
  for update to authenticated using (public.in_conversation(conversation_id));

create policy "support messages insert own" on public.support_messages
  for insert to authenticated
  with check (user_id = auth.uid());
create policy "support messages read own" on public.support_messages
  for select to authenticated using (user_id = auth.uid());

-- ============================================================================
-- RPC create_booking() — harga dari DB, bukan dari aplikasi
-- ============================================================================
create or replace function public.create_booking(
  p_shop_id uuid,
  p_service_ids uuid[],
  p_scheduled_at timestamptz,
  p_barber_id uuid default null,
  p_note text default '',
  p_payment_method text default null
)
returns public.bookings
language plpgsql
security definer
set search_path = public
as $$
declare
  v_booking public.bookings;
  v_subtotal integer;
  v_code text;
  v_attempt int := 0;
begin
  if auth.uid() is null then
    raise exception 'harus login';
  end if;

  select coalesce(sum(s.price), 0)
  into v_subtotal
  from public.shop_services s
  where s.id = any (p_service_ids)
    and s.shop_id = p_shop_id
    and s.is_active;

  if v_subtotal = 0 then
    raise exception 'layanan tidak valid';
  end if;

  if p_barber_id is not null and not exists (
    select 1 from public.barbers
    where id = p_barber_id and shop_id = p_shop_id and is_active
  ) then
    raise exception 'barber tidak valid';
  end if;

  -- Slot bentrok: barber yang sama (atau tanpa barber) pada jam yang sama.
  if exists (
    select 1 from public.bookings b
    where b.shop_id = p_shop_id
      and b.status <> 'cancelled'
      and b.scheduled_at = p_scheduled_at
      and (p_barber_id is null or b.barber_id is null or b.barber_id = p_barber_id)
  ) then
    raise exception 'slot sudah dibooking';
  end if;

  -- Tolak di luar jam operasional (hari mengikuti WIB, Senin=0).
  if exists (select 1 from public.shop_opening_hours where shop_id = p_shop_id) then
    if not exists (
      select 1
      from public.shop_opening_hours h
      where h.shop_id = p_shop_id
        and h.day_of_week = extract(isodow from (p_scheduled_at at time zone 'Asia/Jakarta'))::int - 1
        and not h.is_closed
        and (p_scheduled_at at time zone 'Asia/Jakarta')::time >= h.open_time
        and (p_scheduled_at at time zone 'Asia/Jakarta')::time < h.close_time
    ) then
      raise exception 'di luar jam operasional';
    end if;
  end if;

  loop
    v_attempt := v_attempt + 1;
    v_code := 'SBH-' || to_char(p_scheduled_at at time zone 'Asia/Jakarta', 'YYMMDD-HH24MI')
              || case when v_attempt = 1 then '' else '-' || v_attempt end;
    exit when not exists (select 1 from public.bookings where code = v_code);
    if v_attempt > 9 then
      raise exception 'kode booking penuh, coba jam lain';
    end if;
  end loop;

  insert into public.bookings (
    code, customer_id, shop_id, barber_id, scheduled_at, note,
    payment_method, subtotal, service_fee
  ) values (
    v_code, auth.uid(), p_shop_id, p_barber_id, p_scheduled_at, coalesce(p_note, ''),
    p_payment_method, v_subtotal, 25000
  )
  returning * into v_booking;

  insert into public.booking_items (booking_id, service_id, name, price, duration_minutes)
  select v_booking.id, s.id, s.name, s.price, s.duration_minutes
  from public.shop_services s
  where s.id = any (p_service_ids) and s.shop_id = p_shop_id and s.is_active;

  update public.shop_services s
  set total_bookings = s.total_bookings + 1
  where s.id = any (p_service_ids);

  return v_booking;
end;
$$;

grant execute on function public.create_booking(uuid, uuid[], timestamptz, uuid, text, text)
  to authenticated;

-- ============================================================================
-- RPC walk_in_booking() — mitra menambahkan pesanan tanpa akun customer.
-- ============================================================================
create or replace function public.walk_in_booking(
  p_shop_id uuid,
  p_service_ids uuid[],
  p_scheduled_at timestamptz,
  p_customer_name text,
  p_barber_id uuid default null,
  p_note text default '',
  p_payment_method text default 'cash'
)
returns public.bookings
language plpgsql
security definer
set search_path = public
as $$
declare
  v_booking public.bookings;
  v_subtotal integer;
  v_code text;
  v_attempt int := 0;
begin
  if not public.owns_shop(p_shop_id) then
    raise exception 'hanya pemilik toko';
  end if;

  if coalesce(trim(p_customer_name), '') = '' then
    raise exception 'nama customer kosong';
  end if;

  select coalesce(sum(s.price), 0)
  into v_subtotal
  from public.shop_services s
  where s.id = any (p_service_ids)
    and s.shop_id = p_shop_id
    and s.is_active;

  if v_subtotal = 0 then
    raise exception 'layanan tidak valid';
  end if;

  if p_barber_id is not null and not exists (
    select 1 from public.barbers
    where id = p_barber_id and shop_id = p_shop_id and is_active
  ) then
    raise exception 'barber tidak valid';
  end if;

  if exists (
    select 1 from public.bookings b
    where b.shop_id = p_shop_id
      and b.status <> 'cancelled'
      and b.scheduled_at = p_scheduled_at
      and (p_barber_id is null or b.barber_id is null or b.barber_id = p_barber_id)
  ) then
    raise exception 'slot sudah dibooking';
  end if;

  loop
    v_attempt := v_attempt + 1;
    v_code := 'SBH-' || to_char(p_scheduled_at at time zone 'Asia/Jakarta', 'YYMMDD-HH24MI')
              || case when v_attempt = 1 then '' else '-' || v_attempt end;
    exit when not exists (select 1 from public.bookings where code = v_code);
    if v_attempt > 9 then
      raise exception 'kode booking penuh, coba jam lain';
    end if;
  end loop;

  insert into public.bookings (
    code, walk_in_name, shop_id, barber_id, scheduled_at, note,
    payment_method, subtotal, service_fee, status, is_paid
  ) values (
    v_code, trim(p_customer_name), p_shop_id, p_barber_id, p_scheduled_at,
    coalesce(p_note, ''), p_payment_method, v_subtotal, 0, 'waiting', false
  )
  returning * into v_booking;

  insert into public.booking_items (booking_id, service_id, name, price, duration_minutes)
  select v_booking.id, s.id, s.name, s.price, s.duration_minutes
  from public.shop_services s
  where s.id = any (p_service_ids) and s.shop_id = p_shop_id and s.is_active;

  update public.shop_services s
  set total_bookings = s.total_bookings + 1
  where s.id = any (p_service_ids);

  return v_booking;
end;
$$;

grant execute on function public.walk_in_booking(uuid, uuid[], timestamptz, text, uuid, text, text)
  to authenticated;

-- ============================================================================
-- RPC booking_slots() — jam yang sudah dipakai toko pada satu tanggal.
-- ============================================================================
create or replace function public.booked_slots(
  p_shop_id uuid,
  p_day date,
  p_barber_id uuid default null
)
returns table (slot time)
language sql
stable
security definer
set search_path = public
as $$
  select (b.scheduled_at at time zone 'Asia/Jakarta')::time
  from public.bookings b
  where b.shop_id = p_shop_id
    and b.status <> 'cancelled'
    and (b.scheduled_at at time zone 'Asia/Jakarta')::date = p_day
    and (p_barber_id is null or b.barber_id is null or b.barber_id = p_barber_id);
$$;

grant execute on function public.booked_slots(uuid, date, uuid) to anon, authenticated;

-- ============================================================================
-- RPC shop_day_slots() — jam & barber yang terisi (tanpa data customer).
-- ============================================================================
create or replace function public.shop_day_slots(
  p_shop_id uuid,
  p_day date
)
returns table (
  scheduled_at timestamptz,
  barber_name text,
  barber_image text
)
language sql
stable
security definer
set search_path = public
as $$
  select b.scheduled_at, br.name, br.image_url
  from public.bookings b
  left join public.barbers br on br.id = b.barber_id
  where b.shop_id = p_shop_id
    and b.status <> 'cancelled'
    and (b.scheduled_at at time zone 'Asia/Jakarta')::date = p_day
  order by b.scheduled_at;
$$;

grant execute on function public.shop_day_slots(uuid, date) to anon, authenticated;

-- ============================================================================
-- RPC unread_counts() — jumlah pesan belum dibaca per percakapan.
-- ============================================================================
create or replace function public.unread_counts()
returns table (conversation_id uuid, unread integer)
language sql
stable
security definer
set search_path = public
as $$
  select m.conversation_id, count(*)::integer
  from public.messages m
  join public.conversations c on c.id = m.conversation_id
  where m.sender_id <> auth.uid()
    and not m.is_read
    and (c.customer_id = auth.uid() or public.owns_shop(c.shop_id))
  group by m.conversation_id;
$$;

grant execute on function public.unread_counts() to authenticated;

-- ============================================================================
-- RPC register_shop() — dipanggil setelah login mitra pertama kali.
-- Data toko diambil dari metadata saat signUp (`shop_name`, `address`, `phone`).
-- ============================================================================
create or replace function public.register_shop()
returns public.shops
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop public.shops;
  v_name text;
  v_address text;
  v_phone text;
begin
  if auth.uid() is null then
    raise exception 'harus login';
  end if;

  select * into v_shop from public.shops where owner_id = auth.uid() limit 1;
  if found then
    return v_shop;
  end if;

  select
    coalesce(raw_user_meta_data ->> 'shop_name', ''),
    coalesce(raw_user_meta_data ->> 'address', ''),
    coalesce(raw_user_meta_data ->> 'phone', '')
  into v_name, v_address, v_phone
  from auth.users where id = auth.uid();

  if coalesce(v_name, '') = '' then
    raise exception 'nama toko kosong';
  end if;

  -- Klaim toko contoh yang belum punya pemilik bila namanya sama.
  update public.shops
  set owner_id = auth.uid()
  where id = (
    select id from public.shops
    where owner_id is null and lower(name) = lower(v_name)
    limit 1
  )
  returning * into v_shop;

  if found then
    update public.profiles set role = 'mitra' where id = auth.uid();
    return v_shop;
  end if;

  insert into public.shops (owner_id, name, address, phone, slug)
  values (
    auth.uid(), v_name, v_address, v_phone,
    lower(regexp_replace(v_name, '[^a-zA-Z0-9]+', '-', 'g')) || '-' || substr(auth.uid()::text, 1, 6)
  )
  returning * into v_shop;

  insert into public.shop_opening_hours (shop_id, day_of_week, open_time, close_time)
  select v_shop.id, d, '09:00', '20:00'
  from generate_series(0, 6) as d;

  update public.profiles set role = 'mitra' where id = auth.uid();

  return v_shop;
end;
$$;

grant execute on function public.register_shop() to authenticated;

-- ============================================================================
-- STORAGE foto (bucket publik `photos`)
-- ============================================================================
do $$
begin
  if exists (select 1 from information_schema.schemata where schema_name = 'storage') then
    insert into storage.buckets (id, name, public)
    values ('photos', 'photos', true)
    on conflict (id) do nothing;

    begin
      create policy "photos public read" on storage.objects
        for select to anon, authenticated using (bucket_id = 'photos');
    exception when duplicate_object then null;
    end;

    begin
      create policy "photos upload" on storage.objects
        for insert to authenticated
        with check (
          bucket_id = 'photos'
          and (storage.foldername(name))[2] = auth.uid()::text
        );
    exception when duplicate_object then null;
    end;

    begin
      create policy "photos update own" on storage.objects
        for update to authenticated
        using (
          bucket_id = 'photos'
          and (storage.foldername(name))[2] = auth.uid()::text
        );
    exception when duplicate_object then null;
    end;

    begin
      create policy "photos delete own" on storage.objects
        for delete to authenticated
        using (
          bucket_id = 'photos'
          and (storage.foldername(name))[2] = auth.uid()::text
        );
    exception when duplicate_object then null;
    end;
  end if;
end;
$$;

-- ============================================================================
-- REALTIME (chat & status pesanan)
-- ============================================================================
do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array['messages', 'conversations', 'bookings']
    loop
      begin
        execute format('alter publication supabase_realtime add table public.%I', t);
      exception when duplicate_object then null;
      end;
    end loop;
  end if;
end;
$$;
