# Dokumentasi REST API SisaBaik

## Chapter 8 — Autentikasi dan Otorisasi

### 1. Informasi Umum

SisaBaik merupakan aplikasi berbasis Node.js, Express, dan PostgreSQL untuk pengelolaan penawaran makanan berlebih serta transaksi pemesanan.

Pada Chapter 8, aplikasi menerapkan autentikasi menggunakan JSON Web Token (JWT), otorisasi berdasarkan peran, verifikasi penyedia, dan pembatasan akses berdasarkan kepemilikan data.

**Base URL:** `http://127.0.0.1:3000`

**Database pengembangan:** `sisabaik_dev`

Format komunikasi API menggunakan JSON.

### 2. Autentikasi Pengguna

| Method | Endpoint | Keterangan | Akses |
|---|---|---|---|
| POST | `/api/auth/registrasi` | Registrasi pembeli | Publik |
| POST | `/api/auth/registrasi-penyedia` | Registrasi penyedia | Publik |
| POST | `/api/auth/login` | Login dan penerbitan JWT | Publik |
| GET | `/api/auth/saya` | Membaca profil akun | Login |
| POST | `/api/auth/logout` | Mencabut seluruh sesi | Login |

#### 2.1 Registrasi Pembeli

**Endpoint:** `POST /api/auth/registrasi`

Contoh request:

```json
{
  "namaLengkap": "Siti Baru",
  "email": "siti.baru@example.test",
  "kataSandi": "<kata-sandi-latihan>"
}
```

Kata sandi baru harus memiliki minimal 15 karakter dan maksimal 72 byte UTF-8.

Hasil yang diharapkan adalah HTTP `201 Created`. Server menyimpan hash kata sandi dan memberikan peran `pembeli`.

#### 2.2 Registrasi Penyedia

**Endpoint:** `POST /api/auth/registrasi-penyedia`

Contoh request:

```json
{
  "namaLengkap": "Jannie",
  "email": "jannie.baru@example.test",
  "kataSandi": "<kata-sandi-latihan>",
  "namaUsaha": "Dapur Jannie",
  "alamat": "Jl. Kampus No. 8, Padang",
  "nomorTelepon": "081234567890"
}
```

Hasil yang diharapkan adalah HTTP `201 Created`.

Penyedia yang baru mendaftar memiliki status verifikasi `menunggu`. Penyedia boleh login, tetapi belum diperbolehkan mengelola penawaran sebelum usaha diverifikasi oleh operator.

#### 2.3 Login

**Endpoint:** `POST /api/auth/login`

Request:

```json
{
  "email": "jannie.baru@example.test",
  "kataSandi": "<kata-sandi-latihan>"
}
```

Jika berhasil, server mengembalikan HTTP `200 OK`, access token JWT, dan informasi pengguna.

JWT digunakan pada endpoint terlindungi melalui header:

`Authorization: Bearer <accessToken>`

Token mempunyai masa berlaku 15 menit sesuai konfigurasi autentikasi Chapter 8.

#### 2.4 Profil Pengguna

**Endpoint:** `GET /api/auth/saya`

Endpoint ini hanya dapat diakses dengan JWT valid.

Response berhasil mengembalikan HTTP `200 OK` beserta profil pengguna. Untuk penyedia, profil juga berisi informasi usaha dan status verifikasi.

#### 2.5 Logout

**Endpoint:** `POST /api/auth/logout`

Request menggunakan JWT dan body JSON kosong:

```json
{}
```

Hasil berhasil adalah HTTP `204 No Content`.

Logout meningkatkan `versi_token` pada database sehingga token yang diterbitkan sebelumnya tidak dapat digunakan kembali, termasuk token dari sesi lain.

### 3. Pengelolaan Penawaran

