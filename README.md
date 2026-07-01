# MAPAN (Sistem Pakar & Deteksi Penyakit Padi) 🌾

MAPAN adalah sistem cerdas berbasis *Mobile* dan *Web* yang ditujukan untuk membantu petani dalam mendeteksi penyakit tanaman padi menggunakan **Kecerdasan Buatan (Machine Learning/Computer Vision)**, serta menyediakan layanan terpadu berupa **Sistem Pakar**. 

Proyek ini dibangun dengan arsitektur *Client-Server* dan **REST API** yang sangat tangguh:
- **Backend & Web Dashboard:** Laravel 13, PHP 8.2, REST API, React / Inertia.js, dan SQLite.
- **Frontend Mobile:** Flutter (Android/iOS).
- **Machine Learning (AI):** Python (TensorFlow/Keras) untuk Pelatihan, berjalan sebagai ONNX Runtime di sisi *Edge/Client* (MobileNetV2).

---

## ✨ Fitur Utama Aplikasi

1. **🤖 Deteksi Penyakit AI (*Offline*):** Petani dapat memindai daun padi menggunakan kamera HP. Aplikasi akan mendeteksi penyakit dalam hitungan milidetik tanpa perlu koneksi internet!
2. **📖 Sistem Pakar (Knowledge Base):** Database ensiklopedia digital seputar pertanian yang berisi detail penyakit, daftar gejala, dan saran penanganan langsung dari pakar pertanian.
3. **👥 Sistem Multi-Role (Hak Akses):**
   - **Petani / User:** Dapat melakukan pemindaian daun dan melihat riwayat deteksi.
   - **Pakar:** Memiliki akses ke Dashboard untuk menambah/mengedit data penyakit, gejala, dan solusi.
   - **Admin / IT:** Mengelola kinerja server dan keseluruhan sistem pemetaan.
   - **Super Admin:** Memiliki akses tertinggi termasuk kontrol manajemen pengguna.
4. **📍 Pemetaan & Geotagging (Maps):** Setiap hasil pemindaian penyakit yang positif akan dicatat lokasinya (GPS) lalu ditampilkan di atas peta secara _real-time_ untuk memonitor area rawan wabah.
5. **🔔 Push Notification (FCM):** Notifikasi *real-time* berbasis Android (Heads-Up Banner) yang dikirim dari server ke aplikasi seluler untuk berbagai pembaruan status sistem pakar atau peringatan wabah.
6. **📜 Riwayat & Laporan:** Aplikasi mencatat semua log deteksi yang pernah dilakukan pengguna sehingga progres penanganan penyakit bisa terus dipantau.

---

## 🧠 Arsitektur Machine Learning (MobileNetV2 & CNN)

Fitur inti dari aplikasi MAPAN adalah kemampuan **Klasifikasi Citra (*Image Classification*)** untuk mengkategorikan foto daun ke dalam **21 kelas** kondisi/penyakit yang berbeda (seperti *Tungro*, *Brown Spot*, *Leaf Blast*, hingga daun *Healthy*/Sehat).

- **Algoritma CNN (*Convolutional Neural Network*):** Model dilatih menggunakan algoritma CNN yang bertugas melakukan ekstraksi pola visual dari daun (seperti bercak warna, bentuk lesi, atau garis kerusakan daun) melalui lapisan-lapisan matriks (*convolution layers*). 
- **Arsitektur MobileNetV2:** Kami menggunakan arsitektur **MobileNetV2** dipadukan dengan teknik **Transfer Learning** (bobot ImageNet). MobileNetV2 dipilih karena model ini didesain sangat ringan (*lightweight*) dan dioptimalkan khusus untuk beroperasi pada perangkat *mobile* berkinerja rendah (HP/Smartphone), sehingga proses *inference* (tebakan AI) bisa berlangsung instan secara *offline* namun dengan akurasi yang tetap tinggi melebihi standar sistem klasik.

---

## 📦 Daftar Library / Packages Utama

### Backend (Laravel / PHP):
- `laravel/sanctum` - Autentikasi berbasis Token (API).
- `laravel/fortify` - Autentikasi lanjutan (Two-Factor, dll).
- `kreait/laravel-firebase` - Integrasi Firebase Cloud Messaging (FCM) untuk notifikasi.
- `dedoc/scramble` - *Auto-generate* dokumentasi API (OpenAPI/Swagger).
- `inertiajs/inertia-laravel` - Rendering React/Dashboard tanpa *routing* ganda.
- `maatwebsite/excel` & `barryvdh/laravel-dompdf` - Pembuatan laporan (Export Data).
- `spatie/laravel-sitemap` - *Auto-generate* SEO Sitemap.

### Frontend (Flutter / Dart):
- `onnxruntime` - Mesin pengeksekusi model AI (MobileNetV2) secara lokal tanpa internet.
- `provider` - Manajemen *state* (State Management) utama aplikasi.
- `dio` & `http` - Client API untuk berkomunikasi dengan server Laravel.
- `firebase_messaging` & `flutter_local_notifications` - Menerima *Push Notification* (Banner/Heads-Up).
- `flutter_map` & `geolocator` - Menampilkan Peta (*OpenStreetMap*) & mengambil koordinat GPS (Geotagging).
- `camera`, `image_picker` & `image_cropper` - Mengambil & memotong gambar daun padi.
- `google_sign_in` - Akses masuk (Login) dengan metode Google/SSO.

