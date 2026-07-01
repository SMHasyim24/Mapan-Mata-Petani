import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'feedback_pages.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'chatbot_page.dart';
import 'detection_detail_page.dart';
import 'package:mapan/expert_application_page.dart';
import 'package:mapan/admin_application_page.dart';
import 'package:mapan/expert_application_list_page.dart';
import 'package:mapan/map_dashboard_page.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'services/ml_service.dart';
import 'detection_result_modal.dart';
import 'admin_pages.dart';
import 'edit_profile_page.dart';
import 'services/notification_service.dart';
import 'auth_pages.dart';
import 'notifications_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'services/offline_queue_service.dart';
import 'package:shimmer/shimmer.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await AppLogger.load();
  
  NotificationService.initialize().catchError((e) {
    print("Firebase init failed: $e");
  });

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppLanguage()),
        ChangeNotifierProvider(create: (_) => AppTheme()),
        ChangeNotifierProvider(create: (_) => AppNotifications()),
      ],
      child: MapanApp(
        initialPage: token != null ? const ClimateShell() : const OnboardingPage(),
      ),
    ),
  );
  
  FlutterNativeSplash.remove();
}

class AppLanguage extends ChangeNotifier {
  String _languageCode = 'id';
  String get languageCode => _languageCode;

  void toggleLanguage() {
    _languageCode = _languageCode == 'id' ? 'en' : 'id';
    notifyListeners();
  }
}

class AppTranslations {
  static const Map<String, Map<String, String>> _dict = {
    'id': {
      'home': 'Beranda',
      'detection': 'Deteksi',
      'add': 'Tambah',
      'profile': 'Pengaturan',
      'about': 'Tentang Aplikasi',
      'logout': 'Keluar Akun',
      'login': 'Masuk API',
      'search': 'Cari laporan...',
      'language': 'Bahasa Indonesia',
      'language_label': 'Bahasa',
      'dark_mode': 'Mode Gelap',
      'edit_profile': 'Edit Profil',
      'change_password': 'Ubah Kata Sandi',
      'notifications': 'Notifikasi',
      'help_center': 'Pusat Bantuan',
      'privacy': 'Kebijakan Privasi',
      'settings': 'Pengaturan',
      'app_desc': 'Sistem Pakar & Deteksi Penyakit Padi',
      'welcome': 'Selamat Datang',
      'reports': 'Laporan Lapangan',
      'dashboard': 'Dasbor',
      'history': 'Riwayat',
      'exit_app': 'Keluar Aplikasi',
      'confirm': 'Konfirmasi',
      'cancel': 'Batal',
      'yes_exit': 'Ya, Keluar',
      'exit_msg': 'Apakah Anda yakin ingin keluar dari aplikasi?',
      'account_management': 'Manajemen Akun',
      'app_preferences': 'Preferensi Aplikasi',
      'support_about': 'Bantuan & Informasi',
      'total_detection': 'TOTAL DETEKSI',
      'disease_detected': 'PENYAKIT TERDETEKSI',
      'avg_accuracy': 'AKURASI RATA-RATA',
      'weekly_report': 'LAPORAN MINGGUAN',
      'detect_disease': 'Deteksi Penyakit',
      'refresh_api': 'Refresh Data API',
      'recent_activity': 'Aktivitas Terkini',
      'see_all': 'Lihat Semua',
      'data_management': 'Manajemen Data',
      'disease': 'Penyakit',
      'symptom': 'Gejala',
      'solution': 'Solusi',
      'page': 'Halaman',
      'of': 'dari',
      'all_reports': 'Semua Laporan',
      'database': 'Database Penyakit',
      'workspace': 'Ruang Kerja',
      'expert_management': 'Manajemen Pakar',
      'user_management': 'Kelola Pengguna',
      'system_logs': 'Sistem Log',
      'main_view': 'Tampilan Utama',
      'morning': 'Selamat Pagi,',
      'afternoon': 'Selamat Siang,',
      'evening': 'Selamat Sore,',
      'night': 'Selamat Malam,',
      'weather': 'Cuaca',
      'plant_condition': 'Kondisi Tanaman',
      'optimal': 'Optimal',
      'land_insight': 'Insight Lahan Anda',
      'ask_expert': 'Ajukan Pakar',
      'bug_report': 'Laporan Bug & Masukan',
      'app_feedback_center': 'Pusat Masukan Aplikasi',
      'this_month': 'bulan ini',
      'this_week': 'MINGGU INI',
      'history_title': 'Riwayat Deteksi',
      'history_desc':
          'Daftar riwayat deteksi penyakit yang pernah Anda lakukan.',
      'all': 'Semua',
      'reports_filter': 'Laporan',
      'verified': 'TERVERIFIKASI',
      'create_report': 'Buat Laporan Baru',
      'photo_attachment': 'Lampiran Foto',
      'tap_to_select_photo': 'Ketuk untuk Pilih Foto / Kamera',
      'report_info': 'Informasi Laporan',
      'report_title_label': 'Judul Laporan',
      'report_title_hint': 'Contoh: Analisis gagal panen ar...',
      'field_location': 'Lokasi Lahan',
      'location_hint': 'Pilih atau cari lokasi...',
      'disease_type': 'Tipe Penyakit / Hama',
      'report_detail': 'Detail Laporan',
      'ai_detection_result': 'Hasil Deteksi AI',
      'user_label': 'Pengguna',
      'notes': 'Catatan',
      'notes_hint': 'Tuliskan detail temuan lapangan, tingkat kerusakan, dan langkah penanganan...',
      'notes_required': 'Catatan wajib diisi',
      'no_notifications': 'Belum ada notifikasi',
      'confirm_delete': 'Konfirmasi Hapus',
      'confirm_delete_account': 'Hapus Akun?',
      'confirm_delete_account_desc': 'Apakah Anda yakin ingin menghapus akun ini?',
      'delete_account_warning': 'Menghapus akun akan menghapus semua data Anda secara permanen termasuk riwayat deteksi.',
      'delete_account': 'Hapus Akun',
      'delete': 'Hapus',
      'complaint_notes': 'Keluhan / Catatan:',
      'expert_recommendation': 'Rekomendasi & Catatan Pakar',
      'edit_recommendation': 'Edit Rekomendasi & Catatan',
      'confirm_logout_desc': 'Apakah Anda yakin ingin keluar dari akun ini?',
      'onboarding_1_title': 'DETEKSI CERDAS AI',
      'onboarding_1_desc': 'Pindai daun padi dengan kamera Anda. Teknologi AI kami akan melakukan diagnosis awal secara instan.',
      'onboarding_1_pill': 'Scan Cepat',
      'onboarding_2_title': 'VALIDASI PAKAR',
      'onboarding_2_desc': 'Laporan deteksi akan dikirim ke Pakar Pertanian asli untuk dianalisis ulang agar hasilnya 100% akurat.',
      'onboarding_2_pill': 'Uji Akurasi',
      'onboarding_3_title': 'SOLUSI PASTI',
      'onboarding_3_desc': 'Terima hasil akhir yang sudah disetujui Pakar, lengkap dengan rekomendasi penanganan paling tepat untuk Anda.',
      'onboarding_3_pill': 'Rekomendasi Ahli',
      'failed_load_notifications': 'Gagal memuat notifikasi:',
      'delete_notifications': 'Hapus Notifikasi',
      'confirm_delete_read_notifications': 'Apakah Anda yakin ingin menghapus semua notifikasi yang sudah dibaca?',
      'failed_load_report_detail': 'Gagal memuat detail laporan.',
      'access_denied_not_admin': 'Akses Ditolak: Anda bukan Admin.',
      'open_web_admin_system': 'Silakan buka versi Web (Sistem Admin) untuk melihat detail ini.',
      'failed_load_map': 'Gagal memuat peta:',
      'disease_details': 'Rincian Penyakit:',
      'see_report': 'Lihat Laporan',
      'outbreak_spread_map': 'Peta Sebaran Wabah',
      'downloading_report': 'Mengunduh Laporan',
      'download_success_opening': 'Berhasil diunduh. Membuka file...',
      'failed_download': 'Gagal mengunduh:',
      'download_pdf': 'Unduh PDF',
      'download_excel': 'Unduh Excel',
      'failed_load_report_data': 'Gagal memuat data laporan:',
      'report_in': 'Laporan di',
      'no_report_in_city': 'Tidak ada laporan di kota ini.',
      'profile_updated': 'Profil berhasil diperbarui',
      'failed_update_profile': 'Gagal memperbarui profil:',
      'photo_uploaded': 'Foto berhasil diunggah',
      'failed_upload_photo': 'Gagal mengunggah foto:',
      'photo_deleted': 'Foto berhasil dihapus',
      'failed_delete_photo': 'Gagal menghapus foto:',
      'account_deleted': 'Akun berhasil dihapus',
      'failed_delete_account': 'Gagal menghapus akun:',
      'take_photo_from_camera': 'Ambil Foto dari Kamera',
      'choose_from_gallery': 'Pilih dari Galeri',
      'or_text': 'ATAU',
      'dont_have_account': 'Belum punya akun? ',
      'already_have_account': 'Sudah punya akun? ',
      'otp_sent_to_email': 'Kode OTP berhasil dikirim ke email.',
      'password_changed_login': 'Password berhasil diubah. Silakan Login.',
      'repeat_password': 'Ulangi Password',
      'your_email': 'Email Anda',
      'otp_code': 'Kode OTP',
      'new_password': 'Password Baru',
      'report_success_status': 'Laporan berhasil',
      'report_from': 'Laporan dari',
      'capture_location': 'Lokasi Pengambilan',
      'reason_for_rejection': 'Berikan alasan mengapa laporan ini ditolak:',
      'reject_report': 'Tolak Laporan',
      'actual_disease_diagnosis': 'Diagnosa Penyakit Aktual (Opsional)',
      'prediction_accuracy': 'Akurasi / Tingkat Prediksi (%)',
      'save_and_confirm': 'SIMPAN & KONFIRMASI',
      'accept_report_caps': 'TERIMA LAPORAN',
      'reject_report_caps': 'TOLAK LAPORAN',
      'other_possibilities': 'Kemungkinan Lainnya:',
      'see_disease_details': 'Lihat Detail Penyakit',
      'save_detection': 'Simpan Deteksi',
      'save_report': 'Simpan Laporan',
      'diprediksi_ai_caps': 'DIPREDIKSI AI',
      'pending_caps': 'MENUNGGU',
      'cancel_or_rescan': 'Batal / Pindai Ulang',
      'login_required_report': 'Anda harus login untuk membuat laporan.',
      'login_required_save_detection': 'Anda harus login untuk menyimpan deteksi.',
      'detection_saved': 'Deteksi berhasil disimpan ke riwayat.',
      'failed_open_scanner': 'Gagal membuka pemindai:',
      'please_login_first': 'Silakan login terlebih dahulu',
      'local_device_scan': 'Pemindaian Perangkat Lokal',
      'generic_disease_description': 'Sistem mendeteksi adanya pola kerusakan daun. Mohon periksa panduan penanganan di aplikasi untuk mencegah penyebaran.',
      'password_not_match': 'Konfirmasi kata sandi tidak cocok',
      'password_min_8_chars': 'Kata sandi baru minimal 8 karakter',
      'password_updated': 'Kata sandi berhasil diperbarui',
      'login_to_detect': 'Masuk untuk deteksi',
      'uploading_profile_photo': 'Mengunggah foto profil...',
      'profile_photo_updated': 'Foto profil berhasil diperbarui!',
      'deleting_profile_photo': 'Menghapus foto profil...',
      'profile_photo_deleted': 'Foto profil berhasil dihapus!',
      'failed_update_error': 'Gagal memperbarui:',
      'take_from_camera': 'Ambil dari Kamera',
      'login_success': 'Login berhasil.',
      'login_failed': 'Login gagal:',
      'open_settings': 'Buka Pengaturan',
      'analyzing_image_ai': 'Menganalisis gambar dengan AI...',
      'system_failed_detect': 'Maaf, sistem gagal mendeteksi gambar tersebut.',
      'invalid_image': 'Gambar Tidak Valid',
      'delete_all_logs_confirm': 'Hapus Semua Log?',
      'cannot_open_uri': 'Tidak dapat membuka',
      'accuracy_label': 'Akurasi',
      'additional_desc': 'Tambahkan deskripsi detail penyakit (gejala, penyebab, cara penanganan)',
      'additional_notes': 'Catatan Tambahan',
      'additional_notes_hint': 'Tulis catatan tambahan di sini...',
      'admin': 'Admin',
      'admin_response_label': 'Balasan Admin',
      'ai_action_recommendation': 'Rekomendasi Tindakan (AI)',
      'app_already_status': 'Pengajuan sudah berstatus',
      'app_approved_success': 'Pengajuan berhasil disetujui.',
      'app_rejected_success': 'Pengajuan berhasil ditolak.',
      'application_reason': 'Alasan Pengajuan',
      'approve_caps': 'SETUJUI',
      'approved': 'Disetujui',
      'approved_desc': 'Selamat! Anda sekarang menjadi pakar. Anda tidak perlu mengajukan lagi.',
      'area_statistics': 'Statistik Area',
      'attachment_label': 'Lampiran',
      'attachment_optional': 'Lampiran Screenshot (Opsional)',
      'bug_error': 'Bug/Error Teknis',
      'cases': 'Kasus',
      'change_role': 'Ubah Peran',
      'change_role_btn': 'Ubah Peran',
      'close': 'Tutup',
      'confirm_delete_multiple': 'Apakah Anda yakin ingin menghapus',
      'confirm_delete_name': 'Hapus pengguna ini?',
      'confirm_delete_single': 'Apakah Anda yakin ingin menghapus laporan ini?',
      'cv_document': 'Dokumen CV / Sertifikasi',
      'data_not_found': 'Data tidak ditemukan',
      'delete_failed': 'Gagal menghapus',
      'delete_success': 'Berhasil dihapus',
      'delete_user_under_construction': 'Fitur hapus pengguna sedang dalam pengembangan',
      'detailed_desc': 'Deskripsi Detail',
      'disease_explanation': 'Penjelasan Penyakit',
      'disease_list': 'Daftar Penyakit',
      'disease_name': 'Nama Penyakit',
      'disease_save_success': 'Penyakit berhasil disimpan',
      'dosage_optional': 'Dosis (Opsional)',
      'download_report': 'Unduh Laporan',
      'edit': 'Edit',
      'email': 'Email',
      'empty_data': 'Data kosong',
      'error': 'Error:',
      'expert': 'Pakar',
      'expert_app_submitted': 'Pengajuan berhasil dikirim!',
      'expert_application': 'Pengajuan Pakar',
      'expert_recommendation_notes': 'Rekomendasi & Catatan Pakar',
      'expert_review': 'Peninjauan Pakar',
      'expert_review_title': 'Peninjauan Pakar',
      'failed': 'Gagal',
      'failed_delete': 'Gagal menghapus:',
      'failed_load_data': 'Gagal memuat data:',
      'failed_load_expert_app_status': 'Gagal memuat status pengajuan:',
      'failed_load_image': 'Gagal memuat gambar',
      'failed_load_queue': 'Gagal memuat antrean:',
      'failed_load_report': 'Gagal memuat laporan:',
      'failed_load_user': 'Gagal memuat data pengguna:',
      'failed_process': 'Gagal memproses:',
      'failed_save': 'Gagal menyimpan:',
      'feature_suggestion': 'Saran Fitur',
      'feature_under_construction': 'Fitur ini sedang dalam pengembangan',
      'file_available': 'File tersedia',
      'final_expert_diagnosis': 'Diagnosa Akhir Pakar:',
      'from_reports': '% dari laporan',
      'full_name': 'Nama Lengkap',
      'general_question': 'Pertanyaan Umum',
      'initial_ai_diagnosis': 'Diagnosa Awal AI:',
      'latin_name_optional': 'Nama Latin (Opsional)',
      'login_required_delete': 'Anda harus login untuk menghapus.',
      'main_cause': 'Penyebab Utama',
      'new_symptom': 'Gejala Baru',
      'new_treatment': 'Solusi Baru',
      'no_additional_complaints': 'Tidak ada keluhan tambahan yang ditulis.',
      'no_report_yet': 'Belum ada laporan',
      'no_response_yet': 'Belum ada balasan',
      'open': 'Buka',
      'open_web_download': 'Buka Web untuk mengunduh',
      'password': 'Kata Sandi',
      'pending_tasks': 'Tugas Menunggu',
      'pick_doc_image': 'Pilih Dokumen / Gambar',
      'pick_image_gallery': 'Pilih Gambar dari Galeri',
      'priority_0_9': 'Prioritas (0-9)',
      'priority_queue': 'Antrean Prioritas',
      'processing_caps': 'DIPROSES',
      'recent_reports': 'Laporan Terbaru',
      'reject_caps': 'TOLAK',
      'rejected': 'Ditolak',
      'rejected_caps': 'DITOLAK',
      'rejected_desc': 'Maaf, pengajuan Anda ditolak. Anda dapat mengajukan ulang.',
      'related_disease': 'Penyakit Terkait',
      'report_content': 'Isi Laporan / Keluhan',
      'report_content_label': 'Isi Laporan',
      'report_details': 'Detail Laporan',
      'report_empty_error': 'Isi laporan tidak boleh kosong',
      'report_sent_failed': 'Gagal mengirim laporan:',
      'report_sent_success': 'Laporan berhasil dikirim!',
      'report_type': 'Jenis Laporan',
      'report_waiting_review': 'Laporan ini menunggu peninjauan Anda. Anda dapat menerima laporan ini jika valid, atau menolaknya.',
      'reporter': 'Pelapor',
      'reports_count': 'Laporan',
      'reports_label': 'Laporan',
      'review_desc': 'Dokumen Anda sudah diterima dan sedang dalam antrean peninjauan oleh Super Admin.',
      'role_change_failed': 'Gagal mengubah peran:',
      'role_change_success': 'Peran berhasil diubah',
      'save': 'Simpan',
      'select_disease_first': 'Pilih penyakit terlebih dahulu',
      'send_reply': 'Kirim Balasan',
      'send_report': 'Kirim Laporan',
      'server_response_status': 'Server merespons dengan status',
      'solution_desc': 'Deskripsi Solusi / Penanganan',
      'submit_application': 'Kirim Pengajuan',
      'super_admin': 'Super Admin',
      'symptom_code_example': 'Kode Gejala (Contoh: G001)',
      'symptom_name': 'Nama Gejala',
      'symptom_save_success': 'Gejala berhasil disimpan',
      'top_disease': 'Penyakit Terbanyak',
      'total_diseases': 'Total\nPenyakit',
      'total_reports': 'Total\nLaporan',
      'total_reports_inline': 'Total Laporan',
      'treatment_save_success': 'Solusi berhasil disimpan',
      'treatment_type': 'Jenis Penanganan',
      'trending_now': 'Sedang Menjadi Tren',
      'under_review': 'Sedang Ditinjau',
      'unit_optional': 'Satuan (Opsional)',
      'unknown': 'Tidak Diketahui',
      'upload_certification_doc': 'Silakan unggah dokumen sertifikasi',
      'upload_desc': 'Unggah dokumen sertifikasi atau bukti keahlian Anda',
      'user': 'Pengguna',
      'verified_caps': 'TERVERIFIKASI',
      'verify': 'Verifikasi',
      'waiting_caps': 'MENUNGGU',
      'welcome_expert': 'Selamat Bertugas,',
      'add_disease': 'Tambah Penyakit',
      'edit_disease': 'Edit Penyakit',
      'add_symptom': 'Tambah Gejala',
      'edit_symptom': 'Edit Gejala',
      'add_treatment': 'Tambah Penanganan',
      'edit_treatment': 'Edit Penanganan',
      'expert_mapan': 'Pakar Mapan',
      'no_description': 'Tidak ada deskripsi',
      'google_login_success': 'Berhasil masuk dengan Google! Selamat datang.',
      'google_token_failed': 'Gagal mendapatkan token dari Google.',
      'password_confirm_mismatch': 'Konfirmasi password tidak cocok.',
      'failed_send_otp': 'Gagal mengirim OTP:',
      'location_not_available': 'Lokasi belum tersedia',
      'failed_submit_application': 'Gagal mengirim pengajuan',
      'no_feedback_reports': 'Belum ada laporan atau masukan dari pengguna.',
      'confirm_new_password': 'Konfirmasi Kata Sandi Baru',
      'failed_generic': 'Gagal:',
      'failed_delete_generic': 'Gagal menghapus:',
      'scan_plant': 'Pindai Tanaman',
      'scan_your_plant': 'Pindai Tanamanmu',
      'no_photo_added': 'Belum ada foto yang ditambahkan',
      'add_photo': 'Tambah Foto',
      'delete_all_read': 'Hapus Semua yang Dibaca',
      'new_notification': 'Notifikasi Baru',
      'failed_scan': 'Gagal memindai:',
      'location_unknown': 'Lokasi Tidak Diketahui',
      'role_expert': 'Pakar',
      'role_user': 'Pengguna',
      'detection_label': 'Deteksi',
      'detection_prefix': 'Deteksi',
      'failed_upload_generic': 'Gagal mengunggah foto',
    },
    'en': {
      'home': 'Home',
      'detection': 'Detection',
      'add': 'Add',
      'profile': 'Settings',
      'about': 'About Mapan',
      'logout': 'Logout Account',
      'login': 'Login API',
      'search': 'Search reports...',
      'language': 'English',
      'language_label': 'Language',
      'dark_mode': 'Dark Mode',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'notifications': 'Notifications',
      'help_center': 'Help Center',
      'privacy': 'Privacy Policy',
      'settings': 'Settings',
      'app_desc': 'Rice Disease Detection & Expert System',
      'welcome': 'Welcome',
      'reports': 'Field Reports',
      'dashboard': 'Dashboard',
      'history': 'History',
      'exit_app': 'Exit Application',
      'confirm': 'Confirmation',
      'cancel': 'Cancel',
      'yes_exit': 'Yes, Exit',
      'exit_msg': 'Are you sure you want to exit the app?',
      'account_management': 'Account Management',
      'support_about': 'Support & About',
      'total_detection': 'TOTAL DETECTIONS',
      'disease_detected': 'DISEASES DETECTED',
      'avg_accuracy': 'AVG ACCURACY',
      'weekly_report': 'WEEKLY REPORTS',
      'detect_disease': 'Detect Disease',
      'refresh_api': 'Refresh API Data',
      'recent_activity': 'Recent Activity',
      'see_all': 'See All',
      'data_management': 'Data Management',
      'disease': 'Disease',
      'symptom': 'Symptom',
      'solution': 'Solution',
      'page': 'Page',
      'of': 'of',
      'all_reports': 'All Reports',
      'database': 'Disease Database',
      'workspace': 'Workspace',
      'expert_management': 'Expert Management',
      'user_management': 'Manage Users',
      'system_logs': 'System Logs',
      'main_view': 'Main View',
      'morning': 'Good Morning,',
      'afternoon': 'Good Afternoon,',
      'evening': 'Good Evening,',
      'night': 'Good Night,',
      'weather': 'Weather',
      'plant_condition': 'Plant Condition',
      'optimal': 'Optimal',
      'land_insight': 'Your Land Insight',
      'ask_expert': 'Ask Expert',
      'bug_report': 'Bug Report & Feedback',
      'app_feedback_center': 'App Feedback Center',
      'this_month': 'this month',
      'this_week': 'THIS WEEK',
      'history_title': 'Detection History',
      'history_desc':
          'List of plant disease detection history you have performed.',
      'all': 'All',
      'reports_filter': 'Reports',
      'verified': 'VERIFIED',
      'create_report': 'Create New Report',
      'photo_attachment': 'Photo Attachment',
      'tap_to_select_photo': 'Tap to Select Photo / Camera',
      'report_info': 'Report Information',
      'report_title_label': 'Report Title',
      'report_title_hint': 'Example: Crop failure analysis ar...',
      'field_location': 'Field Location',
      'location_hint': 'Select or search location...',
      'disease_type': 'Disease / Pest Type',
      'report_detail': 'Report Detail',
      'ai_detection_result': 'AI Detection Result',
      'user_label': 'User',
      'notes': 'Notes',
      'notes_hint': 'Write details of field findings, damage level, and handling steps...',
      'notes_required': 'Notes are required',
      'no_notifications': 'No notifications yet',
      'confirm_delete': 'Confirm Delete',
      'confirm_delete_account': 'Delete Account?',
      'confirm_delete_account_desc': 'Are you sure you want to delete this account?',
      'delete_account_warning': 'Deleting your account will permanently remove all your data including detection history.',
      'delete_account': 'Delete Account',
      'delete': 'Delete',
      'complaint_notes': 'Complaint / Notes:',
      'expert_recommendation': 'Expert Recommendation & Notes',
      'edit_recommendation': 'Edit Recommendation & Notes',
      'confirm_logout_desc': 'Are you sure you want to log out from this account?',
      'onboarding_1_title': 'SMART AI DETECTION',
      'onboarding_1_desc': 'Scan rice leaves with your camera. Our AI technology will perform an initial diagnosis instantly.',
      'onboarding_1_pill': 'Quick Scan',
      'onboarding_2_title': 'EXPERT VALIDATION',
      'onboarding_2_desc': 'Detection reports will be sent to real Agriculture Experts for re-analysis so the results are 100% accurate.',
      'onboarding_2_pill': 'Accuracy Test',
      'onboarding_3_title': 'SURE SOLUTION',
      'onboarding_3_desc': 'Receive final results approved by Experts, complete with the most appropriate handling recommendations for you.',
      'onboarding_3_pill': 'Expert Recommendation',
      'failed_load_notifications': 'Failed to load notifications:',
      'delete_notifications': 'Delete Notifications',
      'confirm_delete_read_notifications': 'Are you sure you want to delete all read notifications?',
      'failed_load_report_detail': 'Failed to load report detail.',
      'access_denied_not_admin': 'Access Denied: You are not an Admin.',
      'open_web_admin_system': 'Please open the Web version (Admin System) to view these details.',
      'failed_load_map': 'Failed to load map:',
      'disease_details': 'Disease Details:',
      'see_report': 'See Report',
      'outbreak_spread_map': 'Outbreak Spread Map',
      'downloading_report': 'Downloading Report',
      'download_success_opening': 'Successfully downloaded. Opening file...',
      'failed_download': 'Failed to download:',
      'download_pdf': 'Download PDF',
      'download_excel': 'Download Excel',
      'failed_load_report_data': 'Failed to load report data:',
      'report_in': 'Report in',
      'no_report_in_city': 'No report in this city.',
      'profile_updated': 'Profile updated successfully',
      'failed_update_profile': 'Failed to update profile:',
      'photo_uploaded': 'Photo uploaded successfully',
      'failed_upload_photo': 'Failed to upload photo:',
      'photo_deleted': 'Photo deleted successfully',
      'failed_delete_photo': 'Failed to delete photo:',
      'account_deleted': 'Account deleted successfully',
      'failed_delete_account': 'Failed to delete account:',
      'take_photo_from_camera': 'Take Photo from Camera',
      'choose_from_gallery': 'Choose from Gallery',
      'or_text': 'OR',
      'dont_have_account': 'Don\'t have an account? ',
      'already_have_account': 'Already have an account? ',
      'otp_sent_to_email': 'OTP code successfully sent to email.',
      'password_changed_login': 'Password successfully changed. Please Login.',
      'repeat_password': 'Repeat Password',
      'your_email': 'Your Email',
      'otp_code': 'OTP Code',
      'new_password': 'New Password',
      'report_success_status': 'Report successfully',
      'report_from': 'Report from',
      'capture_location': 'Capture Location',
      'reason_for_rejection': 'Provide a reason why this report is rejected:',
      'reject_report': 'Reject Report',
      'actual_disease_diagnosis': 'Actual Disease Diagnosis (Optional)',
      'prediction_accuracy': 'Prediction Accuracy (%)',
      'save_and_confirm': 'SAVE & CONFIRM',
      'accept_report_caps': 'ACCEPT REPORT',
      'reject_report_caps': 'REJECT REPORT',
      'other_possibilities': 'Other Possibilities:',
      'see_disease_details': 'See Disease Details',
      'save_detection': 'Save Detection',
      'cancel_or_rescan': 'Cancel / Rescan',
      'login_required_report': 'You must login to create a report.',
      'login_required_save_detection': 'You must login to save detection.',
      'detection_saved': 'Detection successfully saved to history.',
      'failed_open_scanner': 'Failed to open scanner:',
      'please_login_first': 'Please login first',
      'password_not_match': 'Password confirmation doesn\'t match',
      'password_min_8_chars': 'New password must be at least 8 characters',
      'password_updated': 'Password successfully updated',
      'login_to_detect': 'Login to detect',
      'uploading_profile_photo': 'Uploading profile photo...',
      'profile_photo_updated': 'Profile photo successfully updated!',
      'deleting_profile_photo': 'Deleting profile photo...',
      'profile_photo_deleted': 'Profile photo successfully deleted!',
      'failed_update_error': 'Failed to update:',
      'take_from_camera': 'Take from Camera',
      'login_success': 'Login successful.',
      'login_failed': 'Login failed:',
      'open_settings': 'Open Settings',
      'analyzing_image_ai': 'Analyzing image with AI...',
      'system_failed_detect': 'Sorry, the system failed to detect the image.',
      'invalid_image': 'Invalid Image',
      'delete_all_logs_confirm': 'Delete All Logs?',
      'cannot_open_uri': 'Cannot open',
      'accuracy_label': 'Accuracy',
      'additional_desc': 'Add detailed disease description (symptoms, causes, treatment)',
      'additional_notes': 'Additional Notes',
      'additional_notes_hint': 'Write additional notes here...',
      'admin': 'Admin',
      'admin_response_label': 'Admin Response',
      'ai_action_recommendation': 'AI Action Recommendation',
      'app_already_status': 'Application already has status',
      'app_approved_success': 'Application approved successfully.',
      'app_rejected_success': 'Application rejected successfully.',
      'application_reason': 'Application Reason',
      'approve_caps': 'APPROVE',
      'approved': 'Approved',
      'approved_desc': 'Congratulations! You are now an expert. You do not need to apply again.',
      'area_statistics': 'Area Statistics',
      'attachment_label': 'Attachment',
      'attachment_optional': 'Screenshot Attachment (Optional)',
      'bug_error': 'Technical Bug/Error',
      'cases': 'Cases',
      'change_role': 'Change Role',
      'change_role_btn': 'Change Role',
      'close': 'Close',
      'confirm_delete_multiple': 'Are you sure you want to delete',
      'confirm_delete_name': 'Delete this user?',
      'confirm_delete_single': 'Are you sure you want to delete this report?',
      'cv_document': 'CV / Certification Document',
      'data_not_found': 'Data not found',
      'delete_failed': 'Delete failed',
      'delete_success': 'Deleted successfully',
      'delete_user_under_construction': 'Delete user feature is under construction',
      'detailed_desc': 'Detailed Description',
      'disease_explanation': 'Disease Explanation',
      'disease_list': 'Disease List',
      'disease_name': 'Disease Name',
      'disease_save_success': 'Disease saved successfully',
      'dosage_optional': 'Dosage (Optional)',
      'download_report': 'Download Report',
      'edit': 'Edit',
      'email': 'Email',
      'empty_data': 'No data available',
      'error': 'Error:',
      'expert': 'Expert',
      'expert_app_submitted': 'Application submitted successfully!',
      'expert_application': 'Expert Application',
      'expert_recommendation_notes': 'Expert Recommendations & Notes',
      'expert_review': 'Expert Review',
      'expert_review_title': 'Expert Review',
      'failed': 'Failed',
      'failed_delete': 'Failed to delete:',
      'failed_load_data': 'Failed to load data:',
      'failed_load_expert_app_status': 'Failed to load application status:',
      'failed_load_image': 'Failed to load image',
      'failed_load_queue': 'Failed to load queue:',
      'failed_load_report': 'Failed to load report:',
      'failed_load_user': 'Failed to load user data:',
      'failed_process': 'Failed to process:',
      'failed_save': 'Failed to save:',
      'feature_suggestion': 'Feature Suggestion',
      'feature_under_construction': 'This feature is under construction',
      'file_available': 'File available',
      'final_expert_diagnosis': 'Final Expert Diagnosis:',
      'from_reports': '% of reports',
      'full_name': 'Full Name',
      'general_question': 'General Question',
      'initial_ai_diagnosis': 'Initial AI Diagnosis:',
      'latin_name_optional': 'Latin Name (Optional)',
      'login_required_delete': 'You must login to delete.',
      'main_cause': 'Main Cause',
      'new_symptom': 'New Symptom',
      'new_treatment': 'New Treatment',
      'no_additional_complaints': 'No additional complaints written.',
      'no_report_yet': 'No reports yet',
      'no_response_yet': 'No response yet',
      'open': 'Open',
      'open_web_download': 'Open Web to download',
      'password': 'Password',
      'pending_tasks': 'Pending Tasks',
      'pick_doc_image': 'Pick Document / Image',
      'pick_image_gallery': 'Pick Image from Gallery',
      'priority_0_9': 'Priority (0-9)',
      'priority_queue': 'Priority Queue',
      'processing_caps': 'PROCESSING',
      'recent_reports': 'Recent Reports',
      'reject_caps': 'REJECT',
      'rejected': 'Rejected',
      'rejected_caps': 'REJECTED',
      'rejected_desc': 'Sorry, your application was rejected. You can reapply.',
      'related_disease': 'Related Disease',
      'report_content': 'Report Content / Complaint',
      'report_content_label': 'Report Content',
      'report_details': 'Report Details',
      'report_empty_error': 'Report content cannot be empty',
      'report_sent_failed': 'Failed to send report:',
      'report_sent_success': 'Report sent successfully!',
      'report_type': 'Report Type',
      'report_waiting_review': 'This report is waiting for your review. You can accept this report if it is valid, or reject it.',
      'reporter': 'Reporter',
      'reports_count': 'Reports',
      'reports_label': 'Reports',
      'review_desc': 'Your document has been received and is in the review queue by Super Admin.',
      'role_change_failed': 'Failed to change role:',
      'role_change_success': 'Role changed successfully',
      'save': 'Save',
      'select_disease_first': 'Select a disease first',
      'send_reply': 'Send Reply',
      'send_report': 'Send Report',
      'server_response_status': 'Server responded with status',
      'solution_desc': 'Solution / Treatment Description',
      'submit_application': 'Submit Application',
      'super_admin': 'Super Admin',
      'symptom_code_example': 'Symptom Code (Example: G001)',
      'symptom_name': 'Symptom Name',
      'symptom_save_success': 'Symptom saved successfully',
      'top_disease': 'Top Disease',
      'total_diseases': 'Total\nDiseases',
      'total_reports': 'Total\nReports',
      'total_reports_inline': 'Total Reports',
      'treatment_save_success': 'Treatment saved successfully',
      'treatment_type': 'Treatment Type',
      'trending_now': 'Trending Now',
      'under_review': 'Under Review',
      'unit_optional': 'Unit (Optional)',
      'unknown': 'Unknown',
      'upload_certification_doc': 'Please upload certification document',
      'upload_desc': 'Upload your certification document or proof of expertise',
      'user': 'User',
      'verified_caps': 'VERIFIED',
      'verify': 'Verify',
      'waiting_caps': 'WAITING',
      'save_report': 'Save Report',
      'diprediksi_ai_caps': 'PREDICTED BY AI',
      'pending_caps': 'PENDING',
      'welcome_expert': 'Welcome,',
      'add_disease': 'Add Disease',
      'edit_disease': 'Edit Disease',
      'add_symptom': 'Add Symptom',
      'edit_symptom': 'Edit Symptom',
      'local_device_scan': 'Local Device Scan',
      'generic_disease_description': 'The system detected a pattern of leaf damage. Please check the treatment guide in the app to prevent spreading.',
      'add_treatment': 'Add Treatment',
      'edit_treatment': 'Edit Treatment',
      'expert_mapan': 'Mapan Expert',
      'no_description': 'No description',
      'google_login_success': 'Successfully signed in with Google! Welcome.',
      'google_token_failed': 'Failed to get token from Google.',
      'password_confirm_mismatch': 'Password confirmation does not match.',
      'failed_send_otp': 'Failed to send OTP:',
      'location_not_available': 'Location not yet available',
      'failed_submit_application': 'Failed to submit application',
      'no_feedback_reports': 'No reports or feedback from users yet.',
      'confirm_new_password': 'Confirm New Password',
      'failed_generic': 'Failed:',
      'failed_delete_generic': 'Failed to delete:',
      'scan_plant': 'Scan Plant',
      'scan_your_plant': 'Scan Your Plant',
      'no_photo_added': 'No photo added yet',
      'add_photo': 'Add Photo',
      'delete_all_read': 'Delete All Read',
      'new_notification': 'New Notification',
      'failed_scan': 'Failed to scan:',
      'location_unknown': 'Unknown Location',
      'role_expert': 'Expert',
      'role_user': 'User',
      'detection_label': 'Detection',
      'detection_prefix': 'Detection',
      'failed_upload_generic': 'Failed to upload photo',
    },
  };

