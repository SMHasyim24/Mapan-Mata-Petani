import 'package:flutter/material.dart';
import 'package:mapan/main.dart';
import 'package:mapan/expert_application_review_page.dart';

class ExpertApplicationListPage extends StatefulWidget {
  const ExpertApplicationListPage({super.key, required this.api, required this.token});
  final ApiClient api;
  final String? token;

  @override
  State<ExpertApplicationListPage> createState() => _ExpertApplicationListPageState();
}

class _ExpertApplicationListPageState extends State<ExpertApplicationListPage> {
  bool _isLoading = true;
  List<ExpertApplication> _applications = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = widget.token ?? '';
    if (token.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final applications = await widget.api.fetchExpertApplications(token);
      if (mounted) {
        setState(() {
          _applications = applications;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data pengajuan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Daftar Pengajuan Pakar',
          style: TextStyle(
            color: Color(0xFF006948),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? const Center(child: Text('Tidak ada pengajuan pakar pending.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _applications.length,
                  itemBuilder: (context, index) {
                    final app = _applications[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: const Icon(Icons.person, color: Colors.teal),
                        ),
                        title: Text(
                          app.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(app.userEmail),
                            const SizedBox(height: 4),
                            Text(
                              'Status: ${app.status.toUpperCase()}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ExpertApplicationReviewPage(
                                api: widget.api,
                                token: widget.token ?? '',
                                applicationId: app.id.toString(),
                              ),
                            ),
                          ).then((_) {
                            // Refresh list after returning
                            _loadData();
                          });
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
