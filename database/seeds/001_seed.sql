INSERT INTO penyedia (nama, no_telepon, alamat)
VALUES
  ('Kantin Bu Rina', '081234567890', 'Jl. Melati No. 10'),
  ('Dapur Pak Budi', '081298765432', 'Jl. Kenanga No. 5')
ON CONFLICT DO NOTHING;

INSERT INTO penerima (nama, no_telepon, alamat)
VALUES
  ('Andi', '081111111111', 'Jl. Mawar No. 1'),
  ('Siti', '082222222222', 'Jl. Anggrek No. 2')
ON CONFLICT DO NOTHING;

INSERT INTO penawaran (
  id_penawaran,
  id_penyedia,
  jenis_makanan,
  jumlah_porsi,
  tanggal_kadaluarsa,
  waktu_kadaluarsa,
  lokasi_pengambilan,
  status,
  catatan,
  gambar_url
)
VALUES
  (
    'OFF001',
    1,
    'Nasi Kotak',
    10,
    CURRENT_DATE + 1,
    '18:00',
    'Kantin Bu Rina',
    'Tersedia',
    'Ambil sebelum jam 6 sore',
    '/images/nasi-kotak.jpg'
  ),
  (
    'OFF002',
    2,
    'Roti dan Kue',
    15,
    CURRENT_DATE + 1,
    '20:00',
    'Dapur Pak Budi',
    'Tersedia',
    NULL,
    '/images/roti-kue.jpg'
  )
ON CONFLICT DO NOTHING;