| Method | Endpoint | Akses |
|---|---|---|
| GET | `/api/penawaran` | Publik |
| GET | `/api/penawaran/:id` | Publik untuk penawaran tersedia |
| GET | `/api/penawaran/milik-saya` | Penyedia terverifikasi |
| POST | `/api/penawaran` | Penyedia terverifikasi |
| PUT | `/api/penawaran/:id` | Penyedia pemilik |
| DELETE | `/api/penawaran/:id` | Penyedia pemilik |

#### 3.1 Katalog Publik

**Endpoint:** `GET /api/penawaran`

Katalog publik hanya menampilkan penawaran yang memenuhi persyaratan:

- Status penawaran `aktif`.
- Stok lebih dari nol.
- Waktu berakhir belum terlewati.
- Akun penyedia aktif.
- Profil penyedia berstatus `terverifikasi`.

Parameter pencarian dan paginasi mengikuti kontrak API, termasuk `q`, `kategori`, `page`, dan `limit`.

#### 3.2 Membuat Penawaran

**Endpoint:** `POST /api/penawaran`

Contoh request:

```json
{
  "nama": "Roti Keju Jannie",
  "kategori": "Makanan",
  "hargaNormal": 15000,
  "hargaPenawaran": 10000,
  "stok": 10,
  "satuan": "pcs",
  "status": "aktif",
  "berakhirPada": "2026-10-22T15:00:00.000Z"
}
```

Field `penyediaId` tidak boleh ditentukan oleh client. Server mengambil identitas penyedia dari akun yang terautentikasi.

Hasil berhasil adalah HTTP `201 Created`.

#### 3.3 Mengubah dan Menghapus Penawaran

Endpoint `PUT` dan `DELETE` hanya dapat digunakan oleh penyedia yang memiliki penawaran tersebut.

Jika penyedia mencoba mengubah atau menghapus penawaran milik penyedia lain, server mengembalikan HTTP `404`.

Penawaran yang sudah mempunyai riwayat transaksi dapat ditolak saat dihapus untuk mempertahankan integritas data.

### 4. Pengelolaan Pesanan

| Method | Endpoint | Akses |
|---|---|---|
| GET | `/api/pesanan` | Pembeli atau penyedia yang berhak |
| GET | `/api/pesanan/:id` | Pemilik atau pihak terkait |
| POST | `/api/pesanan` | Pembeli |

#### 4.1 Membuat Pesanan

**Endpoint:** `POST /api/pesanan`

Contoh request:

```json
{
  "items": [
    {
      "penawaranId": "13",
      "kuantitas": 1
    }
  ]
}
```

Field `emailPembeli` tidak diterima pada body. Identitas pembeli diperoleh dari akun login.

Server menggunakan transaksi database untuk menjaga konsistensi stok dan mencatat detail pemesanan.

Hasil berhasil adalah HTTP `201 Created`.

#### 4.2 Membaca Pesanan

Endpoint daftar dan detail pesanan menggunakan pembatasan kepemilikan data.

Pembeli hanya dapat membaca pesanan sendiri, sedangkan penyedia hanya dapat membaca pesanan yang berkaitan dengan usahanya.

Pemeriksaan berlaku pada hasil data maupun metadata paginasi.

### 5. Middleware Keamanan

Implementasi Chapter 8 menggunakan tiga middleware utama untuk akses penyedia:

| Middleware | Fungsi |
|---|---|
| `wajibLogin` | Memvalidasi JWT dan mengisi `req.pengguna` |
| `wajibPeran` | Memastikan pengguna memiliki peran yang diizinkan |
| `wajibPenyediaTerverifikasi` | Memeriksa status verifikasi usaha |

Selain memeriksa peran, backend juga memeriksa kepemilikan penawaran dan pesanan.

Penyembunyian tombol pada frontend bukan pengganti pemeriksaan izin di server.

### 6. Kode Status dan Error

