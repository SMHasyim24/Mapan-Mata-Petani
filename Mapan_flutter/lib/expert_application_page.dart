import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class ExpertApplicationPage extends StatefulWidget {
  final ApiClient api;
  final String token;

  const ExpertApplicationPage({super.key, required this.api, required this.token});

  @override
  State<ExpertApplicationPage> createState() => _ExpertApplicationPageState();
}

class _ExpertApplicationPageState extends State<ExpertApplicationPage> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _application;
  File? _selectedDocument;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchApplication();
  }

  Future<void> _fetchApplication() async {
    try {
      final json = await widget.api.request(
        'GET',
        '/private/api/v1/user/expert-application',
        token: widget.token,
      );
      final prefs = await SharedPreferences.getInstance();
      final pendingRole = prefs.getString('pending_role');

      if (mounted) {
        setState(() {
          _application = json['data'];
          if (_application == null && pendingRole == 'pakar') {
            _application = {'status': 'pending'};
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_load_expert_app_status')} $e')),
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
    if (_selectedDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('upload_certification_doc'))),
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
        Uri.parse('${widget.api.baseUrl}/private/api/v1/user/expert-application'),
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
              title: Text(context.t('success')),
              content: Text(context.t('expert_app_submitted')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _fetchApplication(); // Refresh
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        String errorMessage = json['message'] ?? context.t('failed_submit_application');
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
            title: Text(context.t('error')),
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
        appBar: AppBar(title: Text(context.t('expert_application'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    Widget body;

    if (_application != null && _application!['status'] == 'pending') {
      body = _buildStatusCard(
        context.t('under_review'),
        context.t('review_desc'),
        Colors.orange,
      );
    } else if (_application != null && _application!['status'] == 'approved') {
      body = _buildStatusCard(
        context.t('approved'),
        context.t('approved_desc'),
        Colors.green,
      );
    } else {
      body = _buildForm();
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.t('expert_application'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_application != null && _application!['status'] == 'rejected')
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildStatusCard(
                  context.t('rejected'),
                  context.t('rejected_desc'),
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
            Text(message, style: TextStyle(color: color.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t('upload_desc'),
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: _selectedDocument != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedDocument!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_file, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(context.t('pick_doc_image'), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: context.t('additional_notes'),
            hintText: context.t('additional_notes_hint'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitApplication,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isSubmitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(context.t('submit_application')),
        ),
      ],
    );
  }
}
