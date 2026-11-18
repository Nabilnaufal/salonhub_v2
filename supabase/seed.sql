-- ============================================================================
-- Data contoh (opsional) — jalankan setelah schema.sql.
-- Foto memakai bucket Storage `photos`. Upload dulu dengan:
--   SUPABASE_SERVICE_ROLE_KEY=... ./supabase/upload-assets.sh
-- ============================================================================

-- 5 barbershop supaya halaman Home / Explore / Cari Barber ada isinya.
insert into public.shops
  (name, slug, description, address, phone, image_url, gallery, facilities,
   latitude, longitude, rating, review_count)
values
  (
    'Masterpiece Barbershop',
    'masterpiece-barbershop',
    'Di Masterpiece Barbershop, tim ahli cukur kami yang berpengalaman siap '
      'memberikan hasil terbaik dan mengubah penampilan rambutmu.',
    'Jl. Kaliurang KM 5, No. 18, Sleman, Yogyakarta',
    '0812 3456 7890',
    'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_haircut_2.jpg',
    array[
      'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_interior_1.jpg',
      'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_interior_2.jpg',
      'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_haircut_1.jpg',
      'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_exterior_1.jpg'
    ],
    array['AC','WiFi','Free Drink','TV','Parkir','Card Payment','Musala'],
    -7.7508, 110.3794, 4.9, 128
  ),
  (
    'Alana Barbershop',
    'alana-barbershop',
    'Haircut, massage, dan spa dengan barber ramah.',
    'Bangun Sari, Yogyakarta',
    '0812 1111 2222',
    'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_interior_1.jpg',
    array[]::text[],
    array['AC','WiFi','Parkir'],
    -7.7489, 110.3778, 4.5, 64
  ),
  (
    'Hercha Barbershop',
    'hercha-barbershop',
    'Haircut & styling harian.',
    'Jalan Karya, Yogyakarta',
    '0812 3333 4444',
    'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_haircut_1.jpg',
    array[]::text[],
    array['AC','Parkir'],
    -7.7448, 110.3819, 5.0, 41
  ),
  (
    'Barberking',
    'barberking',
    'Haircut styling & massage.',
    'Medan Kota',
    '0812 5555 6666',
    'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_interior_2.jpg',
    array[]::text[],
    array['AC','WiFi','TV'],
    -7.7532, 110.3848, 4.5, 23
  ),
  (
    'Twinsky Monkey Barber',
    'twinsky-monkey-barber',
    'Barber & men stuff.',
    'Jl. Taman Siswa, Yogyakarta',
    '0812 7777 8888',
    'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/barbershop_exterior_1.jpg',
    array[]::text[],
    array['AC','Parkir','Card Payment'],
    -7.7583, 110.3782, 5.0, 37
  );

-- Jam operasional 7 hari untuk semua toko (Senin=0 ... Minggu=6).
insert into public.shop_opening_hours (shop_id, day_of_week, open_time, close_time)
select s.id, d.day, d.open_time::time, d.close_time::time
from public.shops s
cross join (values
  (0, '09:00', '20:00'), (1, '09:00', '20:00'), (2, '09:00', '20:00'),
  (3, '09:00', '20:00'), (4, '09:00', '21:00'), (5, '09:00', '21:00'),
  (6, '10:00', '18:00')
) as d(day, open_time, close_time);

-- Layanan Masterpiece.
insert into public.shop_services (shop_id, name, description, price, duration_minutes, image_url, is_active)
select s.id, v.name, v.description, v.price, v.duration,
       'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/' || v.image,
       v.is_active
from public.shops s
cross join (values
  ('Basic haircut',   'Potong rambut dasar & vitamin',   20000, 30, 'barbershop_haircut_3.jpg', true),
  ('Kids haircut',    'Potong rambut khusus anak',       15000, 25, 'barbershop_exterior_1.jpg', true),
  ('Hair coloring',   'Pewarnaan rambut pilihan',        30000, 60, 'barbershop_haircut_1.jpg', true),
  ('Hair treatment',  'Perawatan rambut & scalp massage', 10000, 20, 'barbershop_interior_2.jpg', true),
  ('Special massage', 'Pijat kepala & bahu tambahan',    10000, 15, 'barbershop_interior_1.jpg', false)
) as v(name, description, price, duration, image, is_active)
where s.slug = 'masterpiece-barbershop';

-- Tim barber Masterpiece.
insert into public.barbers (shop_id, name, role, rating, image_url, shift_start, shift_end)
select s.id, v.name, v.role, v.rating,
       'https://yjmhqpsovlhanglpepmz.supabase.co/storage/v1/object/public/photos/' || v.image,
       v.start_time::time, v.end_time::time
from public.shops s
cross join (values
  ('Luther Hammes',   'Specialist Haircut',   5.0, 'barbershop_haircut_3.jpg',  '09:00', '17:00'),
  ('Emanuel Bernier', 'Specialist Coloring',  4.5, 'barbershop_haircut_1.jpg',  '10:00', '18:00'),
  ('Karl Vandervort', 'Specialist Treatment', 4.5, 'barbershop_interior_1.jpg', '12:00', '20:00')
) as v(name, role, rating, image, start_time, end_time)
where s.slug = 'masterpiece-barbershop';

-- Setelah akun mitra dibuat lewat aplikasi, hubungkan toko ke pemiliknya:
--   select public.register_shop();  -- dipanggil aplikasi saat login mitra
-- atau manual:
--   update public.shops set owner_id = (select id from auth.users where email = 'mitra@salonhub.id')
--   where slug = 'masterpiece-barbershop';
