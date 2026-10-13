const pool = require('../config/db');

async function findAvailableOffers() {
  const sql = `
    SELECT
      p.id_penawaran,
      p.jenis_makanan,
      p.jumlah_porsi,
      p.tanggal_kadaluarsa,
      p.waktu_kadaluarsa,
      p.lokasi_pengambilan,
      p.status,
      p.catatan,
      p.gambar_url,
      py.nama AS nama_penyedia
    FROM penawaran p
    JOIN penyedia py
      ON py.id_penyedia = p.id_penyedia
    WHERE p.status = 'Tersedia'
    ORDER BY
      p.tanggal_kadaluarsa ASC,
      p.waktu_kadaluarsa ASC
  `;

  const result = await pool.query(sql);
  return result.rows;
}

module.exports = {
  findAvailableOffers,
};