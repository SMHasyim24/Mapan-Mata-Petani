import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mapan/main.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class DetectionDetailPage extends StatefulWidget {
  final DetectionItem? item;
  final DiseaseOption? disease;
  final List<String> localImages;
  final double confidence;
  final VoidCallback? onSave;
  final VoidCallback? onReport;
  final ApiClient? api;
  final String? token;
  final bool isPakar;

  const DetectionDetailPage({
    super.key,
    this.item,
    this.disease,
    this.localImages = const [],
    this.confidence = 0.0,
    this.onSave,
    this.onReport,
    this.api,
    this.token,
    this.isPakar = false,
  });

  @override
  State<DetectionDetailPage> createState() => _DetectionDetailPageState();
}

class _DetectionDetailPageState extends State<DetectionDetailPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _badgeAnimController;

  int _currentImageIndex = 0;

  // Inline Edit State
  bool _isEditMode = false;
  bool _isLoadingPakar = false;
  List<DiseaseOption> _allDiseases = [];
  int? _selectedDiseaseId;
  String? _selectedSeverity;
  final TextEditingController _expertNotesController = TextEditingController();
  final TextEditingController _confidenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _badgeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    if (widget.isPakar && widget.api != null && widget.token != null) {
      _loadDiseasesForPakar();
      if (widget.item != null) {
        if (widget.item!.expertNotes != null &&
            widget.item!.expertNotes!.isNotEmpty) {
          _expertNotesController.text = widget.item!.expertNotes!;
        } else if (widget.item!.diseaseTreatments.isNotEmpty) {
          _expertNotesController.text = widget.item!.diseaseTreatments
              .asMap()
              .entries
              .map((e) => '${e.key + 1}. ${e.value}')
              .join('\n');
        }
        if (widget.item!.confidence != null) {
          _confidenceController.text = widget.item!.confidence!.toStringAsFixed(
            1,
          );
        } else {
          _confidenceController.text = '100.0';
        }
      }
    }
  }

  Future<void> _loadDiseasesForPakar() async {
    try {
      final res = await widget.api!.fetchDiseases();
      if (mounted) {
        setState(() {
          _allDiseases = res;
          if (widget.item != null && widget.item!.diseaseId != null) {
            _selectedDiseaseId = widget.item!.diseaseId;
          } else if (widget.disease != null) {
            try {
              final found = _allDiseases.firstWhere(
                (d) => d.id == widget.disease!.id,
              );
              _selectedDiseaseId = found.id;
            } catch (_) {}
          }
        });
      }
    } catch (e) {
      debugPrint("Failed to load diseases for pakar: $e");
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    if (widget.api == null || widget.token == null || widget.item == null)
      return;

    if (newStatus == 'verified' && _selectedSeverity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tingkat Bahaya harus diisi!')),
      );
      return;
    }
    if (newStatus == 'verified' && _expertNotesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan pakar harus diisi!')),
      );
      return;
    }

    setState(() => _isLoadingPakar = true);
    try {
      await widget.api!.reviewReport(
        token: widget.token!,
        detectionId: widget.item!.id.toString(),
        status: newStatus,
        severity: _selectedSeverity ?? 'Belum Dikonfirmasi',
        expertNotes: _expertNotesController.text,
        confidence: widget.item!.confidence,
        diseaseId: _selectedDiseaseId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.t('report_success_status')} $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed')} $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPakar = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _badgeAnimController.dispose();
    _expertNotesController.dispose();
    _confidenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.item?.title ?? widget.disease?.displayName ?? 'Detail Deteksi';
    final description =
        widget.item?.diseaseDescription ??
        widget.disease?.description ??
        context.t('generic_disease_description');
    final treatments =
        widget.item?.diseaseTreatments ?? widget.disease?.treatments ?? [];
    final date = widget.item?.createdAt ?? 'Hari ini';
    final location =
        widget.item?.location ?? context.t('location_not_available');
    final status = widget.item?.status ?? 'Pending';
    final isHealthy =
        title.toLowerCase() == 'sehat' || title.toLowerCase() == 'healthy';

    // Perbaikan lokasi: Jika tidak tersedia, tampilkan teks yang lebih natural
    final displayLocation =
        (location == context.t('location_not_available') ||
            location.trim().isEmpty)
        ? context.t('local_device_scan')
        : location;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F4F2,
      ), // Lighter, more modern background
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // PARALLAX HERO IMAGE
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            stretch: true,
            backgroundColor: context.colors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Builder(
                    builder: (context) {
                      final List<String> images = widget.localImages.isNotEmpty
                          ? List.from(widget.localImages)
                          : List.from(widget.item?.images ?? []);

                      if (images.isEmpty) {
                        if (widget.item?.imageUrl != null &&
                            widget.item!.imageUrl!.isNotEmpty) {
                          images.add(widget.item!.imageUrl!);
                        }
                      }

                      if (images.isNotEmpty) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            PageView.builder(
                              itemCount: images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final isLocal = widget.localImages.isNotEmpty;
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.zero,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            InteractiveViewer(
                                              panEnabled: true,
                                              minScale: 0.5,
                                              maxScale: 4,
                                              child: isLocal
                                                  ? Image.file(
                                                      File(images[index]),
                                                    )
                                                  : Image.network(
                                                      images[index],
                                                      headers: const {
                                                        'ngrok-skip-browser-warning':
                                                            'true',
                                                      },
                                                    ),
                                            ),
                                            Positioned(
                                              top: 40,
                                              right: 20,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: isLocal
                                      ? Image.file(
                                          File(images[index]),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          images[index],
                                          headers: const {
                                            'ngrok-skip-browser-warning':
                                                'true',
                                          },
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stack) =>
                                              Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 64,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        ),
                                );
                              },
                            ),
                            if (images.length > 1)
                              Positioned(
                                top: 40,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_currentImageIndex + 1} / ${images.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      }
                    },
                  ),

                  // Gradient Overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Glassmorphism Title Card
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: FadeInUp(
                      delay: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: isHealthy
                                              ? const Color(0xFF6EE7B7)
                                              : const Color(0xFFFCA5A5),
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    _buildAnimatedBadge(status, isHealthy),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (widget.confidence > 0) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isHealthy
                                              ? Colors.greenAccent.withOpacity(
                                                  0.3,
                                                )
                                              : Colors.redAccent.withOpacity(
                                                  0.3,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '${(widget.confidence * (widget.confidence <= 1.0 ? 100 : 1)).toStringAsFixed(1)}% ${context.t('accuracy_label')}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      date,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
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
                  ),
                ],
              ),
            ),
          ),

          // CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    delay: 200,
                    child: _buildLocationCard(
                      displayLocation,
                      lat: widget.item?.latitude,
                      lng: widget.item?.longitude,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (widget.item != null &&
                      widget.item!.status.toLowerCase() != 'diprediksi_ai') ...[
                    FadeInUp(
                      delay: 300,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.orange.shade200,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.orangeAccent
                                      .withOpacity(0.2),
                                  backgroundImage:
                                      widget.item!.userAvatarUrl != null
                                      ? NetworkImage(
                                          '${ApiClient.currentBaseUrl}${widget.item!.userAvatarUrl}',
                                          headers: const {
                                            'ngrok-skip-browser-warning':
                                                'true',
                                          },
                                        )
                                      : null,
                                  child: widget.item!.userAvatarUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.orange,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.t('report_from'),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        widget.item!.userName ?? 'Petani',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.t('complaint_notes'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.item!.userNotes?.isNotEmpty == true
                                  ? widget.item!.userNotes!
                                  : context.t('no_additional_complaints'),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: 350,
                      child: _buildSectionCard(
                        title: widget.item?.status.toLowerCase() == 'verified' ||
                                widget.item?.status.toLowerCase() == 'confirmed'
                            ? context.t('final_expert_diagnosis')
                            : context.t('initial_ai_diagnosis'),
                        icon: Icons.medical_services_outlined,
                        color: Colors.cyan.shade600,
                        content: '${widget.item!.title} (${(widget.item!.confidence * (widget.item!.confidence <= 1.0 ? 100 : 1)).toStringAsFixed(1)}% ${context.t('accuracy_label')})',
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else if (description.isNotEmpty) ...[
                    // Tampilkan Penjelasan Penyakit HANYA jika ini scan biasa yang belum dilapor
                    FadeInUp(
                      delay: 400,
                      child: _buildSectionCard(
                        title: context.t('disease_explanation'),
                        icon: Icons.info_outline,
                        color: Colors.blueAccent,
                        content: description,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Catatan Pakar menggantikan Rekomendasi Tindakan AI
                  if (_isEditMode) ...[
                    FadeInUp(delay: 600, child: _buildEditModeForm()),
                  ] else if (widget.item?.expertNotes != null &&
                      widget.item!.expertNotes!.isNotEmpty) ...[
                    FadeInUp(
                      delay: 600,
                      child: _buildSectionCard(
                        title: context.t('expert_recommendation_notes'),
                        icon: Icons.verified_user_outlined,
                        color: const Color(0xFF006948),
                        content: widget.item!.expertNotes!,
                        isExpert: true,
                      ),
                    ),
                  ] else if (!isHealthy && treatments.isNotEmpty) ...[
                    // Tampilkan Rekomendasi AI HANYA jika Pakar belum memberikan catatan
                    FadeInUp(
                      delay: 600,
                      child: Text(
                        context.t('ai_action_recommendation'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...treatments.asMap().entries.map((entry) {
                      return FadeInUp(
                        delay: 700 + (entry.key * 100),
                        child: _buildInteractiveTreatmentCard(
                          entry.value,
                          entry.key + 1,
                        ),
                      );
                    }),
                  ],

                  if (widget.isPakar && !_isEditMode) ...[
                    const SizedBox(height: 32),
                    _buildPakarReviewSection(),
                  ],

                  const SizedBox(height: 100), // padding for floating buttons
                ],
              ),
            ),
          ),
        ],
      ),

      // FLOATING ACTION BUTTONS
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (widget.onSave != null && widget.onReport != null)
          ? FadeInUp(
              delay: 1200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FloatingActionButton.extended(
                        heroTag: 'btn1',
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSave!();
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF006948),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        label: Text(
                          context.t('save'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.bookmark_border),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FloatingActionButton.extended(
                        heroTag: 'btn2',
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onReport!();
                        },
                        backgroundColor: const Color(0xFF006948),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        label: Text(
                          context.t('create_report'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  // Microinteraction: Animated Badge
  Widget _buildAnimatedBadge(String status, bool isHealthy) {
    // If it's a pending AI prediction, make it pulse with a warning color
    final isAiPrediction =
        status.toLowerCase().contains('diprediksi') ||
        status.toLowerCase() == 'pending';
    final baseColor = isAiPrediction
        ? Colors.orangeAccent
        : (isHealthy ? Colors.greenAccent : Colors.redAccent);
    final text = (status.toLowerCase() == 'pending')
        ? context.t('diprediksi_ai_caps')
        : status.replaceAll('_', ' ').toUpperCase();

    return AnimatedBuilder(
      animation: _badgeAnimController,
      builder: (context, child) {
        final glow = isAiPrediction ? _badgeAnimController.value * 6 : 0.0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: baseColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: baseColor.withOpacity(0.8), width: 1.5),
            boxShadow: [
              if (isAiPrediction)
                BoxShadow(
                  color: baseColor.withOpacity(0.4),
                  blurRadius: glow,
                  spreadRadius: glow / 2,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAiPrediction) ...[
                Icon(Icons.auto_awesome, color: baseColor, size: 14),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: baseColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationCard(String locationText, {double? lat, double? lng}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t('capture_location'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locationText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (lat != null && lng != null && lat != 0.0 && lng != 0.0) ...[
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.open_in_new,
                          size: 14,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
    bool isExpert = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isExpert ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isExpert ? Border.all(color: color.withOpacity(0.3)) : null,
        boxShadow: isExpert
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isExpert ? color : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog() {
    _expertNotesController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('report_detail')),
        elevation: 0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.t('reason_for_rejection')),
            const SizedBox(height: 12),
            TextField(
              controller: _expertNotesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Alasan penolakan...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _updateStatus('rejected');
            },
            child: Text(context.t('reject_report')),
          ),
        ],
      ),
    );
  }

  Widget _buildEditModeForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colors.green.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.green.withOpacity(0.1),
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
              Icon(Icons.edit_document, color: context.colors.green),
              const SizedBox(width: 8),
              Text(
                context.t('edit_recommendation'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.t('actual_disease_diagnosis'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_allDiseases.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<int>(
              isExpanded: true,
              value: _selectedDiseaseId,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: _allDiseases.map((d) {
                return DropdownMenuItem<int>(
                  value: d.id,
                  child: Text(d.displayName),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDiseaseId = val;
                  if (val != null) {
                    final d = _allDiseases.firstWhere((x) => x.id == val);
                    if (d.name.toLowerCase() == 'healthy' ||
                        d.name.toLowerCase() == 'sehat') {
                      _selectedSeverity = 'Sehat';
                    }
                  }
                });
              },
            ),
          const SizedBox(height: 16),
          const Text(
            'Tingkat Bahaya (Severity)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: _selectedSeverity,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Sehat', child: Text('Sehat')),
              DropdownMenuItem(value: 'Ringan', child: Text('Ringan')),
              DropdownMenuItem(value: 'Waspada', child: Text('Waspada / Awas')),
              DropdownMenuItem(value: 'Berbahaya', child: Text('Berbahaya')),
            ],
            onChanged: (val) => setState(() => _selectedSeverity = val),
          ),

          Text(
            context.t('expert_recommendation'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _expertNotesController,
            maxLines: 6,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Tulis rekomendasi...',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => _isEditMode = false),
                  child: Text(
                    context.t('cancel'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoadingPakar
                      ? null
                      : () => _updateStatus('verified'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoadingPakar
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          context.t('save_and_confirm'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPakarReviewSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.green.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.admin_panel_settings, color: context.colors.green),
              const SizedBox(width: 8),
              Text(
                context.t('expert_review'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (widget.item?.status.toLowerCase() == 'diproses_pakar' && widget.item?.pakarName != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Laporan ini sedang ditangani oleh Pakar: ${widget.item!.pakarName}',
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (widget.item?.status.toLowerCase() == 'pending' ||
              widget.item?.status.toLowerCase() == 'diproses_pakar') ...[
            Text(
              context.t('report_waiting_review'),
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoadingPakar
                        ? null
                        : () async {
                            if (widget.api != null &&
                                widget.token != null &&
                                widget.item != null) {
                              setState(() => _isLoadingPakar = true);
                              try {
                                await widget.api!.claimDetection(
                                  token: widget.token!,
                                  id: widget.item!.id.toString(),
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Berhasil mengambil laporan. Silakan isi ulasan Anda.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  setState(() {
                                    _isEditMode = true;
                                    _isLoadingPakar = false;
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() => _isLoadingPakar = false);
                                  final errorMessage = e.toString().replaceAll('Exception: ', '');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } else {
                              setState(() {
                                _isEditMode = true;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoadingPakar
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(widget.item?.status.toLowerCase() == 'diproses_pakar' ? 'LANJUTKAN MENGULAS' : context.t('accept_report_caps')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _showRejectDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(context.t('reject_report_caps')),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text(
              'Laporan ini telah selesai ditinjau.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            if (widget.item?.pakarName != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: widget.item!.pakarAvatarUrl != null
                        ? NetworkImage(
                            widget.item!.pakarAvatarUrl!,
                            headers: const {
                              'ngrok-skip-browser-warning': 'true',
                            },
                          )
                        : null,
                    backgroundColor: Colors.grey.shade200,
                    child: widget.item!.pakarAvatarUrl == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ditinjau oleh Pakar:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          widget.item!.pakarName!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInteractiveTreatmentCard(String text, int index) {
    return _InteractiveCard(text: text, index: index);
  }
}

class _InteractiveCard extends StatefulWidget {
  final String text;
  final int index;
  const _InteractiveCard({required this.text, required this.index});

  @override
  State<_InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<_InteractiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed ? const Color(0xFF4ADE80) : Colors.transparent,
          ),
          boxShadow: [
            if (!_isPressed)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF006948).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${widget.index}',
                style: const TextStyle(
                  color: Color(0xFF006948),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
