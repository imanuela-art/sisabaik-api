# Hasil Pengujian Chapter 9 — Frontend Vue

## 1. Informasi Pengujian

| Informasi | Keterangan |
|---|---|
| Proyek | SisaBaik |
| Chapter | 9 — Membangun Antarmuka dengan Vue |
| Pemeriksa | [Isi nama pemeriksa] |
| Node.js | 22.23.2 |
| npm | 10.9.8 |
| Vue | 3.5.43 |
| Vite | 8.3.3 |
| Branch | `feature/vue-components` |
| Commit | [Isi setelah commit] |

## 2. Hasil Pengujian Fungsional

| No. | Skenario Pengujian | Hasil |
|---|---|---|
| 1 | Menampilkan katalog penawaran | PASS |
| 2 | Pencarian penawaran | PASS |
| 3 | Menampilkan empty state ketika hasil tidak ditemukan | PASS |
| 4 | Filter berdasarkan kategori | PASS |
| 5 | Memilih penawaran | PASS |
| 6 | Menampilkan ringkasan pilihan | PASS |
| 7 | Validasi formulir kosong | PASS |
| 8 | Menolak harga penawaran yang melebihi harga normal | PASS |
| 9 | Menambahkan penawaran baru | PASS |
| 10 | Pergantian tampilan pembeli dan penyedia | PASS |
| 11 | Data kembali ke kondisi awal setelah refresh | PASS |
| 12 | Menampilkan ilustrasi dan ikon | PASS |
| 13 | Tampilan responsif pada lebar 375, 768, dan 1280 piksel | PASS |
| 14 | Navigasi menggunakan keyboard | PASS |
| 15 | Penawaran kedaluwarsa tidak lagi ditampilkan | PASS |
| 16 | Production build menggunakan Vite | PASS |
| 17 | Menjalankan production preview | PASS |

## 3. Hasil Pengujian Data

### Tampilan Pembeli

- Jumlah penawaran tersedia: 3.
- Jumlah stok tersedia: 15 unit.
- Jumlah penyedia: 2.

### Tampilan Penyedia

- Jumlah seluruh penawaran: 3.
- Jumlah penawaran tersedia: 2.
- Jumlah stok tersedia: 9 unit.

### Pengujian Penambahan Penawaran

Penawaran latihan berhasil ditambahkan melalui formulir penyedia dan muncul pada tampilan pembeli.

Data tambahan hanya tersimpan sementara di memori aplikasi. Setelah halaman dimuat ulang, aplikasi kembali menggunakan data latihan awal.

## 4. Aliran Data Antarkomponen

Komunikasi antarkomponen Vue menggunakan `props` dan `emits`.

| Komponen | Props | Emits |
|---|---|---|
| `KartuPenawaran.vue` | `penawaran`, `waktuSekarang`, `bolehPilih` | `pilih` |
| `FilterPenawaran.vue` | `pencarian`, `kategori`, `daftarKategori` | `ubah-pencarian`, `ubah-kategori`, `reset` |
| `FormPenawaran.vue` | - | `simpan` |

`App.vue` menjadi komponen utama yang mengelola data dan menghubungkan komponen-komponen tersebut.

## 5. Hasil Production Build

Perintah:

```bash
npm run build
```

Hasil:

| Informasi | Hasil |
|---|---|
| Status | Berhasil |
| Modul diproses | 23 |
| Ukuran CSS | 11.72 kB |
| Ukuran JavaScript | 100.48 kB |
| Waktu build | 960 ms |

## 6. Batasan Pengujian

- Data frontend masih menggunakan data latihan.
- Data penawaran baru belum disimpan secara permanen.
- Frontend belum terintegrasi dengan REST API backend.
- Pengujian dilakukan secara manual melalui browser.

## 7. Kesimpulan

Berdasarkan pengujian yang dilakukan, komponen dan fitur utama frontend SisaBaik berjalan sesuai skenario pengujian. Production build juga berhasil dijalankan.

## 8. Bukti Pengujian

Screenshot hasil pengujian disimpan dalam direktori `docs/bukti-chapter9/`.

| File | Bukti |
|---|---|
| `01-katalog-pembeli.png.png` | Katalog pembeli |
| `field kosong.png` | Pengujian field kosong |
| `filter roti n kue.png` | Filter kategori |
| `npm run build.png` | Hasil production build |
| `roti 6 paket.png` | Tampilan penawaran roti |
| `tambah penawaran.png` | Penambahan penawaran |
| `uji flexilibilitas ui.png` | Pengujian responsivitas UI |