
<script setup>
import Ikon from "../components/Ikon.vue";
import { ref, watch, onUnmounted, nextTick } from "vue";
import FormPenawaran from "../components/FormPenawaran.vue";
import KartuPenawaran from "../components/KartuPenawaran.vue";
import StatusBaca from "../components/StatusBaca.vue";
import Paginasi from "../components/Paginasi.vue";
import { useBaca } from "../composables/useBaca.js";
import { api, pesanError } from "../lib/api.js";
import { sesi } from "../lib/sesi.js";

const page = ref(1);
const statusFilter = ref("");
const menyimpan = ref(false);
const berhasil = ref(0);
const errorSimpan = ref("");
const pesan = ref("");
const waktu = ref(Date.now());
const sedangEdit = ref(null);
const areaForm = ref(null);
const konflik = ref(false);

const pilihanStatus = [
  { value: "", label: "Semua status" },
  { value: "draft", label: "Draft" },
  { value: "aktif", label: "Aktif" },
  { value: "habis", label: "Habis" },
  { value: "kedaluwarsa", label: "Kedaluwarsa" },
];

async function ubah(penawaran) {
  sedangEdit.value = { ...penawaran };
  konflik.value = false;
  errorSimpan.value = "";
  pesan.value = "";

  await nextTick();
  areaForm.value?.querySelector("#nama")?.focus();
  areaForm.value?.scrollIntoView({
    behavior: "auto",
    block: "start",
  });
}

const controller = new AbortController();

async function muatVersiTerbaru() {
  const id = sedangEdit.value?.id;
  if (!id || menyimpan.value) return;

  menyimpan.value = true;

  try {
    const hasil = await api("/api/penawaran/milik-saya/" + id, {
      auth: true,
      signal: controller.signal,
    });

    await ubah(hasil.data);
  } catch (e) {
    if (e.name !== "AbortError") {
      errorSimpan.value = pesanError(e);
    }
  } finally {
    menyimpan.value = false;
  }
}

const timer = setInterval(() => {
  waktu.value = Date.now();
}, 1000);

onUnmounted(() => {
  clearInterval(timer);
  controller.abort();
});

// Mengambil penawaran berdasarkan halaman dan status.
const { data, sibuk, error, muat } = useBaca((signal) => {
  const params = new URLSearchParams({
    page: String(page.value),
    limit: "2",
  });

  if (statusFilter.value) {
    params.set("status", statusFilter.value);
  }

  return api(`/api/penawaran/milik-saya?${params.toString()}`, {
    auth: true,
    signal,
  });
});

// Memuat ulang data saat halaman berubah.
watch(page, muat, { immediate: true });

// Saat filter berubah, kembali ke halaman pertama.
watch(statusFilter, () => {
  if (page.value !== 1) {
    page.value = 1;
  } else {
    muat();
  }
});

async function simpan(body) {
  if (menyimpan.value || sesi.keluar) return;

  menyimpan.value = true;
  errorSimpan.value = "";
  pesan.value = "";

  try {
    const mengedit = Boolean(sedangEdit.value);

    const hasil = await api(
      mengedit
        ? "/api/penawaran/" + sedangEdit.value.id
        : "/api/penawaran",
      {
        method: mengedit ? "PUT" : "POST",
        auth: true,
        body,
        signal: controller.signal,
      },
    );

    sedangEdit.value = null;
    berhasil.value++;
    konflik.value = false;
    pesan.value = `Penawaran ${hasil.data.id} berhasil disimpan.`;

    if (page.value !== 1) {
      page.value = 1;
    } else {
      await muat();
    }
  } catch (e) {
    if (e.name !== "AbortError") {
      errorSimpan.value = pesanError(e);
      konflik.value = e.code === "OFFER_CHANGED";
    }
  } finally {
    menyimpan.value = false;
  }
}
</script>

