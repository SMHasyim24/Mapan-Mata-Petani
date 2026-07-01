import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart'; // To access User, ApiClient, FeedbackItem, colors, etc.

class FeedbacksPage extends StatefulWidget {
  final UserProfile user;
  final ApiClient api;
  final String token;

  const FeedbacksPage({
    super.key,
    required this.user,
    required this.api,
    required this.token,
  });

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  List<FeedbackItem> _feedbacks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    setState(() => _isLoading = true);
    final feedbacks = await widget.api.fetchFeedbacks(widget.token);
    if (mounted) {
      setState(() {
        _feedbacks = feedbacks;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSuperAdmin = widget.user.role == 'super_admin';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          isSuperAdmin ? context.t('app_feedback_center') : context.t('bug_report'),
          style: TextStyle(color: context.colors.surface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: context.colors.green,
        elevation: 0,
        iconTheme: IconThemeData(color: context.colors.surface),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feedbacks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: context.colors.muted),
                      const SizedBox(height: 16),
                      Text(
                        isSuperAdmin 
                          ? context.t('no_feedback_reports') 
                          : 'Anda belum mengirimkan laporan apapun.',
                        style: TextStyle(color: context.colors.muted, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _feedbacks.length,
                  itemBuilder: (context, index) {
                    final item = _feedbacks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FeedbackDetailPage(
                                item: item,
                                user: widget.user,
                                api: widget.api,
                                token: widget.token,
                              ),
                            ),
                          ).then((_) => _loadFeedbacks());
                        },
                        leading: CircleAvatar(
                          backgroundColor: item.status == 'open' ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                          child: Icon(
                            item.type == 'bug' ? Icons.bug_report : (item.type == 'feature' ? Icons.star : Icons.chat),
                            color: item.status == 'open' ? Colors.orange : Colors.green,
                          ),
                        ),
                        title: Text(
                          isSuperAdmin ? '${item.userName} - ${item.type.toUpperCase()}' : item.type.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          item.status == 'open' ? Icons.pending_actions : Icons.check_circle,
                          color: item.status == 'open' ? Colors.orange : Colors.green,
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: isSuperAdmin
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateFeedbackPage(api: widget.api, token: widget.token),
                  ),
                ).then((_) => _loadFeedbacks());
              },
              backgroundColor: context.colors.green,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(context.t('create_report'), style: const TextStyle(color: Colors.white)),
            ),
    );
  }
}

class CreateFeedbackPage extends StatefulWidget {
  final ApiClient api;
  final String token;

  const CreateFeedbackPage({super.key, required this.api, required this.token});

  @override
  State<CreateFeedbackPage> createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends State<CreateFeedbackPage> {
  final _contentController = TextEditingController();
  String _selectedType = 'bug';
  File? _image;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('report_empty_error'))),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final success = await widget.api.createFeedback(
      widget.token,
      _selectedType,
      _contentController.text,
      _image?.path,
    );
    setState(() => _isSubmitting = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('report_sent_success'))),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('report_sent_failed'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(context.t('create_report'), style: TextStyle(color: context.colors.surface)),
        backgroundColor: context.colors.green,
        iconTheme: IconThemeData(color: context.colors.surface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.t('report_type'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(value: 'bug', child: Text(context.t('bug_error'))),
                DropdownMenuItem(value: 'feature', child: Text(context.t('feature_suggestion'))),
                DropdownMenuItem(value: 'general', child: Text(context.t('general_question'))),
              ],
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            const SizedBox(height: 20),
            Text(context.t('report_content'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Jelaskan masalah atau masukan Anda secara detail...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Text(context.t('attachment_optional'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[500]),
                          const SizedBox(height: 8),
                          Text(context.t('pick_image_gallery'), style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(context.t('send_report'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackDetailPage extends StatefulWidget {
  final FeedbackItem item;
  final UserProfile user;
  final ApiClient api;
  final String token;

  const FeedbackDetailPage({
    super.key,
    required this.item,
    required this.user,
    required this.api,
    required this.token,
  });

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  final _replyController = TextEditingController();
  bool _isReplying = false;
  late FeedbackItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  Future<void> _submitReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() => _isReplying = true);
    final success = await widget.api.replyFeedback(widget.token, _currentItem.id, _replyController.text);
    setState(() => _isReplying = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('reply_sent_success', listen: false))));
        Navigator.pop(context, true); // Pop back to refresh list
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('reply_sent_failed', listen: false))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSuperAdmin = widget.user.role == 'super_admin';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(context.t('report_detail'), style: TextStyle(color: context.colors.surface)),
        backgroundColor: context.colors.green,
        iconTheme: IconThemeData(color: context.colors.surface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _currentItem.type == 'bug' ? Colors.red[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentItem.type.toUpperCase(),
                    style: TextStyle(
                      color: _currentItem.type == 'bug' ? Colors.red[800] : Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  _currentItem.createdAt,
                  style: TextStyle(color: context.colors.muted, fontSize: 12),
                ),
              ],
            ),
            if (isSuperAdmin && _currentItem.userName != null) ...[
              const SizedBox(height: 12),
              Text('${context.t('reporter')}: ${_currentItem.userName} (${_currentItem.userEmail ?? '-'})', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 16),
            Text(context.t('report_content_label'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(_currentItem.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (_currentItem.imagePath != null) ...[
              Text(context.t('attachment_label'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network('${ApiClient.currentBaseUrl}${_currentItem.imagePath}', headers: const {'ngrok-skip-browser-warning': 'true'},
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey[200],
                      child: Center(child: Text(context.t('failed_load_image'))),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
            const Divider(),
            const SizedBox(height: 10),
            Text(context.t('admin_response_label'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            if (_currentItem.status == 'resolved' && _currentItem.adminResponse != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentItem.responderName != null ? 'Dibalas oleh ${_currentItem.responderName}' : 'Tim Support',
                      style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(_currentItem.adminResponse!, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              )
            else if (isSuperAdmin)
              Column(
                children: [
                  TextField(
                    controller: _replyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tulis balasan untuk pelapor...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isReplying ? null : _submitReply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isReplying
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(context.t('send_reply'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(context.t('no_response_yet'), style: TextStyle(color: context.colors.muted)),
              ),
          ],
        ),
      ),
    );
  }
}