  static String get(String langCode, String key) {
    return _dict[langCode]?[key] ?? key;
  }
}

extension TranslateExtension on BuildContext {
  String t(String key, {bool listen = true}) {
    final lang = listen 
        ? watch<AppLanguage>().languageCode 
        : read<AppLanguage>().languageCode;
    return AppTranslations.get(lang, key);
  }
}

const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://arturo-untaunting-thrawnly.ngrok-free.dev',
);

enum LogLevel { info, warning, error }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;

  LogEntry(this.timestamp, this.level, this.message);

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'message': message,
  };

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      LogLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => LogLevel.info,
      ),
      json['message'] ?? '',
    );
  }
}

class AppLogger {
  static final List<LogEntry> _logs = [];
  static const int _maxLogs = 500;
  static const String _prefKey = 'app_system_logs';

  static List<LogEntry> get logs => List.unmodifiable(_logs);

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? logsStr = prefs.getString(_prefKey);
      if (logsStr != null) {
        final List<dynamic> decoded = jsonDecode(logsStr);
        _logs.clear();
        _logs.addAll(
          decoded.map((e) => LogEntry.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (_) {}
  }

  static Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(_logs.map((e) => e.toJson()).toList());
      prefs.setString(_prefKey, encoded);
    } catch (_) {}
  }

  static void info(String message) => _addLog(LogLevel.info, message);
  static void warning(String message) => _addLog(LogLevel.warning, message);
  static void error(String message) => _addLog(LogLevel.error, message);

  static void _addLog(LogLevel level, String message) {
    debugPrint('[${level.name.toUpperCase()}] $message');
    _logs.insert(0, LogEntry(DateTime.now(), level, message));
    if (_logs.length > _maxLogs) {
      _logs.removeLast();
    }
    _save();
  }

  static Future<void> clear() async {
    _logs.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }
}

class MapanApp extends StatelessWidget {
  final Widget initialPage;
  const MapanApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Mapan',
        debugShowCheckedModeBanner: false,
        themeMode: context.watch<AppTheme>().themeMode,
        theme: MapanApp.buildTheme(Brightness.light, c),
        darkTheme: MapanApp.buildTheme(Brightness.dark, c),
        home: initialPage,
      ),
    );
  }

  static ThemeData buildTheme(Brightness brightness, AppThemeData c) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF007A4D),
      brightness: brightness,
      primary: c.green,
      surface: c.surface,
    );
    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.background,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.dark,
        elevation: 0,
        iconTheme: IconThemeData(color: c.green),
        actionsIconTheme: IconThemeData(color: c.green),
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(color: c.surface, elevation: isDark ? 0 : 1),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: c.dark),
        bodyMedium: TextStyle(color: c.dark),
        bodySmall: TextStyle(color: c.muted),
        titleLarge: TextStyle(color: c.dark, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: c.dark, fontWeight: FontWeight.w700),
        titleSmall: TextStyle(color: c.dark, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(color: c.dark),
        labelMedium: TextStyle(color: c.muted),
        labelSmall: TextStyle(color: c.muted),
      ),
      iconTheme: IconThemeData(color: c.dark),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.field,
        hintStyle: TextStyle(color: c.muted),
        labelStyle: TextStyle(color: c.dark),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.green, width: 2),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(color: c.dark),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.green.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.green);
          }
          return IconThemeData(color: c.muted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: c.green,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return TextStyle(color: c.muted, fontSize: 12);
        }),
      ),
      dividerTheme: DividerThemeData(color: c.border),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: c.surface),
      dialogTheme: DialogThemeData(backgroundColor: c.surface),
      popupMenuTheme: PopupMenuThemeData(color: c.surface),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Jalankan inisialisasi berat di background tanpa await agar UI splash screen tidak nge-freeze
    NotificationService.initialize().catchError((e) {
      print("Firebase init failed: $e");
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Tunggu durasi animasi selesai (1.2 detik) agar transisi dari Native Splash lebih smooth
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              token != null ? const ClimateShell() : const OnboardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFEFF5EF),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFBCCAC0).withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/app_logo.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Mapan',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: context.colors.green,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rice disease detection & expert system',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: context.colors.green,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Solusi Cerdas Pertanian Padi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.colors.muted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClimateShell extends StatefulWidget {
  const ClimateShell({super.key});

  @override
  State<ClimateShell> createState() => _ClimateShellState();
}

