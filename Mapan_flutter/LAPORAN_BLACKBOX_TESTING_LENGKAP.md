# Laporan Pengujian Blackbox (Blackbox Testing Report)
## Aplikasi Mapan (Sistem Cerdas Pendeteksi Hama dan Penyakit Tanaman Padi)

**Tanggal Pengujian:** 27-28 Juni 2026
**Metode Pengujian:** Blackbox Testing (Equivalence Partitioning, Boundary Value Analysis, Error Guessing)
**Alat Pengujian Otomatis:** Pest PHP (Laravel Testing Framework)

---

## BAGIAN I: PENGUJIAN BERDASARKAN METODE (UNIFIED TEST CASES)

Pada bagian ini, kami mengelompokkan skenario pengujian berdasarkan teknik *Blackbox Testing* yang digunakan. Hal ini bertujuan untuk menguji sistem dari berbagai perspektif masukan (input) dan memastikan bahwa semua fitur utama (Autentikasi, AI Deteksi, Peta Sebaran, Riwayat, Notifikasi, dan Pengajuan Pakar) ditangani dengan benar.

### 1. Equivalence Partitioning (EP)
Metode ini membagi domain input menjadi kelas-kelas data yang ekuivalen, di mana pengujian satu nilai dalam kelas tersebut dianggap mewakili seluruh kelas.

| Fitur | Skenario Pengujian | Input Data (Kelas Ekuivalen) | Hasil yang Diharapkan | Status |
|---|---|---|---|---|
| **Login** | Pengguna memasukkan kredensial akun valid | Email/No HP valid & Password benar | Berhasil masuk, menerima token autentikasi | ✅ Passed |
| **Register** | Pengguna mendaftar dengan data lengkap dan valid | Nama, Email unik, No HP unik, Password valid | Akun terbuat, mengembalikan status 201 Created | ✅ Passed |
| **Lupa Password** | Mengirimkan kode OTP ke email terdaftar | Email: `user@example.com` (terdaftar) | Sistem mengirimkan kode OTP 6 digit | ✅ Passed |
| **Verifikasi OTP** | Memasukkan kode OTP yang benar | OTP: `123456` (cocok dengan database) | Berhasil diverifikasi, lanjut ke reset password | ✅ Passed |
| **Reset Password** | Memasukkan password baru yang memenuhi syarat | Password baru >= 8 karakter & cocok dengan konfirmasi | Sandi berhasil diperbarui | ✅ Passed |
| **Logout** | Pengguna keluar sistem dari status login | Header Auth: `Bearer {valid_token}` | Sesi dihapus, token dicabut | ✅ Passed |
| **AI Deteksi (Model AI)** | Mendeteksi 20 jenis penyakit, 1 Sehat, 1 Bukan Padi | Foto padi dengan ciri Blast, Tungro, Sehat, dll. | Sistem mengenali ke-22 label (class) dengan tepat. | ✅ Passed |
| **Peta Sebaran** | Filter data berdasarkan ID Penyakit & Waktu | `disease_id=1`, `start_date=2026-05-01`, `end_date=2026-06-01` | Peta hanya menampilkan wabah penyakit 1 di bulan Mei | ✅ Passed |
| **Statistik Peta** | Menampilkan statistik jumlah penyakit dikelompokkan per kota | Akses ke endpoint `/admin/map-statistics` | Mengembalikan JSON statistik jumlah wabah per Kota/Provinsi | ✅ Passed |
| **Riwayat Deteksi** | Mengakses riwayat dengan filter metode | `method=image` atau `method=expert_system` | Menampilkan hanya hasil potret atau sistem pakar | ✅ Passed |
| **Notifikasi** | Membaca notifikasi pembaruan status atau laporan baru | Menandai seluruh atau sebagian notifikasi sebagai dibaca | `read_at` terisi, *unread count* berkurang | ✅ Passed |
| **Pengajuan Pakar** | Mengajukan permohonan menjadi pakar dengan dokumen | File CV & Portofolio berformat PDF (< 2MB) | Pengajuan berstatus *pending*, menunggu review admin | ✅ Passed |

---

### 2. Boundary Value Analysis (BVA)
Metode ini menguji nilai-nilai di batas ekstrem dari rentang input yang diperbolehkan untuk mendeteksi kesalahan pada validasi batasan sistem.

| Fitur | Skenario Pengujian | Input Data (Batas Ekstrem) | Hasil yang Diharapkan | Status |
|---|---|---|---|---|
| **Register** | Panjang password minimal 8 karakter | `password` = "1234567" (7 karakter) | Sistem menolak dengan pesan validasi "minimal 8 karakter" | ✅ Passed |
| **Register** | Pendaftaran dengan format Email tidak valid | `email` = "user.com" (tanpa @) | Ditolak karena format email salah | ✅ Passed |
| **Lupa Password** | Batas limit request OTP dalam 1 menit (Rate Limiting) | Melakukan 6x request OTP di menit yang sama | Permintaan ke-6 ditolak (Status 429 Too Many Requests) | ✅ Passed |
| **Peta Sebaran** | Tanggal tidak diisi (Omitted Dates) | `start_date` = null, `end_date` = null | Sistem secara *default* otomatis memuat 30 hari terakhir saja | ✅ Passed |
| **Riwayat Deteksi** | Paginasi `per_page` berada di luar batas bawah | `per_page` = 0 | Ditolak karena minimal 1 item (422 Validation Error) | ✅ Passed |
| **Riwayat Deteksi** | Paginasi `per_page` berada di luar batas atas | `per_page` = 51 | Ditolak karena maksimal 50 item (422 Validation Error) | ✅ Passed |
| **Pengajuan Pakar** | Validasi ukuran dokumen pengajuan maksimal 2 MB | File PDF ukuran = 2.5 MB | Ditolak karena melebihi batas ukuran maksimal (*Payload Too Large*) | ✅ Passed |
| **AI Deteksi** | Input *confidence score* dari AI | `confidence` = -5 atau 110 | *(Backend System)* Menerima atau menolak logika batas 0-100 | ✅ Passed |

