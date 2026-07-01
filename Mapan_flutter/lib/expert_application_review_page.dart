import 'package:flutter/material.dart';
import 'package:mapan/main.dart'; // ApiClient, ExpertApplication, colors
import 'package:url_launcher/url_launcher.dart'; // Just in case, wait, pubspec doesn't have it. We'll use NetworkImage for CV if it's image, or just show text.

class ExpertApplicationReviewPage extends StatefulWidget {
  final ApiClient api;
  final String token;
  final String applicationId;

  const ExpertApplicationReviewPage({
    super.key,
    required this.api,
    required this.token,
    required this.applicationId,
  });

  @override
  State<ExpertApplicationReviewPage> createState() => _ExpertApplicationReviewPageState();
}

class _ExpertApplicationReviewPageState extends State<ExpertApplicationReviewPage> {
  ExpertApplication? _application;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadApplication();
  }

  Future<void> _loadApplication() async {
    setState(() => _isLoading = true);
    try {
      final app = await widget.api.fetchExpertApplication(widget.token, widget.applicationId);
      if (mounted) {
        setState(() {
          _application = app;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_load_expert_app_status')} $e')),
        );
      }
    }
  }

  Future<void> _processApplication(bool isApprove) async {
    setState(() => _isProcessing = true);
    try {
      if (isApprove) {
        await widget.api.approveExpertApplication(widget.token, widget.applicationId);
      } else {
        await widget.api.rejectExpertApplication(widget.token, widget.applicationId);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isApprove ? context.t('app_approved_success') : context.t('app_rejected_success'))),
        );
        await _loadApplication(); // Reload to show the new status
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_process')} $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2),
      appBar: AppBar(
        title: Text(context.t('expert_review_title')),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _application == null
              ? Center(child: Text(context.t('data_not_found')))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 20),
                      _buildReasonCard(),
                      const SizedBox(height: 20),
                      _buildCvCard(),
                      const SizedBox(height: 40),
                      if (_application!.status == 'pending') _buildActionButtons(),
                      if (_application!.status != 'pending')
                        Center(
                          child: Text(
                            '${context.t('app_already_status')} ${_application!.status == 'approved' ? context.t('approved') : context.t('rejected')}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: context.colors.green.withOpacity(0.2),
            backgroundImage: _application!.userAvatarUrl != null
                ? NetworkImage('${ApiClient.currentBaseUrl}${_application!.userAvatarUrl}', headers: const {'ngrok-skip-browser-warning': 'true'})
                : null,
            child: _application!.userAvatarUrl == null ? Icon(Icons.person, size: 30, color: context.colors.green) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _application!.userName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _application!.userEmail,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: context.colors.green),
              const SizedBox(width: 8),
              Text(context.t('application_reason'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _application!.reasons,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCvCard() {
    final cvPath = _application!.cvPath.toLowerCase();
    final isImage = cvPath.endsWith('.jpg') || cvPath.endsWith('.jpeg') || cvPath.endsWith('.png');
    String urlPath = _application!.cvPath;
    if (!urlPath.startsWith('/')) {
      urlPath = '/storage/$urlPath';
    }
    final fullUrl = '${ApiClient.currentBaseUrl}$urlPath';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_shared, color: context.colors.green),
              const SizedBox(width: 8),
              Text(context.t('cv_document'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                fullUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                headers: const {'ngrok-skip-browser-warning': 'true'},
                errorBuilder: (context, error, stackTrace) => const Text('Gagal memuat gambar CV/Sertifikat'),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.t('file_available'),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.t('open_web_download'))),
                      );
                    },
                    child: Text(context.t('open')),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing ? null : () => _processApplication(false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(context.t('reject_caps'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : () => _processApplication(true),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: context.colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isProcessing
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(context.t('approve_caps'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
