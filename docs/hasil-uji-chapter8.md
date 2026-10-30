# Hasil Pengujian Chapter 8 — SisaBaik

## Lingkungan Pengujian

- Aplikasi: SisaBaik API
- Database: sisabaik_dev
- Backend: Node.js dan Express
- Database Server: PostgreSQL
- Base URL: http://127.0.0.1:3000
- Branch: feature/auth-rbac

## Hasil Pengujian Otomatis

Perintah:
node --env-file=.env scripts/uji-auth.js

Hasil aktual:
PASS: 44 pemeriksaan HTTP dan assertion kepemilikan/snapshot.

Bukti:
- Penawaran ID: 14
- Pesanan ID: 6
- Empat akun uji otomatis dibuat.

## Hasil Pengujian Manual

| Skenario | Hasil Aktual | Status |
|---|---|---|
| Registrasi Jannie sebagai penyedia | Berhasil | PASS |
| Login Jannie | HTTP 200 | PASS |
| Status awal penyedia | menunggu | PASS |
| Verifikasi usaha Jannie | terverifikasi | PASS |
| Membuat penawaran | HTTP 201 | PASS |
| Membaca penawaran milik sendiri | HTTP 200 | PASS |
| Registrasi dan login Siti Baru | Berhasil | PASS |
| Membuat pesanan Siti | Berhasil, ID 5 | PASS |
| Membaca daftar pesanan Siti | HTTP 200 | PASS |
| JWT sebelum logout | HTTP 200 | PASS |
| JWT lama setelah logout | HTTP 401 | PASS |

## Pemeriksaan Database

Pesanan ID 6:
- Penyedia: Dapur Rina Uji
- Total transaksi: Rp5.000
- Harga penawaran satuan: Rp5.000
- Kuantitas: 1

Pesanan ID 5:
- Penyedia: Dapur Jannie
- Total transaksi: Rp10.000
- Harga penawaran satuan: Rp10.000
- Kuantitas: 1

## Pengujian Tambahan yang Perlu Dikonfirmasi

- JWT kedaluwarsa: belum ada hasil manual tercatat.
- Batas percobaan login 429: belum ada hasil manual tercatat.
- Batas registrasi 429: belum ada hasil manual tercatat.
- Penolakan login akun nonaktif: hasil belum dikonfirmasi.
- Pengujian konkurensi stok: bukti Chapter 7 perlu diperiksa.

## Kesimpulan

Pengujian otomatis Chapter 8 menghasilkan 44 PASS.

Registrasi, login, verifikasi penyedia, pembuatan
penawaran, pemesanan, serta pencabutan JWT juga
telah diuji melalui aplikasi.

Hasil pengujian tambahan harus dilengkapi berdasarkan
respons aktual sebelum laporan dinyatakan selesai.