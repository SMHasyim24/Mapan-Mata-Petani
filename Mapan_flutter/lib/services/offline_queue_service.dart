import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mapan/main.dart';
import 'package:mapan/services/notification_service.dart';
import 'package:path/path.dart' as p;

class OfflineQueueService {
  static const String _queueKey = 'offline_reports_queue';

  /// Save a detection draft to local storage
  static Future<void> saveDraft({
    required String token,
    required int diseaseId,
    required String notes,
    required String method,
    double? confidence,
    List<String>? tempImages,
    bool isReport = false,
    double? latitude,
    double? longitude,
    String? status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert temp images to persistent images
    List<String> persistentImages = [];
    if (tempImages != null && tempImages.isNotEmpty) {
      final appDir = await getApplicationDocumentsDirectory();
      final draftDir = Directory('${appDir.path}/drafts');
      if (!await draftDir.exists()) {
        await draftDir.create(recursive: true);
      }
      
      for (String tempPath in tempImages) {
        try {
          final file = File(tempPath);
          if (await file.exists()) {
            final ext = p.extension(tempPath);
            final newPath = '${draftDir.path}/draft_${DateTime.now().millisecondsSinceEpoch}$ext';
            final savedFile = await file.copy(newPath);
            persistentImages.add(savedFile.path);
          }
        } catch (e) {
          print('Failed to copy image to persistent storage: $e');
        }
      }
    }

    final draft = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': token,
      'disease_id': diseaseId,
      'notes': notes,
      'method': method,
      'confidence': confidence,
      'images': persistentImages,
      'is_report': isReport,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': DateTime.now().toIso8601String(),
    };

    final String? existingQueueStr = prefs.getString(_queueKey);
    List<dynamic> queue = existingQueueStr != null ? jsonDecode(existingQueueStr) : [];
    
    queue.add(draft);
    await prefs.setString(_queueKey, jsonEncode(queue));
    
    NotificationService.showLocalBanner(
      'Disimpan ke Draft',
      'Sinyal terputus. Laporan disimpan dan akan dikirim otomatis saat sinyal membaik.',
    );
  }

  /// Check and sync all drafts in the background
  static Future<void> syncDrafts(ApiClient api) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingQueueStr = prefs.getString(_queueKey);
    
    if (existingQueueStr == null) return;
    
    List<dynamic> queue = jsonDecode(existingQueueStr);
    if (queue.isEmpty) return;

    int successCount = 0;
    List<dynamic> remainingQueue = [];

    for (var draft in queue) {
      try {
        final token = draft['token'] as String;
        final diseaseId = draft['disease_id'] as int;
        final notes = draft['notes'] as String;
        final method = draft['method'] as String;
        final confidence = (draft['confidence'] as num?)?.toDouble();
        final isReport = draft['is_report'] as bool? ?? false;
        final latitude = (draft['latitude'] as num?)?.toDouble();
        final longitude = (draft['longitude'] as num?)?.toDouble();
        final status = draft['status'] as String?;
        
        List<String> images = [];
        if (draft['images'] != null) {
          images = List<String>.from(draft['images']);
        }

        // Attempt to upload
        await api.createDetection(
          token: token,
          diseaseId: diseaseId,
          notes: notes,
          method: method,
          confidence: confidence,
          images: images.isNotEmpty ? images : null,
          isReport: isReport,
          latitude: latitude,
          longitude: longitude,
          status: status,
        );
        
        // If success, delete persistent images to save space
        for (String path in images) {
          try {
            final file = File(path);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (_) {}
        }
        
        successCount++;
      } catch (e) {
        // If failed again, keep it in the queue
        remainingQueue.add(draft);
      }
    }

    // Save remaining (failed) drafts back to prefs
    await prefs.setString(_queueKey, jsonEncode(remainingQueue));

    // Show success notification if at least 1 was synced
    if (successCount > 0) {
      NotificationService.showLocalBanner(
        'Sinkronisasi Berhasil',
        '$successCount laporan tertunda Anda telah terkirim ke Pakar!',
      );
    }
  }
}
