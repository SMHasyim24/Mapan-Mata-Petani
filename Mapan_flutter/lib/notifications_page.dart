import 'package:flutter/material.dart';
import 'package:mapan/main.dart'; // ApiClient, AppNotification, context.colors
import 'package:mapan/detection_detail_page.dart';
import 'package:mapan/expert_application_review_page.dart';
import 'package:mapan/expert_application_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsPage extends StatefulWidget {
  final ApiClient api;
  final String token;

  const NotificationsPage({
    super.key,
    required this.api,
    required this.token,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<AppNotification> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _loading = true);
    try {
      final data = await widget.api.fetchNotifications(widget.token);
      if (mounted) {
        setState(() {
          _notifications = data['notifications'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_load_notifications')} $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _markAsRead(AppNotification notif) async {
    if (notif.isRead) return;
    try {
      await widget.api.markNotificationRead(widget.token, notif.id);
      setState(() {
        final idx = _notifications.indexWhere((n) => n.id == notif.id);
        if (idx != -1) {
          _notifications[idx] = AppNotification(
            id: notif.id,
            type: notif.type,
            data: notif.data,
            isRead: true,
            createdAt: notif.createdAt,
          );
        }
      });
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await widget.api.markAllNotificationsRead(widget.token);
      setState(() {
        _notifications = _notifications.map((n) {
          return AppNotification(
            id: n.id,
            type: n.type,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
          );
        }).toList();
      });
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _deleteAllRead() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('delete_notifications')),
        content: Text(context.t('confirm_delete_read_notifications')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.t('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.t('delete')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await widget.api.deleteAllReadNotifications(widget.token);
        _loadNotifications();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${context.t('failed_delete')} $e')));
        }
      }
    }
  }

  void _openDetectionDetail(AppNotification notif) async {
    await _markAsRead(notif);

    if (notif.data.containsKey('detection_id')) {
      final detectionId = notif.data['detection_id'].toString();
      
      try {
        final detection = await widget.api.fetchDetection(widget.token, detectionId);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => DetectionDetailPage(
                api: widget.api,
                token: widget.token,
                item: detection,
              ),
            ),
          ).then((_) => _loadNotifications());
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t('failed_load_report_detail'))),
          );
        }
      }
    } else if (notif.data.containsKey('application_id')) {
      final applicationId = notif.data['application_id'].toString();
      final actionUrl = notif.data['action_url']?.toString() ?? '';
      
      if (mounted) {
        // IDOR Prevention: Cek Role lokal sebelum mengizinkan UI Admin terbuka
        final prefs = await SharedPreferences.getInstance();
        final role = prefs.getString('user_role') ?? 'user';

        if (!mounted) return;

        // Jika action_url mengandung /admin/ dan user berwenang
        if (actionUrl.contains('/admin/') && (role == 'admin' || role == 'pakar' || role == 'super_admin')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ExpertApplicationReviewPage(
                api: widget.api,
                token: widget.token,
                applicationId: applicationId,
              ),
            ),
          ).then((_) => _loadNotifications());
        } else if (actionUrl.contains('/admin/')) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(context.t('access_denied_not_admin'))),
           );
        } else {
          // Jika tidak, ini notifikasi untuk User biasa (status ditolak/disetujui)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ExpertApplicationPage(
                api: widget.api,
                token: widget.token,
              ),
            ),
          ).then((_) => _loadNotifications());
        }
      }
    } else if (notif.data.containsKey('action_url')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('open_web_admin_system')),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2),
      appBar: AppBar(
        title: Text(context.t('notifications')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: context.t('delete_all_read'),
            onPressed: _notifications.any((n) => n.isRead) ? _deleteAllRead : null,
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tandai Semua Dibaca',
            onPressed: _notifications.any((n) => !n.isRead) ? _markAllAsRead : null,
          ),
        ],
      ),
      body: _loading
          ? _buildShimmerList()
          : _notifications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return _buildNotificationCard(notif);
                    },
                  ),
                ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.t('no_notifications'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notif) {
    final title = notif.data['title'] ?? 'Pemberitahuan';
    final body = notif.data['body'] ?? '';
    final status = notif.data['status'];
    final imageUrl = notif.data['image_url'];

    Color iconColor = context.colors.green;
    IconData icon = Icons.info_outline;

    if (status == 'verified') {
      iconColor = context.colors.mint;
      icon = Icons.check_circle;
    } else if (status == 'rejected') {
      iconColor = Colors.red;
      icon = Icons.cancel;
    }

    return InkWell(
      onTap: () => _openDetectionDetail(notif),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : const Color(0xFFF1F8F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notif.isRead ? Colors.grey.shade200 : context.colors.green.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.toString().isNotEmpty && imageUrl.toString() != 'null')
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network('${ApiClient.currentBaseUrl}$imageUrl', headers: const {'ngrok-skip-browser-warning': 'true'},
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: context.colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(notif.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) {
        return '${diff.inMinutes} menit yang lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} jam yang lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} hari yang lalu';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
