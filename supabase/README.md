# Setup Supabase SalonHub

Semua data aplikasi (auth, database, foto) berasal dari project Supabase
`https://yjmhqpsovlhanglpepmz.supabase.co`. URL dan publishable key ada di
`lib/main.dart`.

## 1. Jalankan SQL

Buka **SQL Editor** di dashboard Supabase, lalu jalankan berurutan:

1. `supabase/schema.sql` — enum, tabel, trigger, RLS, RPC, bucket `photos`,
   dan realtime.
2. `supabase/seed.sql` (opsional) — 5 barbershop contoh, jam operasional,
   layanan, dan barber Masterpiece Barbershop.

Jalankan sekali di project kosong. Mengulang `schema.sql` akan gagal di
`create type` (objek sudah ada); mengulang `seed.sql` akan gagal di `slug`
unik. Tidak ada perintah yang menghapus data.

## 2. Upload foto

Foto contoh memakai bucket publik `photos`. Unggah aset lokal:

```bash
SUPABASE_SERVICE_ROLE_KEY=... ./supabase/upload-assets.sh
```

Service role key hanya untuk skrip ini, jangan dimasukkan ke aplikasi.
Foto yang diunggah dari aplikasi (avatar, toko, layanan, barber) masuk ke
bucket yang sama lewat `AuthService.uploadPhoto`.

## 3. Pengaturan Auth

- **Email confirmation** harus aktif bila memakai layar OTP. Ubah template
  *Confirm signup* agar memakai token 6 digit: `{{ .Token }}`.
- Bila email confirmation dimatikan, pendaftaran langsung masuk ke aplikasi.
- Minimal panjang password: 6 karakter (validasi juga ada di aplikasi).

## 4. Akun mitra

Daftar lewat **Mitra → Daftar** dengan nama toko. Saat login pertama,
`register_shop()` membuat atau mengklaim tepat satu toko dari metadata
pendaftaran (`shop_name`, `address`, `phone`). Database memiliki unique index
`shops_one_per_owner`, sehingga satu akun mitra tidak bisa memiliki dua toko.
Bila nama toko sama dengan toko seed yang belum punya pemilik, toko itu
diklaim — misalnya daftar dengan nama `Masterpiece Barbershop` untuk
mengelola data seed.

## 5. Aturan penting

- Booking dibuat lewat RPC `create_booking()`; harga dihitung dari database
  dan kode dibuat `SBH-YYMMDD-HHMI` (WIB).
- Customer hanya bisa membatalkan booking dan menandai pembayaran lunas
  (tidak bisa membatalkan status lunas). Status pengerjaan dan nominal hanya
  bisa diubah pemilik toko lewat trigger `guard_booking_write`.
- `profiles` hanya bisa dibaca pemilik akun dan pemilik toko yang pernah
  menerima booking dari customer tersebut. Nama/avatar publik ada di view
  `public_profiles`.
- Ulasan hanya bisa ditulis customer yang punya booking di toko itu; trigger
  `sync_shop_rating` menjaga `shops.rating` dan `review_count`.
- Tabel `messages`, `conversations`, dan `bookings` masuk publication
  `supabase_realtime`.
- `walk_in_booking()` hanya bisa dipanggil pemilik toko; customer booking
  biasa hanya bisa lewat `create_booking()`.
- Booking customer dan walk-in ditolak jika slot bentrok atau di luar jam
  operasional. Pembayaran yang ditandai lunas otomatis dicatat ke `payments`.
- Favorit memakai tabel `favorites`; pesan bantuan memakai
  `support_messages`; unread chat memakai RPC `unread_counts()`.
