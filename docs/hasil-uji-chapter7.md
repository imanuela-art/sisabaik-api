# Pengujian REST API SisaBaik

## Lingkungan Pengujian

Pengujian dilakukan pada REST API SisaBaik yang terhubung dengan database PostgreSQL.

- Database: `sisabaik_dev`
- Base URL: `http://127.0.0.1:3000`
- Tanggal: 13 Oktober 2026
- Tools: PowerShell, Node.js, PostgreSQL

## Hasil Pengujian

Pengujian dilakukan menggunakan script `uji-api.js` dan beberapa request HTTP melalui PowerShell.

| Pengujian | HTTP Status | Hasil |
|---|---|---|
| Koneksi API dan database | 200 | Berhasil |
| ID penawaran tidak valid | 400 | Berhasil ditolak |
| Penawaran tidak ditemukan | 404 | Sesuai |
| Tambah penawaran | 201 | Berhasil |
| Update penawaran | 200 | Berhasil |
| Hapus penawaran | 204 | Berhasil |
| Input penawaran tidak valid | 400 | Berhasil ditolak |
| Pencarian penawaran | 200 | Berhasil |
| Filter kategori roti | 200 | Ditemukan 2 data |
| Filter penawaran tersedia | 200 | Ditemukan 0 data |
| Paginasi | 200 | Berhasil |
| Paginasi tidak valid | 400 | Berhasil ditolak |
| Tambah pesanan | 201 | Berhasil |
| Pesanan dengan stok tidak cukup | 409 | Berhasil ditolak |
| Hapus penawaran yang sudah dipesan | 409 | Berhasil ditolak |

## Pengujian Otomatis

Pengujian dijalankan menggunakan perintah:

`npm run api:test`

Script berhasil menyelesaikan seluruh 29 pemeriksaan tanpa error.

Pada pengujian tersebut, pesanan dengan ID `3` berhasil dibuat. Penawaran ID `7` tetap tersimpan karena sudah digunakan dalam transaksi pesanan.

## Pengujian Konkurensi

Pengujian menggunakan file `scripts/uji-konkurensi.js` untuk memeriksa kondisi ketika dua request pesanan dikirim secara bersamaan pada penawaran dengan stok satu.

Hasil: belum dicatat.

## Catatan

- Validasi input mengembalikan HTTP 400 untuk data yang tidak sesuai.
- Penawaran yang tidak ditemukan mengembalikan HTTP 404.
- Penawaran yang sudah memiliki transaksi tidak dapat dihapus dan mengembalikan HTTP 409.
- Filter `tersedia=true` menghasilkan 0 data karena penawaran lama sudah melewati batas waktu dan penawaran uji sudah habis.
- Pengujian otomatis membuat data latihan baru di database.