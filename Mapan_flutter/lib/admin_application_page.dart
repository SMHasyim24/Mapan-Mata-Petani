import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'main.dart';

class AdminApplicationPage extends StatefulWidget {
  final ApiClient api;
  final String token;

  const AdminApplicationPage({super.key, required this.api, required this.token});

  @override
  State<AdminApplicationPage> createState() => _AdminApplicationPageState();
}

class _AdminApplicationPageState extends State<AdminApplicationPage> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _application;
  File? _selectedDocument;
  final _agencyNameController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchApplication();
  }

  @override
  void dispose() {
    _agencyNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchApplication() async {
    try {
      final json = await widget.api.request(
        'GET',
        '/private/api/v1/user/admin-application',
        token: widget.token,
      );

      if (mounted) {
        setState(() {
          _application = json['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat status pengajuan admin: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedDocument = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitApplication() async {
    if (_agencyNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama Instansi/Komunitas wajib diisi')),
      );
      return;
    }

    if (_selectedDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan unggah dokumen pendukung (Surat Tugas/SK/MOU)')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final bytes = await _selectedDocument!.readAsBytes();
      final ext = _selectedDocument!.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      final req = http.MultipartRequest(
        'POST',
        Uri.parse('${widget.api.baseUrl}/private/api/v1/user/admin-application'),
      );
      req.headers['Authorization'] = 'Bearer ${widget.token}';
      req.headers['Accept'] = 'application/json';
      req.headers['X-App-Secret'] = 'MapanRahasia2026';
      req.headers['Idempotency-Key'] = widget.api.generateUuid();

      req.files.add(
        http.MultipartFile.fromBytes(
          'document',
          bytes,
          filename: 'document.$ext',
          contentType: http_parser.MediaType.parse(mimeType),
        ),
      );

      req.fields['agency_name'] = _agencyNameController.text.trim();

      if (_notesController.text.isNotEmpty) {
        req.fields['notes'] = _notesController.text;
      }

      final res = await req.send();
      final resBody = await res.stream.bytesToString();
      final json = jsonDecode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Sukses'),
              content: const Text('Pengajuan akun Admin berhasil dikirim! Silakan tunggu peninjauan oleh Super Admin.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _fetchApplication(); // Refresh UI
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        String errorMessage = json['message'] ?? 'Gagal mengirim pengajuan.';
        if (json['errors'] != null && json['errors'] is Map) {
          final errors = json['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage += '\n${firstError.first}';
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pengajuan Akun Admin')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    Widget body;

    if (_application != null && _application!['status'] == 'pending') {
      body = _buildStatusCard(
        'Sedang Ditinjau',
        'Pengajuan akun Admin Anda untuk instansi "${_application!['agency_name']}" sedang dalam proses peninjauan oleh Super Admin. Harap tunggu.',
        Colors.orange,
      );
    } else if (_application != null && _application!['status'] == 'approved') {
      body = _buildStatusCard(
        'Disetujui',
        'Selamat! Pengajuan Anda untuk instansi "${_application!['agency_name']}" telah disetujui. Peran Anda sekarang adalah Admin.',
        Colors.green,
      );
    } else {
      body = _buildForm();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan Akun Admin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_application != null && _application!['status'] == 'rejected')
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildStatusCard(
                  'Ditolak',
                  'Pengajuan Anda sebelumnya untuk instansi "${_application!['agency_name']}" telah ditolak. Silakan ajukan kembali dengan dokumen yang benar.',
                  Colors.red,
                ),
              ),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String message, MaterialColor color) {
    return Card(
      color: color.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color.shade800, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: color.shade700, height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Silakan isi nama instansi/komunitas Anda dan unggah dokumen pendukung resmi (seperti Surat Keputusan, MOU, atau Surat Tugas) sebagai bukti verifikasi.',
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _agencyNameController,
          decoration: InputDecoration(
            labelText: 'Nama Instansi / Komunitas',
            hintText: 'Misal: Dinas Pertanian Sleman',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: _selectedDocument != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedDocument!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey.shade600),
                      const SizedBox(height: 8),
                      const Text(
                        'Pilih Gambar Dokumen SK / Surat Tugas',
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Format: JPG, JPEG, PNG (Maks 5MB)',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Catatan Tambahan (Opsional)',
            hintText: 'Tulis keterangan tambahan mengenai pengajuan Anda...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitApplication,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C853), // Green primary
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          child: _isSubmitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Kirim Pengajuan Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
