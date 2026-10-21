
# Hasil Pengujian Chapter 8 — SisaBaik

## Lingkungan
- Database: sisabaik_dev
- Server: http://127.0.0.1:3000
- Branch: feature/auth-rbac

## Pengujian Otomatis
Perintah:
node --env-file=.env scripts/uji-auth.js

Hasil:
PASS: 44 pemeriksaan HTTP dan assertion kepemilikan/snapshot.

- Penawaran uji: ID 14
- Pesanan uji: ID 6

## Pengujian Manual
- Registrasi dan login Jannie berhasil.
- Verifikasi penyedia Jannie berhasil.
- Penawaran aktif berhasil dibuat.
- Pesanan Siti Baru berhasil dibuat (ID 5).
- JWT sebelum logout: HTTP 200.
- JWT setelah logout: HTTP 401.

## Pemeriksaan Database
- Pesanan ID 6: total Rp5.000, kuantitas 1.
- Pesanan ID 5: total Rp10.000, kuantitas 1.

## Pengujian yang Belum Dikonfirmasi
- Token kedaluwarsa.
- Rate limiting login dan registrasi.
- Penolakan token akun nonaktif secara manual.