<template>
  <section
    class="container workspace section"
    aria-labelledby="judul-penyedia"
  >
    <div class="page-heading">
      <div>
        <p class="eyebrow">
          <Ikon nama="toko" />
          Ruang usaha Anda
        </p>

        <h1 id="judul-penyedia">
          Kelola penawaran usaha saya
        </h1>

        <p class="muted">
          Makanan berlebih tetap punya peluang. Buat penawaran
          yang jelas agar pembeli mudah memilih.
        </p>
      </div>

      <RouterLink
        class="button button-secondary"
        to="/pesanan"
      >
        <Ikon nama="tas" />
        Pesanan masuk
      </RouterLink>

      <RouterLink
        class="button button-secondary"
        to="/dashboard"
      >
        <Ikon nama="grafik" />
        Lihat dashboard
      </RouterLink>
    </div>

    <div class="provider-layout">
      <div ref="areaForm" class="provider-form-area">
        <FormPenawaran
          :sibuk="menyimpan || sesi.keluar"
          :berhasil="berhasil"
          :penawaran="sedangEdit"
          @simpan="simpan"
          @batal="
            sedangEdit = null;
            errorSimpan = '';
            konflik = false;
          "
        />

        <p
          v-if="pesan"
          class="notice notice-success"
          role="status"
          aria-live="polite"
        >
          <Ikon nama="cek" />
          {{ pesan }}
        </p>

        <div
          v-if="errorSimpan"
          class="notice notice-error"
        >
          <div>
            <p role="alert">
              {{ errorSimpan }}
            </p>

            <p>
              Isian dipertahankan. Jika koneksi terputus,
              muat ulang daftar dan periksa penawaran
              sebelum mengirim kembali.
            </p>

            <button
              v-if="konflik"
              type="button"
              class="button-secondary"
              @click="muatVersiTerbaru"
            >
              Muat versi terbaru
            </button>
          </div>
        </div>
      </div>

      <aside class="provider-guide">
        <span class="icon-tile">
          <Ikon nama="daun" />
        </span>

        <h2>
          Penawaran yang baik dimulai dari informasi yang jelas.
        </h2>

        <ol>
          <li>
            <strong>Beri nama yang spesifik</strong>
            <p>
              Jelaskan jenis makanan dan satuannya
              agar pembeli tahu apa yang dipesan.
            </p>
          </li>

          <li>
            <strong>Tentukan harga & stok</strong>
            <p>
              Harga penawaran tidak melebihi harga normal.
              Nilai nol berarti penawaran gratis.
            </p>
          </li>

          <li>
            <strong>Perhatikan waktu</strong>
            <p>
              Status aktif akan tampil di katalog selama
              stok dan batas waktunya masih tersedia.
            </p>
          </li>
        </ol>

        <div class="guide-note">
          <Ikon nama="aman" />

          <p>
            Hanya tawarkan makanan yang masih layak konsumsi.
            Informasi kondisi, alergen, dan penyimpanan perlu
            disampaikan dengan jujur.
          </p>
        </div>
      </aside>
    </div>

    <!-- DAFTAR PENAWARAN -->
    <div class="section-heading offer-list-heading">
      <div>
        <p class="eyebrow">
          Daftar usaha Anda
        </p>

        <h2>Penawaran milik saya</h2>

        <p class="muted">
          Penawaran draft dan aktif tetap dapat
          dilihat oleh pemilik akun.
        </p>
      </div>

      <button
        class="button-secondary"
        type="button"
        :disabled="sibuk || menyimpan"
        @click="muat"
      >
        <Ikon nama="ulang" />
        Perbarui daftar
      </button>
    </div>

    <!-- FILTER STATUS: LATIHAN CHAPTER 10 -->
    <div class="offer-status-filter">
      <label for="filter-status">
        Filter status penawaran
      </label>

      <select
        id="filter-status"
        v-model="statusFilter"
        :disabled="menyimpan || sesi.keluar"
      >
        <option
          v-for="pilihan in pilihanStatus"
          :key="pilihan.value"
          :value="pilihan.value"
        >
          {{ pilihan.label }}
        </option>
      </select>
    </div>

    <!-- LOADING DAN ERROR -->
    <StatusBaca
      :sibuk="sibuk"
      :error="error"
      @ulang="muat"
    />

    <!-- HASIL KOSONG -->
    <div
      v-if="!sibuk && !error && data && !data.data.length"
      class="empty-state"
    >
      <span class="icon-tile">
        <Ikon nama="toko" />
      </span>

      <h3>
        Belum ada penawaran pada halaman ini.
      </h3>

      <p v-if="statusFilter">
        Tidak ada penawaran dengan status yang dipilih.
      </p>

      <p v-else>
        Isi formulir di atas untuk mulai menawarkan makanan Anda.
      </p>
    </div>

    <!-- KARTU PENAWARAN -->
    <div
      v-if="data && !error && data.data.length"
      class="daftar catalog-grid"
    >
      <KartuPenawaran
        v-for="p in data.data"
        :key="p.id"
        :penawaran="p"
        :waktu-sekarang="waktu"
        :boleh-ubah="!menyimpan"
        @ubah="ubah"
      />
    </div>

    <!-- PAGINATION -->
    <Paginasi
      v-if="data && !error"
      :meta="data.meta"
      :sibuk="sibuk || menyimpan"
      @halaman="page = $event"
    />
  </section>
</template>