---

### 3. Error Guessing (EG)
Metode ini mengandalkan pengalaman *tester* (atau logika tak terduga) untuk menebak kesalahan yang mungkin tidak terdeteksi oleh EP atau BVA. Melibatkan data kotor, kondisi gagal (*negative testing*), atau logika privasi.

| Fitur | Skenario Pengujian | Input Data / Kondisi | Hasil yang Diharapkan | Status |
|---|---|---|---|---|
| **Login** | Percobaan masuk dengan kredensial salah | Email benar, Password salah (atau sebaliknya) | Status 401 Unauthorized, kredensial tidak cocok | ✅ Passed |
| **Verifikasi OTP** | Menggunakan OTP kadaluarsa (Expired Token) | OTP valid secara angka, tetapi berumur > 15 menit | Status 400/422, OTP telah hangus/kadaluarsa | ✅ Passed |
| **Reset Password** | Konfirmasi password baru tidak cocok (*Mismatch*) | `password` = "A", `password_confirmation` = "B" | Validasi gagal, sistem meminta agar sandi cocok | ✅ Passed |
| **Logout** | Logout tanpa token yang valid (Unauthenticated) | Memanggil API Logout tanpa *Bearer Token* | Status 401 Unauthorized | ✅ Passed |
| **Riwayat Deteksi** | Data riwayat yang di-hide (*is_hidden_from_user*) | Endpoint `/detections` dipanggil oleh user | Deteksi yang di-*hide* **tidak boleh** muncul di JSON Response | ✅ Passed |
| **Notifikasi** | Menandai notifikasi yang tidak ada menjadi terbaca | Memasukkan ID Notifikasi palsu/UUID ngawur | Status 404 Not Found, sistem menangani dengan aman (tidak crash) | ✅ Passed |
| **Peta Sebaran** | Memanipulasi format tanggal pencarian (*Malformed Date*) | `start_date` = "2026/06/27" (Bukan Y-m-d) | Ditangani secara aman tanpa Crash (500 Error) | ✅ Passed |
| **Pengajuan Pakar** | User biasa memaksa mengubah status laporannya sendiri | Mencoba memanggil API `/review` tanpa akses admin | Status 403 Forbidden | ✅ Passed |

---

## BAGIAN II: PENILAIAN INTEGRASI (OVERALL INTEGRATION)

### 1. Uji Kelengkapan Model Penyakit (22 Kelas ML)
Sistem Mapan secara total mendukung 22 hasil klasifikasi AI untuk deteksi awal tanaman padi:

*   **Penyakit/Hama**: Bacterial Leaf Blight, Bacterial Leaf Streak, Bacterial Panicle Blight, Blast, Brown Spot, Dead Heart, Downy Mildew, Hispa, Leaf Roller, Tungro, White Stem Borer, Yellow Stem Borer, Rice Water Weevil, Planthopper, Stem Borer, Sheath Blight, False Smut, Narrow Brown Leaf Spot, Grassy Stunt, Ragged Stunt.
*   **Status Lainnya**: Healty (Sehat), Bukan Padi (Non-Rice).
*(Setiap label tersebut telah diintegrasikan dengan kamus terjemahan Bahasa Indonesia di sisi Frontend serta memiliki logika `severity` yang spesifik ketika dikonfirmasi pakar)*.

### 2. Validasi Kolom Severity Oleh Pakar
Pengujian juga memvalidasi bahwa ketika seorang pakar melakukan "Konfirmasi Laporan" pada menu Detail Deteksi, semua kolom berstatus **Wajib Diisi**, termasuk tingkat severity (Sehat, Ringan, Waspada/Awas, Berbahaya). Data tersebut menjadi landasan utama yang mengendalikan visualisasi warna klaster pada *Map Dashboard Page*.

### 3. Keamanan File dan API Privasi
API riwayat deteksi pengguna yang di-flag privasi (`is_hidden_from_user` = true) dipastikan **tidak bocor** kepada *user endpoints*. Sebaliknya, untuk *Map Statistics* admin/pakar, seluruh data tetap dikonsumsi agar statistik persebaran penyakit (Heatmap/Marker) beroperasi dengan lengkap dan akurat.

---
**Catatan Akhir Laporan**: 
Seluruh pengujian fungsionalitas di atas telah diuji secara menyeluruh dan terintegrasi penuh ke dalam sistem pengujian otomatis (*Automated Tests*) di sisi backend dengan status kelulusan **100% (Passed)**.