---

## 📂 Struktur Repositori
1. `Mapan_laravel` - Berisi *source code* Backend API, Database, dan Dashboard.
2. `Mapan_flutter` - Berisi *source code* Aplikasi Mobile.
3. `ml` (Di proyek asal) - Berisi *pipeline* Machine Learning Python.

---

## 🛠️ 1. Cara Instalasi Backend (Laravel)

1. Masuk ke direktori backend:
   ```bash
   cd Mapan_laravel
   ```
2. Salin konfigurasi dan install dependensi:
   ```bash
   cp .env.example .env
   composer install
   npm install
   ```
3. Generate Key & jalankan Migrasi beserta Seeder:
   ```bash
   php artisan key:generate
   php artisan migrate:fresh --seed
   ```
4. Buat penyimpanan publik & jalankan server lokal:
   ```bash
   php artisan storage:link
   php artisan serve --port=8000
   ```

**Akun Uji Coba Default (Password: `password`):**
- `user@mapan.test` (User)
- `pakar@mapan.test` (Pakar)
- `admin@mapan.test` (Admin)
- `superadmin@mapan.test` (Super Admin)

---

## 📱 2. Cara Instalasi Frontend (Flutter)

1. Masuk ke direktori frontend:
   ```bash
   cd Mapan_flutter
   ```
2. Unduh semua *packages*:
   ```bash
   flutter pub get
   ```
3. Buka file konfigurasi `.env` / `api_client.dart`, pastikan **Base URL** mengarah ke alamat yang benar:
   - Android Emulator: `http://10.0.2.2:8000/api/v1`
   - Perangkat Fisik (WiFi sama): `http://192.168.x.x:8000/api/v1`
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## 🔔 Konfigurasi Firebase Cloud Messaging (Push Notification)

Karena alasan keamanan (mencegah kebocoran kredensial rahasia), file kunci Firebase **tidak disertakan** di repositori ini. Untuk mengaktifkan fitur *Push Notification*, ikuti langkah berikut:

### 1. Konfigurasi di Firebase Console
1. Buka [Firebase Console](https://console.firebase.google.com/) dan buat proyek baru.
2. Tambahkan aplikasi **Android** (Daftarkan *Package Name* yang sesuai dengan Flutter Anda, contoh: `com.mapan.app`).

### 2. Setup Frontend (Flutter)
1. Unduh file konfigurasi **`google-services.json`** dari Firebase Console.
2. Salin dan letakkan file tersebut tepat di dalam folder: `Mapan_flutter/android/app/google-services.json`.

### 3. Setup Backend (Laravel)
1. Di Firebase Console, masuk ke **Project Settings > Service Accounts**.
2. Klik **Generate new private key** untuk mengunduh kunci *Admin SDK*.
3. Ganti nama file `.json` tersebut (misal menjadi `firebase-auth.json`) dan letakkan di *root* direktori `Mapan_laravel/`.
4. Buka file `.env` Laravel Anda, tambahkan baris lokasi kuncinya:
   ```env
   FIREBASE_CREDENTIALS=firebase-auth.json
   ```
5. *Restart server* Laravel. Sistem kini siap menembakkan notifikasi *real-time* dari server ke HP pengguna!

---

## 🤖 3. Cara Pelatihan Model Machine Learning (ML)

Karena *dataset* citra daun padi mencapai ukuran raksasa, **file *dataset* tidak disertakan dalam repositori ini**. 

### Langkah 1: Unduh Dataset (Kaggle)
Cari dan unduh dataset dari situs **Kaggle** dengan keyword: **"Paddy Doctor: Rice Disease Classification"**.

### Langkah 2: Ekstraksi Folder Dataset
Ekstrak dataset tersebut lalu masukkan ke dalam struktur:
```text
ml/dataset_split/
├── train/
├── val/
└── test/
```

### Langkah 3: Setup Python Environment
```bash
cd ml
python -m venv .venv
.venv\Scripts\activate   # Windows
pip install tensorflow keras tf2onnx scikit-learn matplotlib pandas numpy opencv-python seaborn
```

### Langkah 4: Klasifikasi & Oversampling
Jika ada perbedaan jumlah data foto antar kelas penyakit, stabilkan dengan menjalankan:
```bash
python oversample_weak_classes.py
```

### Langkah 5: Pelatihan (Training) MobileNetV2
Jalankan file latih utama untuk melatih 21 kelas klasifikasi citra.
```bash
python train_model.py
```
*(Model yang sedang di-train akan tersimpan di dalam folder `ml/model/rice_disease_model.h5`)*

### Langkah 6: Konversi Format ke ONNX (Mobile)
Untuk membawa model Python Keras (`.h5`) agar dapat dibaca di Flutter secara *offline* secara secepat kilat, kita harus mengubah strukturnya menjadi format **ONNX**:
```bash
python convert_to_tfjs.py 
```

### Langkah 7: Integrasi ke Aplikasi Flutter
Pindahkan model keluaran (seperti `model.onnx` dan `labels.txt`) langsung ke dalam folder aset repositori Flutter Anda (`Mapan_flutter/assets/models/`). Kini, fitur AI deteksi Anda sudah hidup sepenuhnya di perangkat pengguna seluler!

---
*Dikembangkan untuk Tugas UTS / Ujian Akhir Tahun 2026.* 🎓
