import 'dart:io' as dart_io;
import 'package:flutter/material.dart';
import 'package:mapan/main.dart';
import 'package:mapan/detection_detail_page.dart';

class DetectionResultModal extends StatefulWidget {
  final DiseaseOption disease;
  final VoidCallback onSave;
  final VoidCallback onReport;
  final List<String> images;
  final double confidence;
  final List<Map<String, dynamic>> top3;

  const DetectionResultModal({
    super.key,
    required this.disease,
    required this.onSave,
    required this.onReport,
    this.images = const [],
    this.confidence = 0.0,
    this.top3 = const [],
  });

  @override
  State<DetectionResultModal> createState() => _DetectionResultModalState();
}

class _DetectionResultModalState extends State<DetectionResultModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isHealthy = widget.disease.name.toLowerCase() == 'sehat' || widget.disease.name.toLowerCase() == 'healthy';

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F9F8),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull handle
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 24),

              // Thumbnail & Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.images.isNotEmpty)
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: FileImage(dart_io.File(widget.images.first)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t('ai_detection_result'),
                          style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.disease.displayName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isHealthy ? const Color(0xFF006948) : Colors.red[700],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.confidence > 0)
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isHealthy ? const Color(0xFF006948).withOpacity(0.1) : Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${(widget.confidence * (widget.confidence <= 1.0 ? 100 : 1)).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isHealthy ? const Color(0xFF006948) : Colors.red[700],
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
              const SizedBox(height: 16),
              
              // Top 3 Predictions
              if (widget.top3.length > 1)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('other_possibilities'),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      ...widget.top3.skip(1).map((pred) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  DiseaseOption(id: 0, name: pred['label'] as String).displayName,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF171D19)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${((pred['confidence'] as double) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              if (widget.top3.length > 1) const SizedBox(height: 16)
              else const SizedBox(height: 24),

              // Detail Button
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetectionDetailPage(
                        disease: widget.disease,
                        localImages: widget.images,
                        confidence: widget.confidence,
                        onSave: widget.onSave,
                        onReport: widget.onReport,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.t('see_disease_details'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF171D19)),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF006948)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  context.t('cancel_or_rescan'),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}