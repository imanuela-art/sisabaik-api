# SisaBaik

SisaBaik adalah proyek berkembang pada mata kuliah Pengembangan Web. Aplikasi ini dirancang untuk membantu penyedia memulihkan nilai stok makanan berlebih melalui penjualan dengan harga khusus atau penyaluran, sekaligus membantu masyarakat memperoleh makanan yang lebih terjangkau dan mengurangi limbah pangan.

## Capaian Chapter 3

- Mempertahankan semantic HTML dan formulir aksesibel dari Chapter 2.
- Menerapkan CSS cascade, box model, dan custom properties.
- Menggunakan Flexbox untuk navigasi dan kelompok tombol.
- Menggunakan Grid untuk kartu penawaran dan bagian halaman.
- Membangun layout mobile-first dengan media queries.
- Memeriksa kontras, fokus keyboard, reflow, dan konsistensi visual.

## Halaman Prototipe

- `index.html`: halaman informasi SisaBaik.
- `daftar-penyedia.html`: formulir pendaftaran penyedia.
- `tawarkan-makanan.html`: formulir penawaran makanan berlebih.
- `styles.css`: sistem visual dan layout responsif.

Pada Chapter 3, formulir masih berupa prototipe HTML dan belum terhubung dengan server atau basis data.

## Pengembangan Backend

Pada chapter berikutnya, SisaBaik dikembangkan menggunakan Node.js, Express, dan PostgreSQL.

Backend menyediakan REST API untuk mengelola penawaran, pesanan, pengguna, serta autentikasi dan otorisasi.

Fitur yang dikembangkan mencakup:

- Pengelolaan penawaran makanan.
- Pembuatan dan pembacaan pesanan.
- Pengurangan stok melalui transaksi database.
- Registrasi dan login.
- Pembatasan akses berdasarkan peran dan kepemilikan.
- Verifikasi usaha penyedia.

## Chapter 8 — Autentikasi dan Otorisasi

### 1. Migrasi Database

Chapter 8 menggunakan migrasi `database/07_auth.sql` untuk menambahkan dua kolom pada tabel `pengguna`.

| Kolom | Fungsi |
|---|---|
| `kata_sandi_hash` | Menyimpan hash kata sandi pengguna |
| `versi_token` | Mendukung pencabutan token JWT |

Migrasi mempertahankan tabel serta riwayat data dari chapter sebelumnya.

### 2. Registrasi Pengguna

SisaBaik mendukung pendaftaran dua jenis akun:

**Pembeli**

Pembeli mendaftar menggunakan nama lengkap, email, dan kata sandi. Akun pembeli dapat digunakan untuk memesan penawaran yang tersedia.

**Penyedia**

Penyedia mengisi identitas akun dan profil usaha, termasuk nama usaha, alamat pengambilan, serta nomor telepon.

Penyedia yang baru mendaftar memiliki status verifikasi `menunggu`. Akun tersebut dapat login, tetapi belum dapat mengelola penawaran hingga usaha disetujui oleh pengelola.

Kata sandi diproses menggunakan bcrypt sebelum disimpan pada database.

### 3. Login dan JWT

Autentikasi menggunakan JSON Web Token (JWT).

Setelah pengguna berhasil login, server menerbitkan access token yang digunakan untuk mengakses endpoint terlindungi.

Token dikirim melalui HTTP header:

`Authorization: Bearer <access-token>`

JWT divalidasi berdasarkan signature, algoritma, issuer, audience, waktu kedaluwarsa, dan versi token.

Masa berlaku access token dalam konfigurasi Chapter 8 adalah 15 menit.

### 4. Otorisasi Berbasis Peran

Sistem menerapkan pembatasan akses berdasarkan peran pengguna.

| Peran | Hak akses utama |
|---|---|
| Pembeli | Melihat katalog publik dan membuat atau melihat pesanan sendiri |
| Penyedia terverifikasi | Membuat, mengubah, dan menghapus penawaran sendiri serta melihat pesanan yang menjadi tanggung jawab usahanya |
| Penyedia belum terverifikasi | Melihat profil sendiri, tetapi tidak dapat menjalankan operasi bisnis penyedia |

Selain memeriksa peran, backend juga memeriksa kepemilikan resource.

Penyedia tidak dapat mengubah penawaran milik penyedia lain, dan pembeli tidak dapat membaca pesanan pengguna lain.

Identitas pembeli maupun penyedia pada operasi bisnis ditentukan oleh server berdasarkan sesi yang terautentikasi.

### 5. Verifikasi Penyedia

Verifikasi usaha dilakukan melalui script operator.

Contoh perintah:

```bash
npm run penyedia:verifikasi -- jannie.baru@example.test
```

Perintah penolakan verifikasi:

