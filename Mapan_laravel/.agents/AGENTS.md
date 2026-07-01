### Notifikasi Heads-Up Android FCM
Saat mengimplementasikan Firebase Cloud Messaging (FCM) untuk Android, jika pengguna menginginkan notifikasi muncul sebagai banner (heads-up) seperti WhatsApp:
1. **Frontend**: Selalu buat channel dengan kepentingan tinggi di kode Flutter (`Importance.max`) dan daftarkan ke sistem.
2. **Frontend Manifest**: Selalu tambahkan meta-data untuk channel default di `AndroidManifest.xml`:
   `<meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="ID_CHANNEL_ANDA" />`
3. **Backend Payload**: Pastikan backend mengirim payload HTTP v1 yang benar agar Android membangunkan layar dan memunculkan UI heads-up:
   - `android.priority` wajib diatur menjadi `"HIGH"`.
   - `android.notification.channel_id` wajib disamakan dengan ID channel kepentingan tinggi dari frontend.
   - `android.notification.notification_priority` sebaiknya diatur menjadi `"PRIORITY_MAX"` atau `"PRIORITY_HIGH"`.