| HTTP | Kode error | Keterangan |
|---|---|---|
| 400 | Sesuai validasi input | Request tidak memenuhi kontrak |
| 401 | `AUTH_REQUIRED` | Token autentikasi tidak tersedia |
| 401 | `TOKEN_INVALID` | Token tidak valid |
| 401 | `TOKEN_EXPIRED` | Token kedaluwarsa |
| 401 | `SESSION_REVOKED` | Sesi tidak berlaku |
| 401 | `LOGIN_FAILED` | Login gagal |
| 403 | `ROLE_FORBIDDEN` | Peran tidak diizinkan |
| 403 | `PROVIDER_NOT_VERIFIED` | Profil penyedia belum terverifikasi |
| 404 | `OFFER_NOT_FOUND` | Penawaran tidak ditemukan atau tidak dapat diakses |
| 409 | `REFERENCE_CONFLICT` | Penghapusan bertentangan dengan riwayat data |
| 429 | `AUTH_RATE_LIMIT` | Batas percobaan login terlampaui |
| 429 | `REGISTRATION_RATE_LIMIT` | Batas request registrasi terlampaui |
| 500 | `INTERNAL_SERVER_ERROR` | Kesalahan internal server |

### 7. Rate Limiting

Sistem menerapkan pembatasan request untuk mencegah penyalahgunaan endpoint autentikasi.

Berdasarkan ketentuan Chapter 8:

- Login dibatasi setelah 20 request gagal dalam satu jendela pembatasan.
- Endpoint registrasi pembeli dan penyedia menggunakan batas bersama sebanyak 50 request per 15 menit.
- Respons HTTP `429` menyertakan informasi `Retry-After`.

Pengujian aktual rate limiting perlu dicatat secara terpisah.

### 8. Pengujian Autentikasi dan Otorisasi

Pengujian otomatis dijalankan menggunakan:

```bash
node --env-file=.env scripts/uji-auth.js
```

Hasil pengujian yang diperoleh:

**PASS: 44 pemeriksaan HTTP dan assertion kepemilikan/snapshot.**

Data bukti:

| Keterangan | Hasil |
|---|---|
| Database | `sisabaik_dev` |
| Penawaran uji otomatis | ID `14` |
| Pesanan uji otomatis | ID `6` |
| Pesanan manual Siti Baru | ID `5` |
| Penyedia manual | Dapur Jannie |
| Pemeriksaan otomatis | 44 PASS |

Pengujian mencakup autentikasi pengguna, validasi peran, verifikasi usaha, pembatasan kepemilikan, snapshot harga transaksi, dan pencabutan sesi.

Pada pengujian manual JWT, endpoint `/api/auth/saya` mengembalikan HTTP `200` sebelum logout dan HTTP `401` setelah logout menggunakan token lama.

Pemeriksaan database melalui pgAdmin juga menunjukkan pesanan ID `6` mempunyai total transaksi Rp5.000 dengan harga satuan Rp5.000 dan kuantitas 1.

### 9. Perlindungan Informasi Sensitif

Sistem menerapkan prinsip keamanan berikut:

- Kata sandi disimpan sebagai hash bcrypt.
- JWT diverifikasi pada setiap request terlindungi.
- Informasi sensitif tidak dikirim sebagai data publik.
- Token pada halaman latihan disimpan dalam memori.
- Secret disimpan pada environment variable.
- `.env` tidak boleh masuk repository Git.
- Peran dan identitas pemilik resource ditentukan oleh server.
- Input pengguna divalidasi sebelum diproses.

### 10. Kesimpulan

Chapter 8 menambahkan autentikasi dan otorisasi pada REST API SisaBaik.

Hasil 44 pengujian otomatis menunjukkan bahwa skenario yang dicakup script telah lulus, termasuk login, hak akses peran, kepemilikan data, verifikasi penyedia, dan pencabutan JWT.

Pengujian manual tambahan, pemeriksaan rate limit, serta bukti database didokumentasikan berdasarkan hasil aktual pada `docs/hasil-uji-chapter8.md`.