```bash
npm run penyedia:verifikasi -- budi.baru@example.test --tolak
```

Status verifikasi dibaca kembali dari database sehingga perubahan izin dapat diterapkan tanpa pendaftaran akun baru.

### 6. Environment Variables

Konfigurasi aplikasi disimpan pada file `.env`.

Variabel yang digunakan mencakup konfigurasi koneksi PostgreSQL dan `JWT_SECRET`.

File `.env.example` menjadi referensi nama variabel tanpa menyimpan nilai rahasia.

File `.env` tidak boleh dimasukkan ke Git karena dapat mengandung password database dan secret autentikasi.

### 7. Menjalankan Aplikasi

Persyaratan lingkungan pengembangan:

- Node.js 22 atau lebih baru.
- PostgreSQL.
- Database lokal `sisabaik_dev`.
- Dependensi proyek telah terpasang.

Pasang dependensi:

```bash
npm install
```

Pastikan konfigurasi `.env` dan migrasi database sudah sesuai.

Jalankan server:

```bash
npm run dev
```

Server lokal:

`http://127.0.0.1:3000`

Halaman latihan autentikasi:

`http://127.0.0.1:3000/auth.html`

Halaman harus diakses melalui Express, bukan `file://` atau Live Server pada port lain.

### 8. Endpoint Autentikasi

| Method | Endpoint | Kegunaan |
|---|---|---|
| POST | `/api/auth/registrasi` | Registrasi pembeli |
| POST | `/api/auth/registrasi-penyedia` | Registrasi penyedia |
| POST | `/api/auth/login` | Login pengguna |
| GET | `/api/auth/saya` | Membaca profil pengguna terautentikasi |
| POST | `/api/auth/logout` | Mencabut seluruh sesi pengguna |

Detail request, response, error, dan aturan otorisasi didokumentasikan dalam `docs/API.md`.

### 9. Logout dan Pencabutan Token

Logout mencabut sesi melalui perubahan `versi_token` pada database.

JWT dengan versi lama tidak dapat digunakan kembali, termasuk token yang sudah diterbitkan pada sesi lain.

Aplikasi juga membaca status aktif pengguna ketika memvalidasi permintaan yang memerlukan autentikasi.

### 10. Keamanan Aplikasi

Mekanisme keamanan yang digunakan mencakup:

- Hash kata sandi bcrypt.
- Validasi input.
- Validasi dan kedaluwarsa JWT.
- Middleware autentikasi dan otorisasi.
- Pemeriksaan kepemilikan pada operasi database.
- Rate limiting untuk login dan registrasi.
- HTTP security headers melalui Helmet.
- Penolakan field identitas tambahan dari client.
- Token frontend disimpan dalam memori halaman latihan.
- Informasi rahasia tidak ditampilkan dalam response, log, maupun dokumentasi.

### 11. Pengujian Chapter 8

Pengujian otomatis menggunakan file:

`scripts/uji-auth.js`

Perintah menjalankan pengujian:

```bash
npm run auth:test
```

Alternatif:

```bash
node --env-file=.env scripts/uji-auth.js
```

Pengujian dijalankan pada server dan database praktikum lokal.

**Hasil aktual pengujian otomatis:**

| Keterangan | Hasil |
|---|---|
| Status | PASS |
| Pemeriksaan HTTP | 44 |
| Penawaran uji | ID 14 |
| Pesanan uji | ID 6 |
| Database | `sisabaik_dev` |

Pengujian mencakup registrasi, autentikasi, validasi JWT, pembatasan peran, verifikasi penyedia, kepemilikan penawaran dan pesanan, snapshot transaksi, serta pencabutan token.

Pengujian manual tambahan tetap perlu didokumentasikan berdasarkan hasil aktual, termasuk token kedaluwarsa, akun nonaktif, dan rate limiting.

Bukti pengujian dicatat dalam:

`docs/hasil-uji-chapter8.md`

### 12. Dokumentasi

Dokumentasi proyek meliputi:

- `README.md`: panduan dan perkembangan aplikasi.
- `docs/API.md`: kontrak REST API.
- `docs/hasil-uji-chapter8.md`: hasil pengujian autentikasi dan otorisasi.

### 13. Pengembangan Selanjutnya

Pengembangan berikutnya dapat melanjutkan implementasi antarmuka menggunakan Vue, dengan tetap mempertahankan aturan autentikasi, otorisasi, dan validasi pada backend.

## Integritas Akademik

Pengerjaan proyek berkembang mengikuti kebijakan mata kuliah. Praktik individu wajib dikerjakan sesuai ketentuan dosen, tanpa AI generatif apabila dilarang dalam modul. Mahasiswa wajib memahami dan mampu menjelaskan implementasi, pengujian, serta dokumentasi yang dikumpulkan.