class _ClimateShellState extends State<ClimateShell> {
  final ApiClient _api = ApiClient(baseUrl: apiBaseUrl);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  final List<Widget?> _initializedPages = List.filled(13, null);
  String? _token;
  UserProfile _user = const UserProfile(
    name: 'Admin Climate',
    email: 'admin@mapan.test',
    role: 'super_admin',
  );

  List<String> _scannedImages = [];
  String? _detectedDisease;
  double? _detectedConfidence;
  int _refreshKey = 0;

  void _selectTab(int index) {
    if (index == 2) {
      _openCameraScanner();
      return;
    }
    setState(() => _tabIndex = index);
    _scaffoldKey.currentState?.closeDrawer();
  }

  Future<void> _setToken(String? token, [UserProfile? user]) async {
    setState(() {
      _token = token;
      if (token == null) {
        _user = const UserProfile(
          name: 'Guest User',
          email: 'guest@mapan.id',
          role: 'guest',
        );
      } else if (user != null) {
        _user = user;
      }

      // Clear cache so pages rebuild with new user state
      _initializedPages.fillRange(0, _initializedPages.length, null);
    });

    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove('auth_token');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('user_role');
      await prefs.remove('pending_role');
      await prefs.remove('user_photo');
      await prefs.remove('agency_name');

      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        print("Google SignOut Error: $e");
      }
    } else if (user != null) {
      await prefs.setString('auth_token', token);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_role', user.role);
      if (user.pendingRole != null) {
        await prefs.setString('pending_role', user.pendingRole!);
      } else {
        await prefs.remove('pending_role');
      }
      if (user.avatarUrl != null) {
        await prefs.setString('user_photo', user.avatarUrl!);
      }
      if (user.agencyName != null) {
        await prefs.setString('agency_name', user.agencyName!);
      } else {
        await prefs.remove('agency_name');
      }
    }

    if (token != null) {
      // Get FCM token and send it to server if notifications are enabled
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool('notifications_enabled') ?? true;
      if (isEnabled) {
        NotificationService.requestPermission().then((_) {
          NotificationService.getToken().then((fcmToken) {
            if (fcmToken != null) {
              _api.updateFcmToken(token, fcmToken).catchError((e) {
                print("Failed to update FCM token: $e");
              });
            }
          });
        });
      } else {
        _api.updateFcmToken(token, "").catchError((_) {});
      }
    } else {
      // If logging out, redirect to OnboardingPage
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
          (route) => false,
        );
      }
    }
  }

  bool _isScanning = false;
  final MlService _mlService = MlService();

  @override
  void initState() {
    super.initState();
    _loadSession();

    // Listen for connectivity changes to trigger background sync
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (!results.contains(ConnectivityResult.none)) {
        OfflineQueueService.syncDrafts(_api);
      }
    });
    // _mlService.init(); // Commented out to save RAM and prevent crash on startup
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      final user = UserProfile(
        name: prefs.getString('user_name') ?? 'User',
        email: prefs.getString('user_email') ?? '',
        role: prefs.getString('user_role') ?? 'user',
        pendingRole: prefs.getString('pending_role'),
        avatarUrl: prefs.getString('user_photo'),
        agencyName: prefs.getString('agency_name'),
      );
      setState(() {
        _token = token;
        _user = user;
        _initializedPages.fillRange(0, _initializedPages.length, null);
      });
    }
  }

  @override
  void dispose() {
    _mlService.dispose();
    super.dispose();
  }

  Future<void> _openCameraScanner() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    try {
      List<DiseaseOption> loadedDiseases = [];
      try {
        loadedDiseases = await _api.fetchDiseases();
      } catch (_) {
        loadedDiseases = DiseaseOption.samples();
      }

      // Push halaman ScanPage sebagai layar penuh
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          settings: const RouteSettings(name: 'ScanPage'),
          builder: (ctx) =>
              ScanPage(mlService: _mlService, diseases: loadedDiseases),
        ),
      );
      if (result != null && mounted) {
        final action = result['action'] as String?;
        final images = List<String>.from(result['images'] as List? ?? []);
        final diseaseName = result['disease'] as String?;

        final confidence = result['confidence'] as double?;

        if (action == 'report') {
          if (_token == null || _token!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Anda harus login untuk membuat laporan.'),
              ),
            );
            return;
          }
          // User ingin buat laporan → bawa foto + penyakit ke tab form
          setState(() {
            _scannedImages = images;
            _detectedDisease = diseaseName;
            _detectedConfidence = confidence;
            _tabIndex = 3; // "Tambah" tab index is 3
          });
        }

        if (action == 'save') {
          if (_token == null || _token!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Anda harus login untuk menyimpan deteksi.'),
              ),
            );
            return;
          }
          setState(() => _isScanning = true);
          int diseaseId = 0;
          double? lat;
          double? lon;
          try {
            try {
              diseaseId = loadedDiseases
                  .firstWhere((d) => d.name == diseaseName)
                  .id;
            } catch (_) {}

            try {
              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (serviceEnabled) {
                LocationPermission permission =
                    await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                }
                if (permission == LocationPermission.whileInUse ||
                    permission == LocationPermission.always) {
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium,
                    timeLimit: const Duration(seconds: 5),
                  );
                  if (position.isMocked) {
                    _api.logFakeGpsAttempt(_token ?? '', position.latitude, position.longitude);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fake GPS terdeteksi! Laporan diblokir.', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    throw Exception('Fake GPS terdeteksi.');
                  }
                  lat = position.latitude;
                  lon = position.longitude;
                }
              }
            } catch (_) {}

            await _api.createDetection(
              token: _token ?? '',
              diseaseId: diseaseId,
              notes: 'Penyimpanan Deteksi (Non-Laporan)',
              method: 'image', // FIX: Should be image for ML scans
              confidence: confidence,
              images: images,
              latitude: lat,
              longitude: lon,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.t('detection_saved', listen: false)),
              ),
            );
            setState(() {
              _refreshKey++;
            });
            _selectTab(1); // pindah ke tab Riwayat
          } catch (e) {
            await OfflineQueueService.saveDraft(
              token: _token ?? '',
              diseaseId: diseaseId,
              notes: 'Penyimpanan Deteksi (Non-Laporan)',
              method: 'image',
              confidence: confidence,
              tempImages: images,
              latitude: lat,
              longitude: lon,
            );
          } finally {
            if (mounted) setState(() => _isScanning = false);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed_open_scanner', listen: false)} $e')));
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  String _getBackgroundImage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 10) return 'assets/bg_morning.png';
    if (hour >= 10 && hour < 15) return 'assets/bg_day.png';
    if (hour >= 15 && hour < 18) return 'assets/bg_afternoon.png';
    return 'assets/bg_night.png';
  }

  @override
  Widget build(BuildContext context) {
    final isPakar = _user.role == 'pakar' || _user.role == 'super_admin';
    final pages = <Widget>[
      isPakar
          ? PakarDashboardPage(
              api: _api,
              token: _token,
              user: _user,
              onGoToHistory: () => _selectTab(1),
            )
          : DashboardPage(
              api: _api,
              token: _token,
              user: _user,
              openDetection: () => _selectTab(1),
              openExpertApplications: () => _selectTab(12),
              onTabChanged: _selectTab,
            ),
      DetectionsPage(
        api: _api,
        token: _token,
        openScanner: isPakar ? null : _openCameraScanner,
        isHistory: true,
        role: _user.role,
        onChanged: () => setState(() => _refreshKey++),
      ),
      const SizedBox.shrink(), // Dummy page for middle 'Deteksi' button
      AddDetectionPage(
        api: _api,
        token: _token,
        initialImages: _scannedImages,
        initialDisease: _detectedDisease,
        initialConfidence: _detectedConfidence,
        onConsumed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted)
              setState(() {
                _scannedImages = [];
                _detectedDisease = null;
                _detectedConfidence = null;
              });
          });
        },
        onSubmitted: () {
          if (mounted) {
            setState(() {
              _tabIndex = 0; // Kembali ke beranda
              _refreshKey++; // Refresh App Bar and fetch new notifications!
            });
          }
        },
      ),
      ProfilePage(
        user: _user,
        token: _token,
        api: _api,
        onAuthChanged: (token, [user]) {
          _setToken(token, user);
          if (token == null) _selectTab(0);
        },
      ),
      const LogViewerPage(),
      TeamPage(api: _api),
      ExpertHubPage(api: _api, token: _token),
      AdminDashboardPage(api: _api, token: _token),
      SuperAdminDashboardPage(api: _api, token: _token),
      DetectionsPage(
        api: _api,
        token: _token,
        openScanner: _openCameraScanner,
        isHistory: true,
        role: _user.role,
        onChanged: () => setState(() => _refreshKey++),
      ),
      PakarWorkspacePage(api: _api, token: _token, user: _user),
      ExpertApplicationListPage(api: _api, token: _token),
    ];

    int safeIndex = _tabIndex >= pages.length ? 0 : _tabIndex;

    return Scaffold(
      key: _scaffoldKey,
      appBar: ClimateHeader(
        key: ValueKey('header_$_refreshKey'),
        title: 'Mapan',
        compact: true,
        userPhoto: _user.avatarUrl,
        api: _api,
        token: _token,
        onEditProfile: () => _selectTab(4),
        onTapNotification: _token == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        NotificationsPage(api: _api, token: _token!),
                  ),
                );
              },
      ),
      floatingActionButton: safeIndex == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_user.role == 'super_admin' || _user.role == 'admin')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FloatingActionButton.extended(
                      heroTag: 'map_fab',
                      onPressed: () {
                        if (_token != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DiseaseMapPage(api: _api, token: _token!),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text(
                        'Peta Sebaran',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF006948),
                    ),
                  ),
                if (_user.role != 'admin' && _user.role != 'super_admin')
                  FloatingActionButton.extended(
                    heroTag: 'chat_fab',
                    onPressed: () {
                      if (_token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan login terlebih dahulu')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatbotPage(api: _api, token: _token!, user: _user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.smart_toy, color: Colors.white),
                    label: const Text(
                      'Tanya Mapan',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green.shade600,
                  ),
              ],
            )
          : null,
      drawer: ClimateDrawer(
        selectedIndex: safeIndex,
        user: _user,
        token: _token,
        api: _api,
        onSelect: _selectTab,
        onAuthChanged: _setToken,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              if (_initializedPages[safeIndex] == null) {
                _initializedPages[safeIndex] = pages[safeIndex];
              }
              return SlideIndexedStack(
                index: safeIndex,
                children: List.generate(
                  pages.length,
                  (i) => _initializedPages[i] ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: ClimateBottomNav(
        currentIndex: safeIndex,
        onChanged: (index) {
          if (_user.role == 'pakar') {
            if (index == 0) _selectTab(0);
            if (index == 1) _selectTab(1);
            if (index == 2) _selectTab(11); // PakarWorkspacePage
            if (index == 3) _selectTab(4); // ProfilePage
          } else if (_user.role == 'super_admin') {
            if (index == 0) _selectTab(0); // DashboardPage
            if (index == 1) _selectTab(1); // DetectionsPage
            if (index == 2) _selectTab(7); // ExpertHubPage
            if (index == 3) _selectTab(4); // ProfilePage
          } else if (_user.role == 'admin') {
            if (index == 0) _selectTab(0); // DashboardPage
            if (index == 1) _selectTab(1); // Semua Laporan (DetectionsPage)
            if (index == 2) _selectTab(4); // ProfilePage
          } else {
            _selectTab(index);
          }
        },
        role: _user.role,
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.api,
    required this.token,
    required this.user,
    required this.openDetection,
    this.openExpertApplications,
    required this.onTabChanged,
  });

  final ApiClient api;
  final String? token;
  final UserProfile? user;
  final VoidCallback openDetection;
  final VoidCallback? openExpertApplications;
  final Function(int) onTabChanged;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardStats _stats = DashboardStats.fallback();
  List<DetectionItem> _recent = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await OfflineQueueService.syncDrafts(widget.api);
    try {
      List<DetectionItem> recentList;
      if (widget.user != null && widget.user!.role == 'user') {
        recentList = await widget.api.fetchMyDetections(widget.token!);
      } else {
        recentList = await widget.api.fetchPublicDetections();
      }

      DashboardStats stats = DashboardStats.fallback();
      if (widget.token != null) {
        stats = await widget.api.fetchDashboardStats(widget.token!);
      } else if (recentList.isNotEmpty) {
        stats = stats.copyWith(totalDetections: recentList.length);
      }
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _recent = recentList.take(3).toList();
      });
    } catch (e) {
      print('ERROR loading dashboard stats: ');
      if (!mounted) return;
      setState(() {
        _stats = DashboardStats.fallback();
        _recent = [];
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            sliver: SliverList.list(
              children: [
                const WeatherHealthBanner(),
                if (widget.user?.pendingRole == 'pakar') ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pengajuan akun Pakar Ahli Anda sedang ditinjau oleh Admin. Sementara ini, Anda dapat menggunakan aplikasi sebagai Pengguna Umum.',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_stats.insight.hasInsight) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50.withOpacity(0.5),
                      border: Border.all(color: Colors.green.shade200),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade100.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.t('land_insight'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          (_stats.totalDiseases > 1 &&
                                  _stats.insight.count == 1)
                              ? "Perhatian: Ada ${_stats.totalDiseases} jenis penyakit berbeda yang baru terdeteksi di lahan Anda. Segera lakukan pengecekan menyeluruh."
                              : "Dalam 30 hari terakhir, lahan Anda terdeteksi terkena ${_stats.insight.diseaseName} sebanyak ${_stats.insight.count} kali.",
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Saran Penanganan: ${_stats.insight.recommendation}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.green.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final isAdmin = widget.user?.role != null && widget.user!.role != 'user';
                        return SizedBox(
                          width: double.infinity,
                          height: 140,
                          child: StatCard(
                            icon: isAdmin ? Icons.list_alt : Icons.science_outlined,
                            watermarkIcon: isAdmin ? Icons.article_outlined : Icons.eco,
                            label: isAdmin ? 'Total Laporan' : context.t('total_detection'),
                            numericValue: _stats.totalDetections,
                            color: context.colors.green,
                            trendText: _stats.weeklyGrowth > 0
                                ? '+${_stats.weeklyGrowth} ${context.t('this_month')}'
                                : null,
                            onTap: isAdmin ? () => widget.onTabChanged(1) : widget.openDetection,
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        final isAdmin = widget.user?.role != null && widget.user!.role != 'user';
                        return Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 160,
                                child: StatCard(
                                  icon: isAdmin ? Icons.history : Icons.coronavirus_outlined,
                                  watermarkIcon: isAdmin ? Icons.timeline : Icons.pest_control,
                                  label: isAdmin ? 'Laporan Minggu Ini' : context.t('disease_detected'),
                                  numericValue: isAdmin ? _stats.weeklyGrowth : _stats.totalDiseases,
                                  color: isAdmin ? Colors.teal : Colors.redAccent,
                                  onTap: isAdmin ? () => widget.onTabChanged(1) : widget.openDetection,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 160,
                                child: StatCard(
                                  icon: isAdmin ? Icons.verified_user_outlined : Icons.assignment_outlined,
                                  watermarkIcon: isAdmin ? Icons.badge_outlined : Icons.article_outlined,
                                  label: isAdmin ? 'Pengajuan Pakar Total' : context.t('this_week'),
                                  numericValue: isAdmin ? _stats.totalExpertApplications : _stats.weeklyGrowth,
                                  color: isAdmin ? Colors.blueGrey : Colors.teal,
                                  onTap: isAdmin ? (widget.openExpertApplications ?? widget.openDetection) : widget.openDetection,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        final isAdmin = widget.user?.role != null && widget.user!.role != 'user';
                        return SectionTitle(
                          isAdmin ? 'Daftar Laporan' : context.t('recent_activity'),
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Colors.black87,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        );
                      }
                    ),
                    Builder(
                      builder: (context) {
                        final isAdmin = widget.user?.role != null && widget.user!.role != 'user';
                        return TextButton(
                          onPressed: isAdmin ? () => widget.onTabChanged(1) : widget.openDetection,
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.green,
                          ),
                          child: Text(
                            context.t('see_all'),
                            style: const TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_loading)
                  ...List.generate(3, (index) => const ShimmerActivityCard())
                else if (_recent.isEmpty)
                  EmptyActivityWidget(onStartDetection: widget.openDetection)
                else
                  ..._recent.map((item) => RecentActivityCard(item: item)),
                if (widget.user != null && widget.user!.role != 'user') ...[
                  const SizedBox(height: 24),
                  SectionTitle(
                    context.t('data_management'),
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ManagementTile(
                          icon: Icons.coronavirus_outlined,
                          label: context.t('disease'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ManagementTile(
                          icon: Icons.list_alt_outlined,
                          label: context.t('symptom'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ManagementTile(
                          icon: Icons.medical_services_outlined,
                          label: context.t('solution'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScanBanner extends StatelessWidget {
  const ScanBanner({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.green, context.colors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pindai Tanamanmu',
                        style: TextStyle(
                          color: context.colors.surface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Temukan penyakit dan dapatkan solusi instan menggunakan AI.',
                        style: TextStyle(
                          color: context.colors.surface.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surface.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.document_scanner_outlined,
                    color: context.colors.surface,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetectionsPage extends StatefulWidget {
  const DetectionsPage({
    super.key,
    required this.api,
    required this.token,
    this.openScanner,
    this.isHistory = false,
    this.role = 'user',
    this.onChanged,
  });

  final ApiClient api;
  final String? token;
  final VoidCallback? openScanner;
  final bool isHistory;
  final String role;
  final VoidCallback? onChanged;

  @override
  State<DetectionsPage> createState() => _DetectionsPageState();
}

class _DetectionsPageState extends State<DetectionsPage> {
  final TextEditingController _search = TextEditingController();
  List<DetectionItem> _items = [];
  bool _loading = false;
  bool _isOffline = false;

  DateTime? _selectedDate;
  final Set<int> _selectedIds = {};

  int _currentPage = 1;
  static const int _itemsPerPage = 5;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await OfflineQueueService.syncDrafts(widget.api);
    try {
      List<DetectionItem> detections = [];
      if (widget.isHistory) {
        if (widget.token != null) {
          if (widget.role == 'admin' || widget.role == 'super_admin' || widget.role == 'pakar') {
            detections = await widget.api.fetchAllDetections(widget.token!);
          } else {
            detections = await widget.api.fetchMyDetections(widget.token!);
          }
        } else {
          // If not logged in, history is empty
          detections = [];
        }
      } else {
        detections = await widget.api.fetchPublicDetections();
      }
      if (!mounted) return;
      setState(() {
        _items = detections;
        _selectedIds.clear();
        _isOffline = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _selectedIds.clear();
        _isOffline = true;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _toggleSelect(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _deleteItems(List<int> ids) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('confirm_delete')),
        content: Text(
          ids.length == 1
              ? context.t('confirm_delete_single')
              : '${context.t('confirm_delete_multiple')} ${ids.length} ${context.t('reports')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.t('cancel'), style: TextStyle(color: context.colors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.t('delete'), style: TextStyle(color: context.colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (widget.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('login_required_delete', listen: false))),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      for (final id in ids) {
        await widget.api.deleteDetection(token: widget.token!, id: id);
      }
      if (!mounted) return;
      AppLogger.info('Menghapus ${ids.length} laporan dengan sukses.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('delete_success', listen: false))));
      await _load();
      widget.onChanged?.call();
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${context.t('delete_failed')}: $error')));
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final d = date.day.toString().padLeft(2, '0');
    final m = months[date.month - 1];
    final y = date.year;
    return '$d $m $y';
  }

  Widget _buildFilterChip(String label, String tKey) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(context.t(tKey)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = label;
            _currentPage = 1;
          });
        }
      },
      selectedColor: context.colors.green.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? context.colors.green : context.colors.muted,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isSelected ? context.colors.green : context.colors.border,
        ),
      ),
      backgroundColor: context.colors.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline && !_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'Koneksi Terputus',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tidak dapat memuat data. Silakan periksa koneksi internet Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    final query = _search.text.toLowerCase();
    final dateStr = _selectedDate != null ? _formatDate(_selectedDate!) : null;

    final filtered = _items.where((item) {
      final matchesSearch =
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);
      final matchesDate = dateStr == null || item.createdAt.startsWith(dateStr);

      bool matchesFilter = true;
      if (_selectedFilter == 'Laporan') {
        matchesFilter = item.status != 'diprediksi_ai';
      } else if (_selectedFilter == 'Deteksi') {
        matchesFilter = item.status == 'diprediksi_ai';
      }

      return matchesSearch && matchesDate && matchesFilter;
    }).toList();

    final totalItems = filtered.length;
    final totalPages = (totalItems / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage > totalItems)
        ? totalItems
        : startIndex + _itemsPerPage;
    final paginated = startIndex < totalItems
        ? filtered.sublist(startIndex, endIndex)
        : <DetectionItem>[];

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: _loading,
          child: Column(
            children: [
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
                    children: [
                      if (widget.openScanner != null && !widget.isHistory)
                        ScanBanner(onTap: widget.openScanner!),
                      Text(
                        widget.isHistory
                            ? (widget.role != 'user' ? 'Laporan Terbaru' : context.t('history_title'))
                            : context.t('reports_filter'),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  color: Colors.black87,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isHistory
                            ? (widget.role != 'user' ? 'Daftar laporan penyakit...' : context.t('history_desc'))
                            : 'Kelola dan pantau status diagnosa dampak iklim di lapangan.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.35,
                          shadows: [
                            Shadow(
                              color: Colors.black87,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _search,
                              onChanged: (_) =>
                                  setState(() => _currentPage = 1),
                              decoration: InputDecoration(
                                hintText: context.t('search'),
                                prefixIcon: const Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 54,
                            width: 54,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: BorderSide(
                                  color: _selectedDate != null
                                      ? context.colors.mint
                                      : context.colors.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: _selectedDate != null
                                    ? context.colors.greenSoft
                                    : null,
                              ),
                              onPressed: () async {
                                if (_selectedDate != null) {
                                  setState(() {
                                    _selectedDate = null;
                                    _currentPage = 1;
                                  });
                                  return;
                                }
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedDate = date;
                                    _currentPage = 1;
                                  });
                                }
                              },
                              child: Icon(
                                _selectedDate != null
                                    ? Icons.event_busy
                                    : Icons.calendar_today,
                                color: _selectedDate != null
                                    ? context.colors.green
                                    : context.colors.dark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 54,
                            width: 54,
                            child: OutlinedButton(
                              onPressed: _load,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: BorderSide(color: context.colors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      Icons.refresh,
                                      color: context.colors.dark,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Filter Buttons
                      if (widget.role != 'super_admin' &&
                          widget.role != 'admin' &&
                          widget.role != 'pakar')
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('Semua', 'all'),
                              const SizedBox(width: 8),
                              _buildFilterChip(context.t('detection'), 'detection'),
                              const SizedBox(width: 8),
                              _buildFilterChip(context.t('reports_filter'), 'reports_filter'),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (filtered.isEmpty && !_loading)
                        Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: context.colors.muted,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada laporan',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black87,
                                          blurRadius: 4,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tidak menemukan laporan yang sesuai dengan pencarian atau filter Anda.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        ...paginated.map(
                          (item) => DetectionCard(
                            item: item,
                            isSelectionMode: _selectedIds.isNotEmpty,
                            isSelected: _selectedIds.contains(item.id),
                            onToggleSelect: () => _toggleSelect(item.id),
                            onDelete: () => _deleteItems([item.id]),
                            api: widget.api,
                            token: widget.token,
                          ),
                        ),
                        if (totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _currentPage > 1
                                      ? () => setState(() => _currentPage--)
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${context.t('page')} $_currentPage ${context.t('of')} $totalPages',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.dark,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  onPressed: _currentPage < totalPages
                                      ? () => setState(() => _currentPage++)
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                if (_selectedIds.isNotEmpty)
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: FilledButton.icon(
                      onPressed: () => _deleteItems(_selectedIds.toList()),
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.delete_forever),
                      label: Text(
                        'Hapus ${_selectedIds.length} Data Terpilih',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    if (_loading)
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
  ],
);
  }
}

class AddDetectionPage extends StatefulWidget {
  const AddDetectionPage({
    super.key,
    required this.api,
    this.token,
    this.initialImages = const [],
    this.initialDisease,
    this.initialConfidence,
    this.onConsumed,
    this.onSubmitted,
  });

  final ApiClient api;
  final String? token;
  final List<String> initialImages;
  final String? initialDisease;
  final double? initialConfidence;
  final VoidCallback? onConsumed;
  final VoidCallback? onSubmitted;

  @override
  State<AddDetectionPage> createState() => _AddDetectionPageState();
}

class _AddDetectionPageState extends State<AddDetectionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final List<String> _images = [];
  List<DiseaseOption> _diseases = const [];
  DiseaseOption? _selectedDisease;
  bool _loading = false;
  bool _submitting = false;
  bool _isReport = true;
  final MlService _mlService = MlService();

  @override
  void initState() {
    super.initState();
    
    // Capture initial values before they might be cleared by onConsumed
    final initImages = List<String>.from(widget.initialImages);
    final initDisease = widget.initialDisease;
    
    _fetchLocationAndWeather();
    _loadDiseases().then((_) {
      if (initImages.isNotEmpty && mounted) {
        widget.onConsumed?.call();
        
        setState(() {
          if (_images.isEmpty) {
            _images.addAll(initImages);
          }
          if (initDisease != null) {
            try {
              _selectedDisease = _diseases.firstWhere(
                (d) => d.name.toLowerCase() == initDisease.toLowerCase(),
              );
            } catch (_) {}
          }
          _updateAutoTitle();
        });
      }
    });
  }

  Future<void> _fetchLocationAndWeather() async {
    const String apiKey = 'ea0dd041a3d990b79c4c86e8d12f221c';
    double lat = -6.2088;
    double lon = 106.8456;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 5),
          );
          if (position.isMocked) {
            widget.api.logFakeGpsAttempt('', position.latitude, position.longitude);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sistem mendeteksi penggunaan Fake GPS. Cuaca dinonaktifkan.', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.orange,
                ),
              );
            }
            return; // hentikan fetch cuaca
          }
          lat = position.latitude;
          lon = position.longitude;
        }
      }
    } catch (_) {}

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=id',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tempStr = (data['main']['temp'] as num).round().toString();
        final locName = data['name']?.toString() ?? context.t('location_unknown', listen: false);
        if (mounted)
          setState(() {
            _location.text = '$locName, Suhu: $tempStr°C';
          });
      }
    } catch (_) {}
  }

  Future<void> _pickAndCropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      maxWidth: 800,
      maxHeight: 800,
      compressQuality: 70,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Fokuskan pada Penyakit',
          toolbarColor: context.readColors.green,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Fokuskan pada Penyakit',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null && mounted) {
      setState(() {
        if (_images.length < 5) _images.add(croppedFile.path);
      });
    }
  }

  @override
  void didUpdateWidget(AddDetectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImages.isNotEmpty &&
        widget.initialImages != oldWidget.initialImages) {
      widget.onConsumed?.call();
      if (mounted) {
        setState(() {
          _images.clear();
          _images.addAll(widget.initialImages);
          if (widget.initialDisease != null) {
            _selectedDisease = null; // Pastikan reset dulu
            try {
              _selectedDisease = _diseases.firstWhere(
                (d) =>
                    d.name.toLowerCase() ==
                    widget.initialDisease!.toLowerCase(),
              );
            } catch (_) {}
          }
          _title.clear(); // Hapus title lama agar auto-generate jalan
          _updateAutoTitle();
        });
      }
    }
  }

  void _updateAutoTitle() {
    if (_title.text.isEmpty && _selectedDisease != null) {
      _title.text = '${context.t('detection_prefix', listen: false)} ${_selectedDisease!.name}';
    }
  }

  void _showDiseasePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Pilih Tipe Penyakit / Hama',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _diseases.length,
                  itemBuilder: (context, index) {
                    final disease = _diseases[index];
                    final isSelected = disease == _selectedDisease;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.shade100
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.coronavirus_outlined,
                          color: isSelected
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                        ),
                      ),
                      title: Text(
                        disease.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.green.shade800
                              : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedDisease = disease;
                          _title.clear();
                          _updateAutoTitle();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _loadDiseases() async {
    setState(() => _loading = true);
    try {
      final diseases = await widget.api.fetchDiseases();
      if (!mounted) return;
      setState(() {
        _diseases = diseases;
        _selectedDisease = diseases.isEmpty ? null : diseases.first;
        _updateAutoTitle();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _diseases = DiseaseOption.samples();
        _selectedDisease = _diseases.first;
        _updateAutoTitle();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (widget.token == null) {
      _showSnack('Login dari drawer lebih dulu untuk mengakses private API.');
      return;
    }
    if (_selectedDisease == null) {
      _showSnack('Data penyakit belum tersedia.');
      return;
    }

    setState(() => _submitting = true);
    double? lat;
    double? lon;
    try {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium,
              timeLimit: const Duration(seconds: 5),
            );
            if (position.isMocked) {
              widget.api.logFakeGpsAttempt(widget.token ?? '', position.latitude, position.longitude);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fake GPS terdeteksi! Laporan Manual diblokir.', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
                setState(() => _submitting = false);
              }
              return; // hentikan submit
            }
            lat = position.latitude;
            lon = position.longitude;
          }
        }
      } catch (_) {}

      await widget.api.createDetection(
        token: widget.token!,
        diseaseId: _selectedDisease!.id,
        method:
            'image', // Always 'image' because 'expert_system' will be rejected by backend
        confidence: widget.initialConfidence,
        notes: [
          if (_title.text.trim().isNotEmpty) 'Judul: ${_title.text.trim()}',
          if (_location.text.trim().isNotEmpty)
            'Lokasi: ${_location.text.trim()}',
          if (_notes.text.trim().isNotEmpty) _notes.text.trim(),
        ].join('\n'),
        images: _images,
        isReport: _isReport,
        latitude: lat,
        longitude: lon,
      );
      if (!mounted) return;
      AppLogger.info(
        'Berhasil membuat laporan baru untuk tipe penyakit: ${_selectedDisease!.name}',
      );
      _formKey.currentState!.reset();
      _title.clear();
      _location.clear();
      _notes.clear();
      _images.clear();
      _showSnack('✅ Laporan berhasil dikirim ke Pakar!');
      widget.onSubmitted?.call();
    } catch (error) {
      if (!mounted) return;
      await OfflineQueueService.saveDraft(
        token: widget.token!,
        diseaseId: _selectedDisease!.id,
        notes: [
          if (_title.text.trim().isNotEmpty) 'Judul: ${_title.text.trim()}',
          if (_location.text.trim().isNotEmpty)
            'Lokasi: ${_location.text.trim()}',
          if (_notes.text.trim().isNotEmpty) _notes.text.trim(),
        ].join('\n'),
        method:
            'image', // Always 'image' because 'expert_system' will be rejected by backend
        confidence: widget.initialConfidence,
        tempImages: _images,
        isReport: _isReport,
        latitude: lat,
        longitude: lon,
      );
      _formKey.currentState!.reset();
      _title.clear();
      _location.clear();
      _notes.clear();
      _images.clear();
      widget.onSubmitted?.call();
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _submitting || _loading,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 104),
              children: [
                Text(
                  context.t('create_report'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormPanel(
                        delay: 200,
                        title: context.t('photo_attachment'),
                        icon: Icons.image_outlined,
                        children: [
                          if (_images.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: _images.length < 5
                                  ? _images.length + 1
                                  : 5,
                              itemBuilder: (context, index) {
                                if (index == _images.length) {
                                  return _buildAddPhotoButton();
                                }
                                final path = _images[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: kIsWeb
                                          ? Image.network(path, headers: const {'ngrok-skip-browser-warning': 'true'},
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color:
                                                          context.colors.field,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'Gagal memuat',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Image.file(
                                              File(path),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color:
                                                          context.colors.field,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'Gagal memuat',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => setState(
                                          () => _images.removeAt(index),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: context.colors.surface,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          else
                            _buildAddPhotoButton(isFullWidth: true),
                        ],
                      ),
                      const SizedBox(height: 22),
                      FormPanel(
                        delay: 400,
                        title: context.t('report_info'),
                        icon: Icons.description_outlined,
                        children: [
                          ClimateTextField(
                            controller: _title,
                            label: context.t('report_title_label'),
                            hint: context.t('report_title_hint'),
                          ),
                          ClimateTextField(
                            controller: _location,
                            label: context.t('field_location'),
                            hint: context.t('location_hint'),
                            icon: Icons.location_on_outlined,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: _fetchLocationAndWeather,
                            ),
                          ),
                          FieldLabel(
                            label: context.t('disease_type'),
                            child: GestureDetector(
                              onTap: _loading ? null : _showDiseasePicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.coronavirus_outlined,
                                      color: Colors.green.shade700,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _loading
                                            ? 'Memuat data penyakit...'
                                            : (_selectedDisease?.name ??
                                                  'Pilih kategori penyakit'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _selectedDisease == null
                                              ? Colors.grey.shade600
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      FormPanel(
                        delay: 600,
                        title: context.t('report_details'),
                        icon: Icons.notes_outlined,
                        children: [
                          FieldLabel(
                            label: context.t('notes'),
                            child: TextFormField(
                              controller: _notes,
                              minLines: 4,
                              maxLines: 6,
                              decoration: InputDecoration(
                                hintText: context.t('notes_hint'),
                                prefixIcon: const Icon(Icons.notes_outlined),
                              ),
                              validator: (val) {
                                if (_isReport && (val == null || val.trim().isEmpty)) {
                                  return context.t('notes_required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // Removed SwitchListTile, report will always be sent automatically
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _submitting
                                  ? null
                                  : () {
                                      _formKey.currentState?.reset();
                                      _title.clear();
                                      _location.clear();
                                      _notes.clear();
                                      _images.clear();
                                    },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                foregroundColor: context.colors.green,
                                side: BorderSide(color: context.colors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(context.t('cancel')),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: BouncingButton(
                              onPressed: _submitting ? () {} : _submit,
                              child: Container(
                                height: 54,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.green.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _submitting
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: context.colors.surface,
                                        ),
                                      )
                                    : Text(
                                        context.t('save_report'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton({bool isFullWidth = false}) {
    void handleTap() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final photo = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                    maxWidth: 1200,
                    maxHeight: 1200,
                  );
                  if (photo != null) {
                    await _pickAndCropImage(photo.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final photo = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                    maxWidth: 1200,
                    maxHeight: 1200,
                  );
                  if (photo != null) {
                    await _pickAndCropImage(photo.path);
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }

    if (isFullWidth) {
      return PulsingCameraBox(onTap: handleTap);
    }

    return InkWell(
      onTap: handleTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.colors.field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 32,
              color: context.colors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class LogViewerPage extends StatelessWidget {
  const LogViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = AppLogger.logs;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sistem Log',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.colors.green,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_sweep, color: context.colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(context.t('delete_all_logs_confirm')),
                      content: const Text(
                        'Tindakan ini tidak dapat dibatalkan.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            'Batal',
                            style: TextStyle(color: context.colors.muted),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            'Hapus',
                            style: TextStyle(color: context.colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await AppLogger.clear();
                    if (context.mounted) {
                      (context as Element).markNeedsBuild();
                    }
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: logs.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada log tercatat',
                    style: TextStyle(color: context.colors.muted),
                  ),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    Color bgColor = context.colors.field;
                    Color iconColor = context.colors.green;
                    IconData icon = Icons.info_outline;

                    if (log.level == LogLevel.warning) {
                      bgColor = Colors.orange.shade50;
                      iconColor = Colors.orange;
                      icon = Icons.warning_amber_rounded;
                    } else if (log.level == LogLevel.error) {
                      bgColor = Colors.red.shade50;
                      iconColor = Colors.red;
                      icon = Icons.error_outline;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: iconColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.message,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: context.colors.dark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  log.timestamp.toString().split('.')[0],
                                  style: TextStyle(
                                    color: context.colors.muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class TeamPage extends StatefulWidget {
  const TeamPage({super.key, required this.api});

  final ApiClient api;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // HERO HEADER
        SliverToBoxAdapter(
          child: FadeInUp(
            delay: 100,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colors.green.withOpacity(0.85),
                    context.colors.teal.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.05),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: _pulseController.value * 20,
                                spreadRadius: _pulseController.value * 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.park_outlined,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Mapan',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitoring Iklim & Kesehatan Tanaman',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        // CONTENT
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              FadeInUp(
                delay: 200,
                child: const Text(
                  'Misi Kami',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: 300,
                child: _buildGlassCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.biotech,
                          color: Colors.greenAccent,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Inovasi Pertanian Pintar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Menghadirkan teknologi deteksi dini penyakit tanaman dan pemantauan lingkungan demi hasil panen yang maksimal dan berkelanjutan.',
                              style: TextStyle(
                                color: Colors.white70,
                                height: 1.6,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              FadeInUp(
                delay: 400,
                child: const Text(
                  'Tim Pengembang',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // BENTO GRID FOR TEAM
              Row(
                children: [
                  Expanded(
                    child: FadeInUp(
                      delay: 500,
                      child: const _InteractiveTeamCard(
                        name: 'Bagus Ardiansyah',
                        role: 'Flutter Developer',
                        icon: Icons.app_shortcut,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FadeInUp(
                      delay: 600,
                      child: const _InteractiveTeamCard(
                        name: 'Restu Aleksa',
                        role: 'Project Lead',
                        icon: Icons.rocket_launch,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: 700,
                child: const _InteractiveTeamCard(
                  name: 'S.M. Hasyim',
                  role: 'Backend Integrator',
                  icon: Icons.dns_rounded,
                  color: Colors.purpleAccent,
                  isWide: true,
                ),
              ),

              const SizedBox(height: 32),
              FadeInUp(
                delay: 800,
                child: const Text(
                  'Dukungan & Informasi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: 900,
                child: _buildGlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildInteractiveLink(
                        icon: Icons.link,
                        title: 'Backend Base URL',
                        subtitle: widget.api.baseUrl,
                        onTap: () => _openExternal(
                          context,
                          Uri.parse(widget.api.baseUrl),
                        ),
                      ),
                      Divider(color: Colors.white.withOpacity(0.1), height: 1),
                      _buildInteractiveLink(
                        icon: Icons.description_outlined,
                        title: 'API Contract',
                        subtitle: 'Lihat dokumen referensi API',
                        onTap: () => _openExternal(
                          context,
                          Uri.parse(
                            '${widget.api.baseUrl}/public/api/v1/diseases',
                          ),
                        ),
                      ),
                      Divider(color: Colors.white.withOpacity(0.1), height: 1),
                      _buildInteractiveLink(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi',
                        subtitle: 'Syarat dan ketentuan Mapan',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
              FadeInUp(
                delay: 1000,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Mapan v1.0.0 - 2026',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInteractiveLink({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.white.withOpacity(0.1),
        splashColor: Colors.white.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _openExternal(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka $uri')),
      );
    }
  }
}

class _InteractiveTeamCard extends StatefulWidget {
  final String name;
  final String role;
  final IconData icon;
  final Color color;
  final bool isWide;

  const _InteractiveTeamCard({
    required this.name,
    required this.role,
    required this.icon,
    required this.color,
    this.isWide = false,
  });

  @override
  State<_InteractiveTeamCard> createState() => _InteractiveTeamCardState();
}

class _InteractiveTeamCardState extends State<_InteractiveTeamCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isPressed
                    ? widget.color.withOpacity(0.2)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isPressed
                      ? widget.color.withOpacity(0.5)
                      : Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  if (_isPressed)
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: widget.isWide
                  ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.role,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.role,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.icon,
  });
  final String name;
  final String role;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.field,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: context.colors.greenSoft,
            child: Icon(icon, color: context.colors.green, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: context.colors.dark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(color: context.colors.muted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.user,
    this.token,
    required this.api,
    required this.onAuthChanged,
  });

  final UserProfile user;
  final String? token;
  final ApiClient api;
  final void Function(String?, [UserProfile?]) onAuthChanged;

  void _showChangePasswordDialog(BuildContext context) {
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    final currentPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('Ubah Kata Sandi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi Saat Ini',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi Baru (min 8 karakter)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.t('confirm_new_password'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx),
              child: Text(context.t('cancel'), style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.t('password_not_match')),
                          ),
                        );
                        return;
                      }
                      if (newPasswordCtrl.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kata sandi baru minimal 8 karakter'),
                          ),
                        );
                        return;
                      }
                      setModalState(() => isSaving = true);
                      try {
                        await api.updatePassword(
                          token!,
                          currentPasswordCtrl.text,
                          newPasswordCtrl.text,
                          confirmPasswordCtrl.text,
                        );
                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kata sandi berhasil diperbarui'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('${context.t('failed_generic', listen: false)} $e')));
                        }
                      } finally {
                        setModalState(() => isSaving = false);
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, context.t('account_management')),
          const SizedBox(height: 8),
          _buildCard(
            children: [
              _buildListTile(
                icon: Icons.person_outline,
                title: context.t('edit_profile'),
                onTap: () {
                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Silakan login terlebih dahulu'),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EditProfilePage(
                        user: user,
                        token: token!,
                        api: api,
                        onProfileUpdated: (newUser) {
                          onAuthChanged(token, newUser);
                        },
                        onAccountDeleted: () {
                          onAuthChanged(null);
                        },
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.lock_reset,
                title: context.t('change_password'),
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
              if (user.role == 'user') ...[
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.workspace_premium,
                  title: context.t('ask_expert'),
                  onTap: () {
                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan login terlebih dahulu'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            ExpertApplicationPage(api: api, token: token!),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.business,
                  title: 'Daftar sebagai Admin Mitra',
                  onTap: () {
                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan login terlebih dahulu'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            AdminApplicationPage(api: api, token: token!),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, context.t('app_preferences')),
          const SizedBox(height: 8),
          _buildCard(
            children: [
              _buildListTile(
                icon: Icons.notifications_active_outlined,
                title: context.t('notifications'),
                trailing: Switch(
                  value: context.watch<AppNotifications>().isEnabled,
                  onChanged: (val) {
                    context.read<AppNotifications>().toggle(context);
                  },
                  activeColor: context.colors.green,
                ),
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.language,
                title: context.t('language_label'),
                subtitle: context.t('language'),
                onTap: () {
                  context.read<AppLanguage>().toggleLanguage();
                },
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.dark_mode_outlined,
                title: context.t('dark_mode'),
                trailing: Switch(
                  value: context.watch<AppTheme>().themeMode == ThemeMode.dark,
                  onChanged: (val) {
                    context.read<AppTheme>().toggleTheme();
                  },
                  activeColor: context.colors.green,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, context.t('support_about')),
          const SizedBox(height: 8),
          _buildCard(
            children: [
              _buildListTile(
                icon: Icons.help_outline,
                title: context.t('help_center'),
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.bug_report_outlined,
                title: user.role == 'super_admin'
                    ? context.t('app_feedback_center')
                    : context.t('bug_report'),
                onTap: () {
                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Silakan login terlebih dahulu'),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) =>
                          FeedbacksPage(user: user, api: api, token: token!),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.privacy_tip_outlined,
                title: context.t('privacy'),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          const SizedBox(height: 32),
          if (user.role == 'guest')
            FilledButton.icon(
              onPressed: () {
                // Return to home so they can login via drawer
                onAuthChanged(null);
              },
              icon: const Icon(Icons.login),
              label: Text(context.t('login_to_detect')),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            FilledButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(context.t('logout')),
                    content: const Text(
                      'Apakah Anda yakin ingin keluar dari akun ini?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(context.t('cancel')),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: context.colors.red,
                        ),
                        child: Text(context.t('logout')),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  onAuthChanged(null);
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(context.t('logout')),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.red.withOpacity(0.1),
                foregroundColor: context.colors.red,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: context.colors.red.withOpacity(0.3)),
                ),
              ),
            ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Future<void> _uploadAvatar(BuildContext context, String path) async {
    if (token == null) return;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('uploading_profile_photo', listen: false))),
      );
      final newUser = await api.uploadPhoto(token!, path);
      onAuthChanged(token, newUser);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('profile_photo_updated', listen: false))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed_update_error', listen: false)} $e')));
      }
    }
  }

  Future<void> _deleteAvatar(BuildContext context) async {
    if (token == null) return;
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('deleting_profile_photo', listen: false))));
      final newUser = await api.deletePhoto(token!);
      onAuthChanged(token, newUser);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('profile_photo_deleted', listen: false))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed_delete_generic', listen: false)} $e')));
      }
    }
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (user.role == 'guest') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Silakan login terlebih dahulu'),
                  ),
                );
                return;
              }
              showModalBottomSheet(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Ambil dari Kamera'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final picker = ImagePicker();
                          final photo = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 70,
                            maxWidth: 1000,
                            maxHeight: 1000,
                          );
                          if (photo != null && context.mounted) {
                            _uploadAvatar(context, photo.path);
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Pilih dari Galeri'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final picker = ImagePicker();
                          final photo = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,
                            maxWidth: 1000,
                            maxHeight: 1000,
                          );
                          if (photo != null && context.mounted) {
                            _uploadAvatar(context, photo.path);
                          }
                        },
                      ),
                      if (user.avatarUrl != null)
                        ListTile(
                          leading: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          title: const Text(
                            'Hapus Foto Profil',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            Navigator.pop(ctx);
                            _deleteAvatar(context);
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: context.colors.mint,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(
                          '${ApiClient.currentBaseUrl}${user.avatarUrl}',
                        )
                      : null,
                  child: user.avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 48,
                          color: context.colors.green,
                        )
                      : null,
                ),
                if (user.role != 'guest')
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: context.colors.green,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.colors.dark,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user, size: 16, color: context.colors.green),
              const SizedBox(width: 4),
              Text(
                user.role == 'super_admin'
                    ? 'Super Admin'
                    : user.role == 'admin'
                    ? (user.agencyName != null ? 'Admin - ${user.agencyName}' : 'Admin')
                    : user.role == 'pakar'
                    ? context.t('role_expert')
                    : context.t('role_user'),
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: context.colors.muted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children, BuildContext? ctx}) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.greenSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: context.colors.green),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: context.colors.dark,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              )
            : null,
        trailing:
            trailing ?? Icon(Icons.chevron_right, color: context.colors.muted),
        onTap: onTap,
      ),
    );
  }
}

class ClimateDrawer extends StatefulWidget {
  const ClimateDrawer({
    super.key,
    required this.selectedIndex,
    required this.user,
    required this.token,
    required this.api,
    required this.onSelect,
    required this.onAuthChanged,
  });

  final int selectedIndex;
  final UserProfile user;
  final String? token;
  final ApiClient api;
  final ValueChanged<int> onSelect;
  final void Function(String? token, [UserProfile? user]) onAuthChanged;

  @override
  State<ClimateDrawer> createState() => _ClimateDrawerState();
}

class _ClimateDrawerState extends State<ClimateDrawer> {
  final TextEditingController _email = TextEditingController(
    text: 'superadmin@mapan.test',
  );
  final TextEditingController _password = TextEditingController(
    text: 'password',
  );
  bool _loggingIn = false;

  Future<void> _login() async {
    setState(() => _loggingIn = true);
    try {
      final auth = await widget.api.login(_email.text.trim(), _password.text);
      AppLogger.info('Login berhasil untuk user ${_email.text.trim()}');
      widget.onAuthChanged(auth.token, auth.user);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $error')));
    } finally {
      if (mounted) {
        setState(() => _loggingIn = false);
      }
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('cancel'), style: TextStyle(color: context.colors.muted)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _login();
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.green,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 48, 22, 22),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/farmer_hero_banner.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.mint,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.eco,
                        color: const Color(0xFF007A4D),
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Mapan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  widget.user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.mint.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.token == null ? 'Guest mode' : widget.user.role,
                    style: TextStyle(
                      color: context.colors.dark,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (widget.user.role != 'super_admin')
                  DrawerDestination(
                    selected: widget.selectedIndex == 0,
                    icon: Icons.dashboard_outlined,
                    label: context.t('main_view'),
                    onTap: () => widget.onSelect(0),
                  ),
                if (widget.user.role == 'super_admin')
                  DrawerDestination(
                    selected: widget.selectedIndex == 0,
                    icon: Icons.dashboard_customize_outlined,
                    label: 'Sistem Dashboard',
                    onTap: () => widget.onSelect(0),
                  ),
                if (widget.user.role == 'super_admin')
                  DrawerDestination(
                    selected: widget.selectedIndex == 7,
                    icon: Icons.science_outlined,
                    label: context.t('expert_management'),
                    onTap: () => widget.onSelect(7),
                  ),
                if (widget.user.role == 'super_admin')
                  DrawerDestination(
                    selected: widget.selectedIndex == 9,
                    icon: Icons.manage_accounts_outlined,
                    label: context.t('user_management'),
                    onTap: () => widget.onSelect(9),
                  ),

                DrawerDestination(
                  selected: widget.selectedIndex == 4,
                  icon: Icons.person_outline,
                  label: context.t('profile'),
                  onTap: () => widget.onSelect(4),
                ),
                DrawerDestination(
                  selected: widget.selectedIndex == 6,
                  icon: Icons.info_outline,
                  label: context.t('about'),
                  onTap: () => widget.onSelect(6),
                ),
                if (widget.user.role == 'super_admin')
                  DrawerDestination(
                    selected: widget.selectedIndex == 5,
                    icon: Icons.bug_report_outlined,
                    label: context.t('system_logs'),
                    onTap: () => widget.onSelect(5),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.token == null)
                  FilledButton.icon(
                    onPressed: _loggingIn ? null : _showLoginDialog,
                    icon: _loggingIn
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colors.surface,
                            ),
                          )
                        : const Icon(Icons.login),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(context.t('logout')),
                          content: Text(
                            context.t('confirm_logout_desc', listen: false) ?? 'Apakah Anda yakin ingin keluar dari akun ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(
                                'Batal',
                                style: TextStyle(color: context.colors.muted),
                              ),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: FilledButton.styleFrom(
                                backgroundColor: context.colors.red,
                              ),
                              child: Text(context.t('logout')),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        widget.onAuthChanged(
                          null,
                          const UserProfile(
                            name: 'Guest User',
                            email: 'guest@mapan.id',
                            role: 'guest',
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.logout, color: context.colors.red),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      context.t('logout'),
                      style: TextStyle(
                        color: context.colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(context.t('confirm')),
                        content: const Text(
                          'Apakah Anda yakin ingin keluar dari aplikasi?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                              'Batal',
                              style: TextStyle(color: context.colors.muted),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                              'Ya, Keluar',
                              style: TextStyle(color: context.colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      SystemNavigator.pop();
                    }
                  },
                  icon: Icon(
                    Icons.power_settings_new,
                    color: context.colors.muted,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: Text(
                    'Keluar Aplikasi',
                    style: TextStyle(color: context.colors.muted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClimateBottomNav extends StatelessWidget {
  const ClimateBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.role,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;
  final String role;

  @override
  Widget build(BuildContext context) {
    int visibleIndex = 0;
    if (role == 'pakar' || role == 'super_admin') {
      if (currentIndex == 0 ||
          currentIndex == 9) // 0 is DashboardPage, 9 is SuperAdminDashboardPage
        visibleIndex = 0;
      else if (currentIndex == 1)
        visibleIndex = 1;
      else if (currentIndex == 7 ||
          currentIndex == 11) // ExpertHubPage or PakarWorkspacePage
        visibleIndex = 2;
      else if (currentIndex == 4)
        visibleIndex = 3;
    } else if (role == 'admin') {
      if (currentIndex == 0 || currentIndex == 8) // DashboardPage or legacy AdminDashboardPage
        visibleIndex = 0;
      else if (currentIndex == 1) // DetectionsPage
        visibleIndex = 1;
      else if (currentIndex == 4) // ProfilePage
        visibleIndex = 2;
      else
        visibleIndex = 0;
    } else {
      visibleIndex = currentIndex > 4 ? 0 : currentIndex;
    }

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: context.colors.mint);
          }
          return IconThemeData(color: context.colors.muted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: context.colors.mint,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(color: context.colors.muted);
        }),
      ),
      child: NavigationBar(
        selectedIndex: visibleIndex,
        height: 72,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        indicatorColor: context.colors.mint.withOpacity(0.25),
        onDestinationSelected: onChanged,
        destinations: role == 'pakar' || role == 'super_admin'
            ? [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: context.t('home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history),
                  label: context.t('history'),
                ),
                NavigationDestination(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.green,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      role == 'super_admin'
                          ? Icons.science_outlined
                          : Icons.work_outline,
                      color: Colors.white,
                    ),
                  ),
                  label: role == 'super_admin'
                      ? context.t('database')
                      : context.t('workspace'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: context.t('profile'),
                ),
              ]
            : role == 'admin'
            ? [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: context.t('home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history),
                  label: context.t('all_reports'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: context.t('profile'),
                ),
              ]
            : [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: context.t('home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history),
                  label: context.t('history'),
                ),
                NavigationDestination(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.green,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.document_scanner,
                      color: Colors.white,
                    ),
                  ),
                  label: context.t('detection'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.add_circle_outline),
                  label: context.t('add'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: context.t('profile'),
                ),
              ],
      ),
    );
  }
}

class ApiClient {
  static String currentBaseUrl =
      'https://arturo-untaunting-thrawnly.ngrok-free.dev';
  final String _baseUrl;

  ApiClient({String? baseUrl}) : _baseUrl = baseUrl ?? currentBaseUrl {
    currentBaseUrl = _baseUrl;
  }

  String get baseUrl => _baseUrl;

  Future<void> verifyOtp(String email, String otp) async {
    await request('POST', '/auth/verify-otp', body: {
      'email': email,
      'otp': otp,
    });
  }

  Future<AuthResult> login(String email, String password) async {
    final json = await request(
      'POST',
      '/public/api/v1/login',
      body: {'email': email, 'password': password},
    );
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return AuthResult(
      token: '${json['token'] ?? ''}',
      user: UserProfile(
        name: '${user['name'] ?? 'Climate User'}',
        email: '${user['email'] ?? email}',
        role: '${user['role'] ?? 'user'}',
        pendingRole: user['pending_role'] as String?,
        avatarUrl: user['avatar_url'] as String?,
        agencyName: user['agency_name'] as String?,
      ),
      isNewUser: false,
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    await request(
      'POST',
      '/public/api/v1/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
      },
    );
  }

  Future<AuthResult> loginWithGoogle(
    String idToken, {
    String action = 'login',
  }) async {
    final json = await request(
      'POST',
      '/public/api/v1/login/google',
      body: {'id_token': idToken, 'action': action},
    );
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return AuthResult(
      token: '${json['token'] ?? ''}',
      user: UserProfile(
        name: '${user['name'] ?? 'Google User'}',
        email: '${user['email'] ?? ''}',
        role: '${user['role'] ?? 'user'}',
        pendingRole: user['pending_role'] as String?,
        avatarUrl: user['avatar_url'] as String?,
        agencyName: user['agency_name'] as String?,
      ),
      isNewUser: json['is_new_user'] == true,
    );
  }

  Future<void> updateRole(String token, String role) async {
    await request(
      'PUT',
      '/private/api/v1/user/role',
      token: token,
      body: {'role': role},
    );
  }

  Future<void> forgotPassword(String email) async {
    await request(
      'POST',
      '/public/api/v1/forgot-password',
      body: {'email': email},
    );
  }

  Future<void> resetPassword(
    String email,
    String token,
    String password,
  ) async {
    await request(
      'POST',
      '/public/api/v1/reset-password',
      body: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  Future<UserProfile> updateProfile(
    String token,
    String name,
    String email,
  ) async {
    final json = await request(
      'PUT',
      '/private/api/v1/user/profile',
      token: token,
      body: {'name': name, 'email': email},
    );
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      name: '${user['name'] ?? name}',
      email: '${user['email'] ?? email}',
      role: '${user['role'] ?? 'user'}',
      avatarUrl: user['avatar_url'] as String?,
      agencyName: user['agency_name'] as String?,
    );
  }

  Future<void> updatePassword(
    String token,
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    await request(
      'PUT',
      '/private/api/v1/user/password',
      token: token,
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      },
    );
  }

  Future<UserProfile> uploadPhoto(String token, String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final ext = imagePath.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/private/api/v1/user/photo'),
    );
    req.headers['Authorization'] = 'Bearer $token';
    req.headers['Accept'] = 'application/json';
    req.headers['X-App-Secret'] = 'MapanRahasia2026';
    req.files.add(
      http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: 'avatar.$ext',
        contentType: http_parser.MediaType.parse(mimeType),
      ),
    );

    final res = await req.send();
    final resBody = await res.stream.bytesToString();
    final json = jsonDecode(resBody);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(json['message'] ?? 'Gagal mengunggah foto');
    }

    final user = json['user'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      name: '${user['name'] ?? ''}',
      email: '${user['email'] ?? ''}',
      role: '${user['role'] ?? 'user'}',
      avatarUrl: user['avatar_url'] as String?,
      agencyName: user['agency_name'] as String?,
    );
  }

  Future<UserProfile> deletePhoto(String token) async {
    final json = await request(
      'DELETE',
      '/private/api/v1/user/photo',
      token: token,
    );
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      name: '${user['name'] ?? ''}',
      email: '${user['email'] ?? ''}',
      role: '${user['role'] ?? 'user'}',
      avatarUrl: null,
      agencyName: user['agency_name'] as String?,
    );
  }

  Future<void> deleteAccount(String token) async {
    await request('DELETE', '/private/api/v1/user', token: token);
  }

  Future<List<DiseaseOption>> fetchDiseases() async {
    final json = await request('GET', '/public/api/v1/diseases');
    final data = json['diseases'] ?? json['data'];
    if (data is! List) {
      return DiseaseOption.samples();
    }
    return data
        .map((item) => item as Map<String, dynamic>)
        .map((item) {
          final treatmentsRaw = item['treatments'];
          List<String> treatments = [];
          if (treatmentsRaw is List) {
            treatments = treatmentsRaw
                .map((t) => (t['description'] ?? '').toString())
                .where((t) => t.isNotEmpty)
                .toList();
          }
          return DiseaseOption(
            id: item['id'] as int? ?? 0,
            name: '${item['name'] ?? '-'}',
            latinName: item['latin_name']?.toString(),
            description: item['description']?.toString(),
            treatments: treatments,
          );
        })
        .where((item) => item.id > 0)
        .toList();
  }

  Future<List<MapDetection>> fetchMapDetections(String token, {String? diseaseId, String? startDate, String? endDate}) async {
    String query = '';
    if (diseaseId != null) query += '&disease_id=$diseaseId';
    if (startDate != null) query += '&start_date=$startDate';
    if (endDate != null) query += '&end_date=$endDate';
    if (query.isNotEmpty) query = '?${query.substring(1)}';

    final json = await request(
      'GET',
      '/private/api/v1/admin/map/detections$query',
      token: token,
    );
    final data = json['data'];
    if (data is! List) {
      return const [];
    }
    return data
        .where((item) => item is Map)
        .map((item) => MapDetection.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<DetectionItem> fetchDetection(String token, String id) async {
    final response = await request(
      'GET',
      '/public/api/v1/detections/$id?_t=${DateTime.now().millisecondsSinceEpoch}',
    );
    return DetectionItem.fromJson(response['data'] ?? response);
  }

  Future<List<DetectionItem>> fetchPublicDetections() async {
    final json = await request(
      'GET',
      '/public/api/v1/detections?_t=${DateTime.now().millisecondsSinceEpoch}',
    );
    final data = json['data'];
    if (data is! List) {
      return const [];
    }
    return data
        .where((item) => item is Map)
        .map((item) => DetectionItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<List<DetectionItem>> fetchMyDetections(String token) async {
    final json = await request(
      'GET',
      '/private/api/v1/detections?_t=${DateTime.now().millisecondsSinceEpoch}',
      token: token,
    );
    final data = json['data'];
    if (data is! List) {
      return const [];
    }
    return data
        .where((item) => item is Map)
        .map((item) => DetectionItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<DashboardStats> fetchDashboardStats(String token) async {
    final json = await request(
      'GET',
      '/private/api/v1/dashboard/stats',
      token: token,
    );
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final distribution = json['disease_distribution'] as List? ?? [];
    final insightJson = json['insight'] as Map<String, dynamic>?;

    // Parse average confidence (it comes as a decimal 0.0 - 1.0 or 0 - 100 depending on backend)
    // The backend uses round(avg, 2) and confidence is usually 0-1. So we multiply by 100.
    final avgConf = (stats['average_confidence'] as num?)?.toDouble() ?? 0.0;
    final accuracyPercent = avgConf > 1.0
        ? avgConf.toInt()
        : (avgConf * 100).toInt();

    return DashboardStats(
      totalDetections: stats['total_detections'] as int? ?? 0,
      totalDiseases: distribution.length,
      accuracyPercent: accuracyPercent,
      weeklyGrowth: stats['detections_this_month'] as int? ?? 0,
      totalExpertApplications: stats['total_expert_applications'] as int? ?? 0,
      insight: InsightData.fromJson(insightJson),
      trendingDiseases: List<Map<String, dynamic>>.from(json['trending_diseases'] ?? []),
    );
  }

  Future<void> createDetection({
    required String token,
    required int diseaseId,
    required String notes,
    String method = 'image',
    double? confidence,
    List<String>? images,
    bool isReport = false,
    double? latitude,
    double? longitude,
    String? status,
  }) async {
    if (images != null && images.isNotEmpty) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/private/api/v1/detections'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['X-App-Secret'] = 'MapanRahasia2026';
      request.headers['Idempotency-Key'] = generateUuid();

      request.fields['disease_id'] = diseaseId.toString();
      request.fields['notes'] = notes;
      request.fields['method'] = method;
      request.fields['is_report'] = isReport ? '1' : '0';
      if (confidence != null) {
        request.fields['confidence'] = confidence.toString();
      }
      if (latitude != null && longitude != null) {
        request.fields['latitude'] = latitude.toString();
        request.fields['longitude'] = longitude.toString();
      }
      if (status != null) {
        request.fields['status'] = status;
      }

      List<String> finalImages = [];
      for (int i = 0; i < images.length; i++) {
        final ext = images[i].split('.').last.toLowerCase();
        final isJpgOrPng = ext == 'jpg' || ext == 'jpeg' || ext == 'png';
        if (isJpgOrPng) {
          try {
            final tempDir = await getTemporaryDirectory();
            final targetPath =
                '${tempDir.path}/comp_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            final compressedFile =
                await FlutterImageCompress.compressAndGetFile(
                  images[i],
                  targetPath,
                  quality: 60,
                  minWidth: 1080,
                  minHeight: 1080,
                );
            if (compressedFile != null) {
              finalImages.add(compressedFile.path);
            } else {
              finalImages.add(images[i]);
            }
          } catch (e) {
            finalImages.add(images[i]);
          }
        } else {
          finalImages.add(images[i]);
        }
      }

      for (int i = 0; i < finalImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', finalImages[i]),
        );
      }

      // Send first image as main for backward compatibility if backend expects it
      request.files.add(
        await http.MultipartFile.fromPath('image', finalImages.first),
      );

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 201) {
        throw Exception('Failed to create detection: ${response.body}');
      }
    } else {
      await request(
        'POST',
        '/private/api/v1/detections',
        token: token,
        body: {
          'disease_id': diseaseId,
          'method': method,
          'notes': notes,
          'is_report': isReport,
          if (confidence != null) 'confidence': confidence,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (status != null) 'status': status,
        },
      );
    }
  }

  Future<void> reviewReport({
    required String token,
    required String detectionId,
    required String status,
    required String severity,
    String? expertNotes,
    int? diseaseId,
    double? confidence,
  }) async {
    await request(
      'PUT',
      '/private/api/v1/detections/$detectionId/review',
      token: token,
      body: {
        'status': status,
        'severity': severity,
        if (expertNotes != null) 'expert_notes': expertNotes,
        if (diseaseId != null) 'disease_id': diseaseId,
        if (confidence != null) 'confidence': confidence,
      },
    );
  }

  Future<void> deleteDetection({required String token, required int id}) async {
    await request('DELETE', '/private/api/v1/detections/$id', token: token);
  }

  Future<void> claimDetection({
    required String token,
    required String id,
  }) async {
    await request(
      'POST',
      '/private/api/v1/detections/$id/claim',
      token: token,
    );
  }

  Future<List<dynamic>> fetchMapStatistics(String token) async {
    final response = await request(
      'GET',
      '/private/api/v1/admin/map-statistics',
      token: token,
    );
    return response['data'] as List<dynamic>? ?? [];
  }

  Future<void> unclaimDetection({
    required String token,
    required String id,
  }) async {
    await request(
      'POST',
      '/private/api/v1/detections/$id/unclaim',
      token: token,
    );
  }

  // ===================================================================
  // EXPERT APPLICATIONS API (Admin)
  // ===================================================================

  Future<List<ExpertApplication>> fetchExpertApplications(String token) async {
    final response = await request(
      'GET',
      '/private/api/v1/admin/system/expert-applications',
      token: token,
    );
    final data = response['data']['data'] as List;
    return data.map((json) => ExpertApplication.fromJson(json)).toList();
  }

  Future<ExpertApplication> fetchExpertApplication(
    String token,
    String id,
  ) async {
    final response = await request(
      'GET',
      '/private/api/v1/admin/system/expert-applications/$id',
      token: token,
    );
    return ExpertApplication.fromJson(response['data']);
  }

  Future<void> approveExpertApplication(String token, String id) async {
    await request(
      'POST',
      '/private/api/v1/admin/system/expert-applications/$id/approve',
      token: token,
    );
  }

  Future<void> rejectExpertApplication(String token, String id) async {
    await request(
      'POST',
      '/private/api/v1/admin/system/expert-applications/$id/reject',
      token: token,
    );
  }

  Future<void> logFakeGpsAttempt(String token, double lat, double lon) async {
    try {
      await request(
        'POST',
        '/private/api/v1/system/log-fake-gps',
        token: token,
        body: {
          'latitude': lat,
          'longitude': lon,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Ignore error if endpoint doesn't exist yet
      debugPrint('Failed to log Fake GPS: $e');
    }
  }

  String generateUuid() {
    final random = math.Random();
    const chars = '0123456789abcdef';
    final buffer = StringBuffer();
    for (var i = 0; i < 36; i++) {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        buffer.write('-');
      } else if (i == 14) {
        buffer.write('4');
      } else if (i == 19) {
        buffer.write(chars[8 + random.nextInt(4)]);
      } else {
        buffer.write(chars[random.nextInt(16)]);
      }
    }
    return buffer.toString();
  }

  static dynamic _parseJsonInBackground(String text) {
    return jsonDecode(text);
  }

  Future<Map<String, dynamic>> request(
    String method,
    String path, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': '69420',
      'X-App-Secret': 'MapanRahasia2026',
      if (body != null) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (['POST', 'PUT', 'PATCH', 'DELETE'].contains(method.toUpperCase()))
        'Idempotency-Key': generateUuid(),
    };

    http.Response response;
    try {
      response = await switch (method) {
        'GET' => http.get(uri, headers: headers).timeout(const Duration(seconds: 20)),
        'POST' => http.post(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20)),
        'PUT' => http.put(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 20)),
        'DELETE' => http.delete(uri, headers: headers).timeout(const Duration(seconds: 20)),
        _ => throw Exception('Unsupported method $method'),
      };
    } on TimeoutException {
      throw Exception('Koneksi timeout (20 detik). Silakan coba lagi.');
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : await compute(_parseJsonInBackground, response.body);
    final json = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final msg = json['message'] ?? 'HTTP ${response.statusCode}';
      AppLogger.error('API Error di $path: $msg');
      throw Exception(msg);
    }
    return json;
  }

  Future<void> updateFcmToken(String token, String fcmToken) async {
    await request(
      'POST',
      '/private/api/v1/fcm-token',
      token: token,
      body: {'fcm_token': fcmToken},
    );
  }

  // ===================================================================
  // NOTIFICATIONS & REVIEW API
  // ===================================================================

  Future<DetectionItem> updateDetection({
    required String token,
    required int id,
    int? diseaseId,
    required String status,
    String? expertNotes,
  }) async {
    final response = await request(
      'PUT',
      '/private/api/v1/admin/detections/$id',
      token: token,
      body: {
        if (diseaseId != null) 'disease_id': diseaseId,
        'status': status,
        if (expertNotes != null) 'expert_notes': expertNotes,
      },
    );
    return DetectionItem.fromJson(response['detection']);
  }

  Future<Map<String, dynamic>> fetchNotifications(String token) async {
    final response = await request(
      'GET',
      '/private/api/v1/notifications?_t=${DateTime.now().millisecondsSinceEpoch}',
      token: token,
    );
    return {
      'notifications': (response['notifications'] as List)
          .map((n) => AppNotification.fromJson(n))
          .toList(),
      'unread_count': response['unread_count'],
    };
  }

  Future<void> markNotificationRead(String token, String id) async {
    await request(
      'POST',
      '/private/api/v1/notifications/$id/mark-read',
      token: token,
    );
  }

  Future<void> markAllNotificationsRead(String token) async {
    await request(
      'POST',
      '/private/api/v1/notifications/mark-read',
      token: token,
    );
  }

  // ===== FEEDBACKS =====
  Future<List<FeedbackItem>> fetchFeedbacks(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/private/api/v1/feedbacks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((item) => FeedbackItem.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching feedbacks: $e');
      return [];
    }
  }

  Future<bool> createFeedback(
    String token,
    String type,
    String content,
    String? imagePath,
  ) async {
    try {
      var req = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/private/api/v1/feedbacks'),
      );
      req.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Idempotency-Key': generateUuid(),
      });
      req.fields['type'] = type;
      req.fields['content'] = content;

      if (imagePath != null) {
        req.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var streamedResponse = await req.send();
      return streamedResponse.statusCode == 201;
    } catch (e) {
      print('Error creating feedback: $e');
      return false;
    }
  }

  Future<bool> replyFeedback(
    String token,
    int feedbackId,
    String adminResponse,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/private/api/v1/admin/feedbacks/$feedbackId/reply'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'admin_response': adminResponse}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error replying to feedback: $e');
      return false;
    }
  }

  Future<void> deleteAllReadNotifications(String token) async {
    await request('DELETE', '/private/api/v1/notifications', token: token);
  }
}

class AppNotification {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: json['type'],
      data: json['data'] ?? {},
      isRead: json['read_at'] != null,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class AuthResult {
  const AuthResult({
    required this.token,
    required this.user,
    this.isNewUser = false,
  });

  final String token;
  final UserProfile user;
  final bool isNewUser;
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.role,
    this.pendingRole,
    this.avatarUrl,
    this.agencyName,
  });

  final String name;
  final String email;
  final String role;
  final String? pendingRole;
  final String? avatarUrl;
  final String? agencyName;
}

class InsightData {
  final bool hasInsight;
  final String? diseaseName;
  final int? count;
  final String? recommendation;

  const InsightData({
    required this.hasInsight,
    this.diseaseName,
    this.count,
    this.recommendation,
  });

  factory InsightData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const InsightData(hasInsight: false);

    String rawName = json['disease_name']?.toString() ?? '';
    final n = rawName.toLowerCase();
    if (n.contains('false smut'))
      rawName = 'Hawar Bulir (False Smut)';
    else if (n.contains('bacterial leaf blight'))
      rawName = 'Hawar Daun Bakteri (Bacterial Leaf Blight)';
    else if (n.contains('bacterial leaf streak'))
      rawName = 'Garis Bakteri Daun (Bacterial Leaf Streak)';
    else if (n.contains('bacterial panicle blight'))
      rawName = 'Hawar Malai Bakteri (Bacterial Panicle Blight)';
    else if (n.contains('bakanae'))
      rawName = 'Penyakit Bakanae (Bakanae)';
    else if (n.contains('neck blast'))
      rawName = 'Busuk Leher (Neck Blast)';
    else if (n.contains('blast'))
      rawName = 'Penyakit Blast (Blast)';
    else if (n.contains('narrow brown leaf spot'))
      rawName = 'Bercak Coklat Sempit (Narrow Brown Leaf Spot)';
    else if (n.contains('brown spot'))
      rawName = 'Bercak Daun Coklat (Brown Spot)';
    else if (n.contains('dead heart'))
      rawName = 'Sundep (Dead Heart)';
    else if (n.contains('downy mildew'))
      rawName = 'Bulai (Downy Mildew)';
    else if (n.contains('grassy stunt virus'))
      rawName = 'Virus Kerdil Rumput (Grassy Stunt Virus)';
    else if (n.contains('ragged stunt virus'))
      rawName = 'Virus Kerdil Hampa (Ragged Stunt Virus)';
    else if (n.contains('sheath blight'))
      rawName = 'Hawar Upih Daun (Sheath Blight)';
    else if (n.contains('sheath rot'))
      rawName = 'Busuk Upih (Sheath Rot)';
    else if (n.contains('stem rot'))
      rawName = 'Busuk Batang (Stem Rot)';
    else if (n.contains('leaf scald'))
      rawName = 'Hawar Pelepah Daun (Leaf Scald)';
    else if (n.contains('leaf smut'))
      rawName = 'Jamur Daun (Leaf Smut)';
    else if (n.contains('tungro'))
      rawName = 'Penyakit Tungro (Tungro)';
    else if (n.contains('hispa'))
      rawName = 'Hama Hispa (Hispa)';
    else if (n.contains('bukan padi'))
      rawName = 'Bukan Padi / Tidak Dikenali';
    else if (n.contains('healthy'))
      rawName = 'Sehat (Healthy)';

    return InsightData(
      hasInsight: json['has_insight'] == true,
      diseaseName: rawName,
      count: json['count'],
      recommendation: json['recommendation'],
    );
  }
}

class DashboardStats {
  const DashboardStats({
    required this.totalDetections,
    required this.totalDiseases,
    required this.accuracyPercent,
    required this.weeklyGrowth,
    required this.insight,
    this.totalExpertApplications = 0,
    this.trendingDiseases = const [],
  });

  final int totalDetections;
  final int totalDiseases;
  final int accuracyPercent;
  final int weeklyGrowth;
  final int totalExpertApplications;
  final InsightData insight;
  final List<Map<String, dynamic>> trendingDiseases;

  factory DashboardStats.fallback() {
    return const DashboardStats(
      totalDetections: 0,
      totalDiseases: 0,
      accuracyPercent: 0,
      weeklyGrowth: 0,
      totalExpertApplications: 0,
      insight: InsightData(hasInsight: false),
      trendingDiseases: [],
    );
  }

  DashboardStats copyWith({
    int? totalDetections,
    List<Map<String, dynamic>>? trendingDiseases,
  }) {
    return DashboardStats(
      totalDetections: totalDetections ?? this.totalDetections,
      totalDiseases: totalDiseases,
      accuracyPercent: accuracyPercent,
      weeklyGrowth: weeklyGrowth,
      totalExpertApplications: totalExpertApplications,
      insight: insight,
      trendingDiseases: trendingDiseases ?? this.trendingDiseases,
    );
  }
}

class DiseaseOption {
  final int id;
  final String name;
  final String? latinName;
  final String? description;
  final String? cause;
  final List<String> treatments;
  final List<dynamic>? symptoms;

  String get translatedName {
    String indo = name;
    switch (name.toLowerCase()) {
      case 'dead heart': indo = 'Sundep (Dead Heart)'; break;
      case 'hispa': indo = 'Kumbang Hispa'; break;
      case 'downy mildew': indo = 'Bulai (Downy Mildew)'; break;
      case 'bacterial leaf blight': indo = 'Hawar Daun Bakteri'; break;
      case 'bacterial leaf streak': indo = 'Garis Bakteri Daun'; break;
      case 'bacterial panicle blight': indo = 'Hawar Malai Bakteri'; break;
      case 'bakanae': indo = 'Bakanae (Bibit Memanjang)'; break;
      case 'blast': indo = 'Blast'; break;
      case 'brown spot': indo = 'Bercak Coklat'; break;
      case 'bukan padi': indo = 'Bukan Padi'; break;
      case 'false smut': indo = 'Noda Palsu (False Smut)'; break;
      case 'grassy stunt virus': indo = 'Kerdil Rumput (Grassy Stunt)'; break;
      case 'healthy': indo = 'Sehat'; break;
      case 'leaf scald': indo = 'Hawar Pelepah Daun (Leaf Scald)'; break;
      case 'leaf smut': indo = 'Noda Hitam Daun (Leaf Smut)'; break;
      case 'narrow brown leaf spot': indo = 'Bercak Coklat Sempit'; break;
      case 'neck blast': indo = 'Busuk Leher (Neck Blast)'; break;
      case 'ragged stunt virus': indo = 'Kerdil Hampa (Ragged Stunt)'; break;
      case 'sheath blight': indo = 'Hawar Pelepah (Sheath Blight)'; break;
      case 'sheath rot': indo = 'Busuk Pelepah (Sheath Rot)'; break;
      case 'stem rot': indo = 'Busuk Batang (Stem Rot)'; break;
      case 'tungro': indo = 'Tungro'; break;
    }
    
    if (latinName != null && latinName!.isNotEmpty) {
      return '$indo ($latinName)';
    }
    return indo;
  }

  String get displayName => translatedName;

  const DiseaseOption({
    required this.id,
    required this.name,
    this.latinName,
    this.description,
    this.cause,
    this.treatments = const [],
    this.symptoms,
  });

  factory DiseaseOption.fromJson(Map<String, dynamic> json) {
    return DiseaseOption(
      id: json['id'],
      name: json['name'] ?? '',
      latinName: json['latin_name'],
      description: json['description'],
      cause: json['cause'],
      symptoms: json['symptoms'] != null && json['symptoms'] is List
          ? (json['symptoms'] as List)
          : [],
      treatments: json['treatments'] != null && json['treatments'] is List
          ? (json['treatments'] as List)
                .map(
                  (t) =>
                      t['title'] != null ? t['title'].toString() : t.toString(),
                )
                .toList()
          : [],
    );
  }

  static List<DiseaseOption> samples() {
    return const [
      DiseaseOption(
        id: 1,
        name: 'Blast',
        cause: 'Jamur Magnaporthe oryzae',
        description: 'Penyakit Blast disebabkan oleh jamur Magnaporthe oryzae.',
        treatments: [
          'Gunakan fungisida berbahan aktif trisiklazol',
          'Hindari pemupukan N berlebihan',
        ],
      ),
      DiseaseOption(
        id: 2,
        name: 'Brown Spot',
        cause: 'Jamur Bipolaris oryzae',
        description: 'Bercak coklat disebabkan oleh jamur Bipolaris oryzae.',
        treatments: ['Perbaiki nutrisi tanah', 'Gunakan fungisida yang sesuai'],
      ),
      DiseaseOption(
        id: 3,
        name: 'Bacterial Leaf Blight',
        cause: 'Bakteri Xanthomonas oryzae',
        description: 'Hawar daun bakteri disebabkan oleh Xanthomonas oryzae.',
        treatments: [
          'Keringkan petakan sawah secara berkala',
          'Aplikasi bakterisida berbahan aktif tembaga',
        ],
      ),
    ];
  }
}

class ExpertApplication {
  final int id;
  final int userId;
  final String status;
  final String reasons;
  final String cvPath;
  final String userName;
  final String userEmail;
  final String? userAvatarUrl;

  const ExpertApplication({
    required this.id,
    required this.userId,
    required this.status,
    required this.reasons,
    required this.cvPath,
    required this.userName,
    required this.userEmail,
    this.userAvatarUrl,
  });

  factory ExpertApplication.fromJson(Map<String, dynamic> json) {
    return ExpertApplication(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      reasons: json['notes'] ?? json['reasons'] ?? '',
      cvPath: json['document_path'] ?? json['cv_path'] ?? '',
      userName: json['user']?['name'] ?? 'Unknown',
      userEmail: json['user'] != null ? json['user']['email'] : '',
      userAvatarUrl: json['user'] != null ? json['user']['avatar_url'] : null,
    );
  }
}

class MapDetection {
  final int id;
  final String diseaseName;
  final double latitude;
  final double longitude;
  final double? confidence;
  final String date;
  final String? imageUrl;
  final String userName;
  final String severity;
  final String? city;

  const MapDetection({
    required this.id,
    required this.diseaseName,
    required this.latitude,
    required this.longitude,
    this.confidence,
    required this.date,
    this.imageUrl,
    required this.userName,
    required this.severity,
    this.city,
  });

  factory MapDetection.fromJson(Map<String, dynamic> json) {
    return MapDetection(
      id: json['id'] ?? 0,
      diseaseName: json['disease_name'] ?? 'Unknown',
      latitude: json['latitude'] != null ? (double.tryParse(json['latitude'].toString()) ?? 0.0) : 0.0,
      longitude: json['longitude'] != null ? (double.tryParse(json['longitude'].toString()) ?? 0.0) : 0.0,
      confidence: json['confidence'] != null ? double.tryParse(json['confidence'].toString()) : null,
      date: json['date'] ?? '',
      imageUrl: json['image_url'],
      userName: json['user_name'] ?? 'Anonim',
      severity: json['severity'] ?? 'Belum Dikonfirmasi',
      city: json['city'],
    );
  }
}

class FeedbackItem {
  final int id;
  final String type;
  final String content;
  final String? imagePath;
  final String status;
  final String? adminResponse;
  final String createdAt;
  final String? userName;
  final String? userEmail;
  final String? responderName;

  const FeedbackItem({
    required this.id,
    required this.type,
    required this.content,
    this.imagePath,
    required this.status,
    this.adminResponse,
    required this.createdAt,
    this.userName,
    this.userEmail,
    this.responderName,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'general',
      content: json['content'] ?? '',
      imagePath: json['image_path'],
      status: json['status'] ?? 'open',
      adminResponse: json['admin_response'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(
              json['created_at'],
            ).toLocal().toString().split('.')[0]
          : '',
      userName: json['user'] != null ? json['user']['name'] : null,
      userEmail: json['user'] != null ? json['user']['email'] : null,
      responderName: json['responder'] != null
          ? json['responder']['name']
          : null,
    );
  }
}

class DetectionItem {
  final int id;
  final String title;
  final String location;
  final double? latitude;
  final double? longitude;
  final String status;
  final double confidence;
  final String createdAt;
  final String? diseaseDescription;
  final List<String> diseaseTreatments;
  final String? imageUrl;
  final List<String> images;
  final String? expertNotes;
  final String? userNotes;
  final String? userName;
  final String? userAvatarUrl;
  final int? diseaseId;
  final int? pakarId;
  final String? pakarName;
  final String? pakarAvatarUrl;

  const DetectionItem({
    required this.id,
    required this.title,
    required this.location,
    this.latitude,
    this.longitude,
    required this.status,
    required this.confidence,
    required this.createdAt,
    this.diseaseDescription,
    this.diseaseTreatments = const [],
    this.imageUrl,
    this.images = const [],
    this.expertNotes,
    this.userNotes,
    this.userName,
    this.userAvatarUrl,
    this.diseaseId,
    this.pakarId,
    this.pakarName,
    this.pakarAvatarUrl,
  });

  factory DetectionItem.fromJson(Map<String, dynamic> json) {
    String diseaseName = 'Deteksi penyakit';
    String? description;
    List<String> treatments = [];

    if (json['disease'] is Map) {
      final d = json['disease'] as Map;
      diseaseName = d['name'] ?? diseaseName;
      description = d['description'];
      if (d['treatments'] is List) {
        treatments = (d['treatments'] as List).map((t) {
          if (t is Map && t['description'] != null) {
            String act = t['description'].toString();
            if (t['dosage'] != null) {
              act += ' (Dosis: ${t['dosage']} ${t['dosage_unit'] ?? ''})';
            }
            return act;
          }
          return t.toString();
        }).toList();
      }
    } else if (json['disease'] is String) {
      diseaseName = json['disease'];
    }

    // Terjemahkan nama penyakit ke bahasa Indonesia + Ilmiah
    final n = diseaseName.toLowerCase();
    if (n.contains('false smut')) {
      diseaseName = 'Hawar Bulir (False Smut)';
    } else if (n.contains('bacterial leaf blight')) {
      diseaseName = 'Hawar Daun Bakteri (Bacterial Leaf Blight)';
    } else if (n.contains('bacterial leaf streak')) {
      diseaseName = 'Garis Bakteri Daun (Bacterial Leaf Streak)';
    } else if (n.contains('bacterial panicle blight')) {
      diseaseName = 'Hawar Malai Bakteri (Bacterial Panicle Blight)';
    } else if (n.contains('bakanae')) {
      diseaseName = 'Penyakit Bakanae (Bakanae)';
    } else if (n.contains('neck blast')) {
      diseaseName = 'Busuk Leher (Neck Blast)';
    } else if (n.contains('blast')) {
      diseaseName = 'Penyakit Blast (Blast)';
    } else if (n.contains('narrow brown leaf spot')) {
      diseaseName = 'Bercak Coklat Sempit (Narrow Brown Leaf Spot)';
    } else if (n.contains('brown spot')) {
      diseaseName = 'Bercak Daun Coklat (Brown Spot)';
    } else if (n.contains('dead heart')) {
      diseaseName = 'Sundep (Dead Heart)';
    } else if (n.contains('downy mildew')) {
      diseaseName = 'Bulai (Downy Mildew)';
    } else if (n.contains('grassy stunt virus')) {
      diseaseName = 'Virus Kerdil Rumput (Grassy Stunt Virus)';
    } else if (n.contains('ragged stunt virus')) {
      diseaseName = 'Virus Kerdil Hampa (Ragged Stunt Virus)';
    } else if (n.contains('sheath blight')) {
      diseaseName = 'Hawar Upih Daun (Sheath Blight)';
    } else if (n.contains('sheath rot')) {
      diseaseName = 'Busuk Upih (Sheath Rot)';
    } else if (n.contains('stem rot')) {
      diseaseName = 'Busuk Batang (Stem Rot)';
    } else if (n.contains('leaf scald')) {
      diseaseName = 'Hawar Pelepah Daun (Leaf Scald)';
    } else if (n.contains('leaf smut')) {
      diseaseName = 'Jamur Daun (Leaf Smut)';
    } else if (n.contains('tungro')) {
      diseaseName = 'Penyakit Tungro (Tungro)';
    } else if (n.contains('hispa')) {
      diseaseName = 'Hama Hispa (Hispa)';
    } else if (n.contains('bukan padi')) {
      diseaseName = 'Bukan Padi / Tidak Dikenali';
    } else if (n.contains('healthy')) {
      diseaseName = 'Sehat (Healthy)';
    }

    String formattedDate = '${json['created_at'] ?? '-'}';
    try {
      if (json['created_at'] != null) {
        final d = DateTime.parse(json['created_at']).toLocal();
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Ags',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];
        formattedDate =
            '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year} - ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
      }
    } catch (_) {}

    String locationStr = '';
    if (json['city'] != null && json['province'] != null) {
      locationStr = '${json['city']}, ${json['province']}';
    } else if (json['city'] != null) {
      locationStr = json['city'];
    } else {
      locationStr = '${json['location'] ?? ''}';
    }

    if (locationStr.isEmpty || locationStr == 'null') {
      if (json['notes'] != null) {
        final notes = json['notes'] as String;
        final locMatch = RegExp(r'Lokasi:\s*(.*)').firstMatch(notes);
        if (locMatch != null) {
          locationStr = locMatch.group(1)!;
        }
      }
    }
    if (locationStr.isEmpty || locationStr == 'null') {
      locationStr = 'Location not available';
    }

    if (json['notes'] != null) {
      final notes = json['notes'] as String;
      final titleMatch = RegExp(r'Judul:\s*(.*)').firstMatch(notes);
      if (titleMatch != null && titleMatch.group(1)!.trim().isNotEmpty) {
        if (json['status'] != 'verified') {
          diseaseName = titleMatch.group(1)!.trim();
        }
      }
    }

    String? imgUrl;
    if (json['image_path'] != null) {
      imgUrl = '${ApiClient.currentBaseUrl}/storage/${json['image_path']}';
    }

    List<String> imageList = [];
    if (json['images'] is List) {
      imageList = (json['images'] as List)
          .map((i) => '${ApiClient.currentBaseUrl}/storage/$i')
          .toList();
    } else if (imgUrl != null) {
      imageList = [imgUrl];
    }

    double confidenceVal = 0.0;
    if (json['confidence'] != null) {
      if (json['confidence'] is num) {
        confidenceVal = (json['confidence'] as num).toDouble();
      } else if (json['confidence'] is String) {
        confidenceVal = double.tryParse(json['confidence']) ?? 0.0;
      }
    }

    String? uName;
    String? uAvatar;
    if (json['user'] is Map) {
      final u = json['user'] as Map;
      uName = u['name'];
      if (u['avatar_url'] != null) {
        uAvatar = u['avatar_url'];
      }
    }

    String? pName;
    String? pAvatar;
    if (json['pakar'] is Map) {
      final p = json['pakar'] as Map;
      pName = p['name'];
      if (p['avatar_url'] != null) {
        pAvatar = p['avatar_url'];
      }
    }

    // Ekstrak catatan asli pengguna vs catatan tambahan lokasi
    String? rawUserNotes = json['notes'];
    if (rawUserNotes != null) {
      final lines = rawUserNotes.split('\n');
      final filteredLines = lines
          .where((l) => !l.startsWith('Judul:') && !l.startsWith('Lokasi:'))
          .toList();
      rawUserNotes = filteredLines.join('\n').trim();
      if (rawUserNotes.isEmpty) rawUserNotes = null;
    }

    return DetectionItem(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      title: diseaseName,
      location: locationStr,
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      status: '${json['status'] ?? 'pending'}',
      confidence: confidenceVal,
      createdAt: formattedDate,
      diseaseDescription: description,
      diseaseTreatments: treatments,
      imageUrl: imgUrl,
      images: imageList,
      expertNotes: json['expert_notes'] as String?,
      userNotes: rawUserNotes,
      userName: uName,
      userAvatarUrl: uAvatar,
      diseaseId: json['disease_id'] is int
          ? json['disease_id']
          : int.tryParse(json['disease_id']?.toString() ?? ''),
      pakarId: json['pakar_id'] is int
          ? json['pakar_id']
          : int.tryParse(json['pakar_id']?.toString() ?? ''),
      pakarName: pName,
      pakarAvatarUrl: pAvatar,
    );
  }
}

class _ClimateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _ClimateHeaderDelegate({required this.child});

  @override
  double get minExtent => 90.0;
  @override
  double get maxExtent => 90.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_ClimateHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class ClimateHeader extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(compact ? 74 : 90);

  const ClimateHeader({
    super.key,
    required this.title,
    this.leading,
    this.compact = false,
    this.userPhoto,
    this.onEditProfile,
    this.onTapNotification,
    this.api,
    this.token,
  });

  final String title;
  final Widget? leading;
  final bool compact;
  final String? userPhoto;
  final VoidCallback? onEditProfile;
  final VoidCallback? onTapNotification;
  final ApiClient? api;
  final String? token;

  @override
  State<ClimateHeader> createState() => _ClimateHeaderState();
}

class _ClimateHeaderState extends State<ClimateHeader> {
  int _unreadCount = 0;
  AppNotification? _latestNotification;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (widget.api == null || widget.token == null) return;
    try {
      final data = await widget.api!.fetchNotifications(widget.token!);
      if (mounted) {
        setState(() {
          final List<AppNotification> notifs = data['notifications'] ?? [];
          _unreadCount = data['unread_count'] ?? 0;
          if (notifs.isNotEmpty) {
            _latestNotification = notifs.first;
          }
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: widget.compact ? 74 : 90,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              widget.leading ??
                  IconButton(
                    icon: Icon(Icons.menu, color: context.colors.green),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.green,
                    fontSize: widget.compact ? 24 : 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Builder(
                builder: (ctx) => Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      tooltip: context.t('notifications'),
                      onPressed: () {
                        widget.onTapNotification?.call();
                        Future.delayed(
                          const Duration(seconds: 1),
                          _fetchNotifications,
                        );
                      },
                      icon: Icon(
                        Icons.notifications_none,
                        color: context.colors.green,
                      ),
                    ),
                    if (_unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$_unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit_profile') {
                    widget.onEditProfile?.call();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit_profile',
                    child: Text('Edit Profil'),
                  ),
                ],
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: context.colors.greenSoft,
                  backgroundImage: widget.userPhoto != null
                      ? NetworkImage(
                          '${ApiClient.currentBaseUrl}${widget.userPhoto}',
                        )
                      : null,
                  child: widget.userPhoto == null
                      ? Icon(Icons.person, color: context.colors.green)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherHealthBanner extends StatefulWidget {
  const WeatherHealthBanner({super.key});

  @override
  State<WeatherHealthBanner> createState() => _WeatherHealthBannerState();
}

class _WeatherHealthBannerState extends State<WeatherHealthBanner> {
  String _temp = '--°C';
  String _desc = 'Memuat...';
  String _weatherMain = 'Clear';
  String _locationName = 'Mencari lokasi...';
  String _userName = 'Petani';
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _loadUserName();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
        if (DateTime.now().minute % 15 == 0) {
          _fetchWeather();
        }
      }
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final fullName = prefs.getString('user_name') ?? 'Petani';
      _userName = fullName.split(' ')[0]; // Ambil nama depan
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    const String apiKey = 'ea0dd041a3d990b79c4c86e8d12f221c';
    double lat = -6.2088; // Default Jakarta
    double lon = 106.8456;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 15),
          );
          if (position.isMocked) {
            // Kita belum punya akses _token mudah di UserDashboardPage jika di build state, tapi biarkan string kosong
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sistem mendeteksi penggunaan Fake GPS. Matikan untuk akurasi data.', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.orange,
                ),
              );
            }
            return;
          }
          lat = position.latitude;
          lon = position.longitude;
        }
      }
    } catch (e) {
      // Abaikan jika gagal mengambil lokasi, akan coba ambil lokasi terakhir (fallback Jakarta jika gagal)
      try {
        Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          lat = lastPosition.latitude;
          lon = lastPosition.longitude;
        }
      } catch (_) {}
    }

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=id',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tempStr = (data['main']['temp'] as num).round().toString();
        final descStr = data['weather'][0]['description'].toString();
        final mainStr = data['weather'][0]['main'].toString();
        final locName = data['name']?.toString() ?? context.t('location_unknown');

        setState(() {
          _temp = '$tempStr°C';
          _desc = descStr[0].toUpperCase() + descStr.substring(1);
          _weatherMain = mainStr;
          _locationName = locName.isEmpty ? context.t('location_unknown') : locName;
        });
      } else {
        // Fallback jika API Key belum valid
        setState(() {
          _temp = '28°C';
          _desc = 'Cerah (Perlu API Key)';
          _weatherMain = 'Clear';
          _locationName = 'Jakarta (Default)';
        });
      }
    } catch (e) {
      setState(() {
        _temp = '28°C';
        _desc = 'Cerah (Offline)';
        _weatherMain = 'Clear';
        _locationName = 'Offline';
      });
    }
  }

  String _getDynamicBackground() {
    final hour = DateTime.now().hour;
    final isNight = hour >= 18 || hour < 5;

    if (_weatherMain == 'Rain' ||
        _weatherMain == 'Thunderstorm' ||
        _weatherMain == 'Drizzle') {
      return isNight ? 'assets/bg_night_rain.png' : 'assets/bg_day_rain.png';
    }

    if (hour >= 5 && hour < 10) return 'assets/bg_morning.png';
    if (hour >= 10 && hour < 15) return 'assets/bg_day.png';
    if (hour >= 15 && hour < 18) return 'assets/bg_afternoon.png';
    return 'assets/bg_night.png';
  }

  IconData _getWeatherIcon() {
    final hour = DateTime.now().hour;
    final isNight = hour >= 18 || hour < 5;

    if (_weatherMain == 'Rain' ||
        _weatherMain == 'Thunderstorm' ||
        _weatherMain == 'Drizzle')
      return Icons.water_drop;
    if (_weatherMain == 'Clouds') return Icons.cloud;
    return isNight ? Icons.nights_stay : Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final isNight = hour >= 18 || hour < 5;
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(_getDynamicBackground()),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? context.colors.mint.withOpacity(0.1)
                        : Colors.black.withOpacity(0.3),
                    border: Theme.of(context).brightness == Brightness.dark
                        ? Border(
                            top: BorderSide(
                              color: context.colors.mint.withOpacity(0.3),
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getWeatherIcon(),
                            color: Colors.orangeAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.t('weather'),
                                  style: TextStyle(
                                    color: context.colors.surface.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '$_temp $_desc',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.colors.surface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hour >= 4 && hour < 10
                      ? context.t('morning')
                      : hour >= 10 && hour < 15
                      ? context.t('afternoon')
                      : hour >= 15 && hour < 18
                      ? context.t('evening')
                      : context.t('night'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$_userName!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 1, height: 24, color: Colors.white54),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _locationName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatefulWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.numericValue,
    this.valuePrefix = '',
    this.valueSuffix = '',
    required this.color,
    this.sparklineData,
    this.barData,
    this.percentageGauge,
    this.trendText,
    this.watermarkIcon,
    this.isLargeGauge = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final num? numericValue;
  final String valuePrefix;
  final String valueSuffix;
  final Color color;
  final List<double>? sparklineData;
  final List<double>? barData;
  final double? percentageGauge;
  final String? trendText;
  final IconData? watermarkIcon;
  final bool isLargeGauge;
  final VoidCallback? onTap;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.icon,
                                color: widget.color,
                                size: 20,
                              ),
                            ),
                            if (widget.percentageGauge != null &&
                                !widget.isLargeGauge)
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: widget.percentageGauge,
                                      strokeWidth: 4.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        widget.color,
                                      ),
                                      backgroundColor: Colors.white.withOpacity(
                                        0.1,
                                      ),
                                    ),
                                    Text(
                                      '${(widget.percentageGauge! * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (widget.sparklineData != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: SparklinePainter(
                                  widget.sparklineData!,
                                  widget.color,
                                ),
                              ),
                            ),
                          )
                        else if (widget.barData != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MiniBarChart(
                              values: widget.barData!,
                              color: widget.color,
                            ),
                          )
                        else
                          const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 0.5,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  widget.numericValue != null
                                      ? TweenAnimationBuilder<double>(
                                          tween: Tween<double>(
                                            begin: 0,
                                            end: widget.numericValue!
                                                .toDouble(),
                                          ),
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOutQuart,
                                          builder: (context, val, child) {
                                            return Text(
                                              '${widget.valuePrefix}${val.toInt()}${widget.valueSuffix}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            );
                                          },
                                        )
                                      : Text(
                                          widget.value ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                  if (widget.trendText != null) ...[
                                    Text(
                                      widget.trendText!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: widget.trendText!.contains('↑')
                                            ? Colors.lightGreenAccent
                                            : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.percentageGauge != null && widget.isLargeGauge)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: widget.percentageGauge!,
                    ),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutQuart,
                    builder: (context, val, child) {
                      return SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: val,
                                strokeWidth: 12.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.color.withOpacity(0.8),
                                ),
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            Text(
                              '${(val * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black26, blurRadius: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (!widget.isLargeGauge)
                Positioned(
                  bottom: -20,
                  right: -20,
                  child: IgnorePointer(
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Icon(
                        widget.watermarkIcon ?? widget.icon,
                        size: 140,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniBarChart extends StatelessWidget {
  final List<double> values;
  final Color color;

  const MiniBarChart({super.key, required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: values.map((val) {
          return Container(
            width: 4,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: val.clamp(0.15, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double stepX = size.width / (data.length - 1);
    final double max = data.reduce((a, b) => a > b ? a : b);
    final double min = data.reduce((a, b) => a < b ? a : b);
    final double range = max - min == 0 ? 1.0 : max - min;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - min) / range) * (size.height - 4) - 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShimmerActivityCard extends StatelessWidget {
  const ShimmerActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: panelDecoration(context),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 16, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 80, height: 12, color: Colors.white),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 40, height: 16, color: Colors.white),
                const SizedBox(height: 6),
                Container(width: 60, height: 12, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key, required this.item});

  final DetectionItem item;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (item.status.toLowerCase()) {
      'verified' || 'confirmed' => context.colors.mint,
      'draft' || 'pending' => const Color(0xFFE5ECE6),
      'diprediksi_ai' => const Color(0xFFE3F2FD),
      'rejected' => const Color(0xFFFFEBEE),
      _ => Colors.grey[200]!,
    };

    final statusTextColor = switch (item.status.toLowerCase()) {
      'verified' || 'confirmed' => context.colors.green,
      'draft' || 'pending' => const Color(0xFF4A5568),
      'diprediksi_ai' => const Color(0xFF1976D2),
      'rejected' => const Color(0xFFD32F2F),
      _ => Colors.grey[800]!,
    };

    final confValue = item.confidence > 1.0
        ? item.confidence
        : (item.confidence * 100);
    final confString = confValue == confValue.truncateToDouble()
        ? confValue.toStringAsFixed(0)
        : confValue.toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: panelDecoration(context),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? context.colors.red.withOpacity(0.15)
                  : const Color(0xFFFFD8D6),
              borderRadius: BorderRadius.circular(12),
              image: item.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!, headers: const {'ngrok-skip-browser-warning': 'true'}),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.imageUrl == null
                ? Icon(Icons.warning_amber_rounded, color: context.colors.red)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: context.colors.dark),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.status.toLowerCase() == 'diprediksi_ai'
                            ? context.t('diprediksi_ai_caps')
                            : item.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.createdAt,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (item.status.toLowerCase() == 'verified' || item.status.toLowerCase() == 'confirmed')
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.verified,
                  color: context.colors.green,
                  size: 20,
                ),
                Text(
                  'Dipastikan Pakar',
                  style: TextStyle(
                    color: context.colors.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ],
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.t('accuracy_label', listen: false),
                  style: TextStyle(color: context.colors.muted, fontSize: 10),
                ),
                Text(
                  '$confString%',
                  style: TextStyle(
                    color: context.colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ManagementTile extends StatelessWidget {
  const ManagementTile({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: panelDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? context.colors.greenSoft
                : context.colors.mint,
            child: Icon(icon, color: context.colors.green),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.colors.dark,
            ),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(
              'Kelola',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF064E3B)
                    : context.colors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: context.colors.mint,
            side: BorderSide.none,
          ),
        ],
      ),
    );
  }
}

class DetectionCard extends StatelessWidget {
  const DetectionCard({
    super.key,
    required this.item,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onToggleSelect,
    this.onDelete,
    this.api,
    this.token,
    this.isPakar = false,
  });

  final DetectionItem item;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onToggleSelect;
  final VoidCallback? onDelete;
  final ApiClient? api;
  final String? token;
  final bool isPakar;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (item.status.toLowerCase()) {
      'verified' || 'confirmed' => context.colors.mint.withOpacity(0.2),
      'draft' ||
      'pending' => const Color(0xFFFFF3E0), // Soft orange for pending
      'diprediksi_ai' => const Color(0xFFE3F2FD),
      'rejected' => const Color(0xFFFFEBEE),
      _ => Colors.grey[100]!,
    };

    final statusTextColor = switch (item.status.toLowerCase()) {
      'verified' || 'confirmed' => context.colors.green,
      'draft' || 'pending' => const Color(0xFFE65100), // Dark orange text
      'diprediksi_ai' => const Color(0xFF1976D2),
      'rejected' => const Color(0xFFD32F2F),
      _ => Colors.grey[700]!,
    };

    final displayStatus = switch (item.status.toLowerCase()) {
      'diprediksi_ai' => context.t('diprediksi_ai_caps'),
      'pending' => context.t('pending_caps'),
      'verified' => context.t('verified_caps'),
      _ => item.status.toUpperCase(),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelectionMode && isSelected
            ? context.colors.mint.withOpacity(0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelectionMode && isSelected
              ? context.colors.green
              : Colors.grey.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          if (!isSelectionMode || !isSelected)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSelectionMode
              ? onToggleSelect
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetectionDetailPage(
                        item: item,
                        api: api,
                        token: token,
                        isPakar: isPakar,
                      ),
                    ),
                  );
                },
          onLongPress: onToggleSelect,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? context.colors.green
                          : Colors.grey[300],
                    ),
                  ),
                // THUMBNAIL
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? Image.network(item.imageUrl!, headers: const {'ngrok-skip-browser-warning': 'true'},
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, __) =>
                              Icon(Icons.eco, color: Colors.grey[300]),
                        )
                      : Icon(Icons.eco, size: 32, color: Colors.grey[300]),
                ),
                const SizedBox(width: 12),
                // INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.createdAt.split(' - ').first,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // STATUS BADGE & MENU
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!isSelectionMode)
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormPanel extends StatelessWidget {
  const FormPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.delay = 0,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: context.colors.green),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ...children,
          ],
        ),
      ),
    );
  }
}

class ClimateTextField extends StatelessWidget {
  const ClimateTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return FieldLabel(
      label: label,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon == null ? null : Icon(icon),
          suffixIcon: suffixIcon,
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: context.colors.dark,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class WarningPanel extends StatelessWidget {
  const WarningPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF3B2710)
            : const Color(0xFFFFF2E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF7C5A2E)
              : const Color(0xFFFFC7A0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFFB86C)
                : const Color(0xFF9A4F00),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gunakan akun dengan token valid. Endpoint hapus data membutuhkan Authorization: Bearer token.',
              style: TextStyle(color: Color(0xFF693800), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: panelDecoration(context),
      child: Column(children: children),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: context.colors.greenSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: context.colors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, overflow: TextOverflow.ellipsis),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class DrawerDestination extends StatelessWidget {
  const DrawerDestination({
    super.key,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: const StadiumBorder(),
        selected: selected,
        selectedTileColor: context.colors.greenSoft,
        selectedColor: context.colors.green,
        iconColor: context.colors.muted,
        textColor: context.colors.dark,
        leading: Icon(icon),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.colors.dark,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class IconLine extends StatelessWidget {
  const IconLine({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: context.colors.dark),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: TextStyle(color: context.colors.dark)),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.color, this.shadows});

  final String text;
  final Color? color;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: color ?? Colors.black,
        shadows: shadows,
      ),
    );
  }
}

BoxDecoration panelDecoration(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: context.colors.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: isDark
          ? context.colors.mint.withOpacity(0.3)
          : context.colors.border,
    ),
    boxShadow: [
      BoxShadow(
        color: isDark
            ? context.colors.mint.withOpacity(0.08)
            : const Color(0x12000000),
        blurRadius: isDark ? 12 : 8,
        spreadRadius: isDark ? 2 : 0,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

class AppTheme extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  AppThemeData get colors => AppThemeData(isDark: _themeMode == ThemeMode.dark);

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class AppNotifications extends ChangeNotifier {
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  AppNotifications() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> toggle(BuildContext context) async {
    _isEnabled = !_isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _isEnabled);
    notifyListeners();

    final token = prefs.getString('auth_token');
    if (token != null) {
      final api = context.read<ApiClient>();
      if (_isEnabled) {
        final fcmToken = await NotificationService.getToken();
        if (fcmToken != null) {
          api.updateFcmToken(token, fcmToken).catchError((_) {});
        }
      } else {
        await NotificationService.deleteToken();
        api.updateFcmToken(token, "").catchError((_) {});
      }
    }
  }
}

class AppThemeData {
  final bool isDark;
  AppThemeData({required this.isDark});

  Color get green => isDark ? const Color(0xFF10B981) : const Color(0xFF007A4D);
  Color get teal => isDark ? const Color(0xFF14B8A6) : const Color(0xFF009B72);
  Color get mint => isDark ? const Color(0xFF34D399) : const Color(0xFF62EEB2);
  Color get greenSoft =>
      isDark ? const Color(0xFF064E3B) : const Color(0xFFE4F7EF);
  Color get background =>
      isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F7F9);
  Color get surface =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  Color get field => isDark ? const Color(0xFF0B1120) : const Color(0xFFF1F8F4);
  Color get border =>
      isDark ? const Color(0xFF334155) : const Color(0xFFB9CBBF);
  Color get dark => isDark ? const Color(0xFFF1F5F9) : const Color(0xFF22342B);
  Color get muted => isDark ? const Color(0xFF94A3B8) : const Color(0xFF66736B);
  Color get red => isDark ? const Color(0xFFEF4444) : const Color(0xFFC20000);
  Color get blue => isDark ? const Color(0xFF3B82F6) : const Color(0xFF155EEF);
}

extension AppColorsExt on BuildContext {
  AppThemeData get colors => watch<AppTheme>().colors;
  AppThemeData get readColors => read<AppTheme>().colors;
}

class CustomScannerPage extends StatefulWidget {
  const CustomScannerPage({super.key});

  @override
  State<CustomScannerPage> createState() => _CustomScannerPageState();
}

class _CustomScannerPageState extends State<CustomScannerPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInit();
  }

  Future<void> _requestPermissionAndInit() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _isPermissionGranted = true);
      _initCamera();
    } else {
      setState(() => _isPermissionGranted = false);
    }
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _cameraController = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to initialize camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted) {
      return Scaffold(
        backgroundColor: context.colors.dark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, size: 64, color: context.colors.muted),
              const SizedBox(height: 16),
              const Text(
                'Izin kamera diperlukan untuk memindai.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => openAppSettings(),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.green,
                ),
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Scaffold(
        backgroundColor: context.colors.dark,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.mint),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(child: CameraPreview(_cameraController!)),
          // Header / Instruction
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Arahkan kamera ke daun padi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.surface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // balance back button
                  ],
                ),
              ],
            ),
          ),
          // Action Button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  if (!_cameraController!.value.isInitialized) return;
                  if (_cameraController!.value.isTakingPicture) return;

                  try {
                    final XFile picture = await _cameraController!
                        .takePicture();
                    if (mounted) {
                      Navigator.pop(context, picture.path);
                    }
                  } catch (e) {
                    AppLogger.error('Failed to capture image: $e');
                  }
                },
                child: Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: context.colors.surface.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFF1E3224).withOpacity(0.85); // Dark greenish tint
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final scanAreaSize = size.width * 0.7;
    final scanAreaRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Draw darkened background with transparent cutout
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanAreaRect, const Radius.circular(24)),
      )
      ..close();

    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(finalPath, backgroundPaint);

    // Draw viewfinder corners
    final cornerLength = 32.0;
    final r = scanAreaRect;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(r.left, r.top + cornerLength)
        ..quadraticBezierTo(r.left, r.top, r.left + cornerLength, r.top),
      borderPaint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(r.right - cornerLength, r.top)
        ..quadraticBezierTo(r.right, r.top, r.right, r.top + cornerLength),
      borderPaint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(r.left, r.bottom - cornerLength)
        ..quadraticBezierTo(r.left, r.bottom, r.left + cornerLength, r.bottom),
      borderPaint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(r.right - cornerLength, r.bottom)
        ..quadraticBezierTo(
          r.right,
          r.bottom,
          r.right,
          r.bottom - cornerLength,
        ),
      borderPaint,
    );

    // Draw scanning line
    final linePaint = Paint()
      ..color = Color(0xFF10B981)
      ..strokeWidth = 2.0;
    canvas.drawLine(
      Offset(r.left, r.top + (r.height * 0.4)),
      Offset(r.right, r.top + (r.height * 0.4)),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// DATA MODELS
// =======================================================================================
// SCAN PAGE (ALUR BARU)
// ============================================================================
class ScanPage extends StatefulWidget {
  final MlService mlService;
  final List<DiseaseOption> diseases;

  const ScanPage({super.key, required this.mlService, required this.diseases});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final List<String> _images = [];
  bool _isScanning = false;

  Future<void> _pickAndCropImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF22C55E)),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _processImageSource(isCamera: true);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF22C55E),
                ),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _processImageSource(isCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processImageSource({required bool isCamera}) async {
    String? photoPath;

    if (isCamera) {
      photoPath = await Navigator.push<String?>(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => const CustomScannerPage(),
        ),
      );
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        photoPath = pickedFile.path;
      }
    }

    if (photoPath == null || !mounted) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: photoPath,
      maxWidth: 800,
      maxHeight: 800,
      compressQuality: 70,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Fokuskan pada Penyakit',
          toolbarColor: const Color(0xFF22C55E),
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Fokuskan pada Penyakit',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null && mounted) {
      setState(() {
        if (_images.length < 5) _images.add(croppedFile.path);
      });
    }
  }

  Future<void> _runScan() async {
    if (_images.isEmpty) return;
    setState(() => _isScanning = true);

    try {
      // Tampilkan loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Text('Menganalisis gambar dengan AI...'),
            ],
          ),
          duration: Duration(seconds: 10),
        ),
      );

      // Scan SEMUA gambar sekaligus di dalam 1 background isolate
      Map<String, int> votes = {};
      Map<String, double> maxConfidences = {};
      final results = await widget.mlService.detectDiseases(_images);
      bool hasInvalidImage = false;
      double sumConfidence = 0.0;
      int validResultsCount = 0;

      for (final result in results) {
        if (result != null) {
          final label = (result['label'] as String).replaceAll(RegExp(r'\d+\s*'), '').trim();
          final conf = result['confidence'] as double;
          
          if (label.toLowerCase() == 'bukan padi') {
            hasInvalidImage = true;
          } else if (result.containsKey('top3')) {
            final top3List = List<Map<String, dynamic>>.from(result['top3']);
            for (var t in top3List) {
              if (t['label'].toString().toLowerCase() == 'bukan padi' && (t['confidence'] as double) > 0.25) {
                hasInvalidImage = true;
                break;
              }
            }
          }
          
          sumConfidence += conf;
          validResultsCount++;
          
          votes[label] = (votes[label] ?? 0) + 1;
          if (conf > (maxConfidences[label] ?? 0.0)) {
            maxConfidences[label] = conf;
          }
        }
      }

      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (votes.isEmpty || validResultsCount == 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maaf, sistem gagal mendeteksi gambar tersebut.'),
            ),
          );
        }
        setState(() => _isScanning = false);
        return;
      }

      // Ambil penyakit dengan tingkat akurasi (confidence) tertinggi
      String detectedDiseaseStr = maxConfidences.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      double detectedConfidence = maxConfidences[detectedDiseaseStr] ?? 0.0;
      double avgConfidence = sumConfidence / validResultsCount;

      // Validasi Gambar: Tolak jika ada AI mendeteksi 'Bukan Padi' ATAU akurasinya di bawah standar
      if (hasInvalidImage || 
          detectedDiseaseStr.toLowerCase() == 'bukan padi' ||
          detectedConfidence < 0.50 || 
          avgConfidence < 0.40) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(context.t('invalid_image', listen: false)),
                ],
              ),
              content: const Text(
                'Sistem mendeteksi objek dalam foto ini tidak mirip dengan penyakit daun padi (atau akurasinya terlalu rendah). Harap ambil ulang foto dan pastikan daun padi terlihat jelas.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(
                      color: Color(0xFF006948),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        setState(() => _isScanning = false);
        return;
      }

      // Extract top3 dari result pertama yang valid
      List<Map<String, dynamic>> top3 = [];
      for (final result in results) {
        if (result != null && result.containsKey('top3')) {
          top3 = List<Map<String, dynamic>>.from(result['top3']);
          break;
        }
      }

      DiseaseOption? matchedDisease;
      try {
        matchedDisease = widget.diseases.firstWhere(
          (d) => d.name.toLowerCase() == detectedDiseaseStr.toLowerCase(),
        );
      } catch (_) {
        matchedDisease = DiseaseOption(
          id: 0,
          name: detectedDiseaseStr,
          description: context.t('generic_disease_description', listen: false),
        );
      }

      if (!mounted) return;

      // Tampilkan modal hasil
      final result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => DetectionResultModal(
          disease: matchedDisease!,
          images: _images,
          confidence: detectedConfidence,
          top3: top3,
          onSave: () {
            Navigator.pop(ctx, {
              'action': 'save',
              'images': _images,
              'disease': matchedDisease!.name,
              'confidence': detectedConfidence,
            });
          },
          onReport: () {
            Navigator.pop(ctx, {
              'action': 'report',
              'images': _images,
              'disease': matchedDisease!.name,
              'confidence': detectedConfidence,
            });
          },
        ),
      );

      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.t('failed_scan', listen: false))));
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('scan_plant')),
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _images.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 80,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada foto yang ditambahkan',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Anda bisa menambahkan hingga 5 foto',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(
                                  _images[index],
                                ), // ERROR DART, pakai dart:io File
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() => _images.removeAt(index));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_images.length < 5)
                    OutlinedButton.icon(
                      onPressed: _isScanning ? null : _pickAndCropImage,
                      icon: const Icon(Icons.add_a_photo),
                      label: Text(context.t('add_photo')),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor: const Color(0xFF22C55E),
                        side: const BorderSide(color: Color(0xFF22C55E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  if (_images.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _isScanning ? null : _runScan,
                      icon: _isScanning
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.analytics),
                      label: Text(
                        _isScanning
                            ? 'Menganalisis...'
                            : 'Scan Penyakit (\ foto)',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFF22C55E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MICRO-INTERACTION WIDGETS
// ============================================================================

class BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const BouncingButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

class EmptyActivityWidget extends StatefulWidget {
  final VoidCallback onStartDetection;

  const EmptyActivityWidget({super.key, required this.onStartDetection});

  @override
  State<EmptyActivityWidget> createState() => _EmptyActivityWidgetState();
}

class _EmptyActivityWidgetState extends State<EmptyActivityWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.greenAccent.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.greenAccent.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    size: 48,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Belum Ada Aktivitas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Riwayat deteksi Anda masih kosong. Mulai lindungi tanaman Anda sekarang juga!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          BouncingButton(
            onPressed: widget.onStartDetection,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt_outlined, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Mulai Deteksi Pertama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const SlideIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<SlideIndexedStack> createState() => _SlideIndexedStackState();
}

class _SlideIndexedStackState extends State<SlideIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(SlideIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller.reset();
      _controller.forward();
      setState(() {
        _currentIndex = widget.index;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          ),
      child: FadeTransition(
        opacity: _controller,
        child: IndexedStack(index: _currentIndex, children: widget.children),
      ),
    );
  }
}

class FadeInUp extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeInUp({super.key, required this.child, this.delay = 0});

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class PulsingCameraBox extends StatefulWidget {
  final VoidCallback onTap;

  const PulsingCameraBox({super.key, required this.onTap});

  @override
  State<PulsingCameraBox> createState() => _PulsingCameraBoxState();
}

class _PulsingCameraBoxState extends State<PulsingCameraBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 0.1,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(
                _glowAnimation.value * 0.15,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withOpacity(_glowAnimation.value + 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(
                    _glowAnimation.value * 0.3,
                  ),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 48,
                  color: Colors.green.shade600,
                ),
                const SizedBox(height: 12),
                Text(
                  context.t('tap_to_select_photo'),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
