CREATE TABLE IF NOT EXISTS penyedia (
  id_penyedia SERIAL PRIMARY KEY,
  nama VARCHAR(150) NOT NULL,
  no_telepon VARCHAR(30) NOT NULL,
  alamat TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS penerima (
  id_penerima SERIAL PRIMARY KEY,
  nama VARCHAR(150) NOT NULL,
  no_telepon VARCHAR(30) NOT NULL,
  alamat TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS penawaran (
  id_penawaran VARCHAR(30) PRIMARY KEY,
  id_penyedia INTEGER NOT NULL REFERENCES penyedia(id_penyedia),
  jenis_makanan VARCHAR(120) NOT NULL,
  jumlah_porsi INTEGER NOT NULL CHECK (jumlah_porsi > 0),
  tanggal_kadaluarsa DATE NOT NULL,
  waktu_kadaluarsa TIME NOT NULL,
  lokasi_pengambilan TEXT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Tersedia'
    CHECK (status IN ('Tersedia', 'Diklaim', 'Selesai', 'Dibatalkan')),
  catatan TEXT,
  gambar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS klaim (
  id_klaim SERIAL PRIMARY KEY,
  id_penawaran VARCHAR(30) NOT NULL UNIQUE
    REFERENCES penawaran(id_penawaran) ON DELETE CASCADE,
  id_penerima INTEGER NOT NULL REFERENCES penerima(id_penerima),
  waktu_klaim TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  status VARCHAR(20) NOT NULL DEFAULT 'Aktif'
    CHECK (status IN ('Aktif', 'Dibatalkan', 'Selesai')),
  catatan TEXT
);

CREATE INDEX IF NOT EXISTS idx_penawaran_status
  ON penawaran(status);

CREATE INDEX IF NOT EXISTS idx_penawaran_kadaluarsa
  ON penawaran(tanggal_kadaluarsa, waktu_kadaluarsa);

CREATE INDEX IF NOT EXISTS idx_klaim_penerima
  ON klaim(id_penerima);