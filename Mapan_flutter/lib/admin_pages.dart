import 'package:flutter/material.dart';
import 'package:mapan/services/ml_service.dart';
import 'package:shimmer/shimmer.dart';
import 'notifications_page.dart';
import 'main.dart'; // To access ApiClient, context.colors, etc.
import 'admin_kb_forms.dart';
import 'map_dashboard_page.dart';
import 'detection_detail_page.dart';
import 'all_trending_diseases_page.dart';
import 'trending_disease_reports_page.dart';

// ============================================================================
// ADMIN API EXTENSIONS & MODELS
// ============================================================================

class AdminSymptom {
  final int id;
  final String code;
  final String name;
  final String? description;

  AdminSymptom({
    required this.id,
    required this.code,
    required this.name,
    this.description,
  });

  factory AdminSymptom.fromJson(Map<String, dynamic> json) {
    return AdminSymptom(
      id: json['id'],
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
    );
  }
}

class AdminTreatment {
  final int id;
  final int diseaseId;
  final String title;
  final String description;
  final String? type;
  final String? dosage;
  final String? dosageUnit;
  final int? priority;
  final DiseaseOption? disease;

  AdminTreatment({
    required this.id,
    required this.diseaseId,
    required this.title,
    required this.description,
    this.type,
    this.dosage,
    this.dosageUnit,
    this.priority,
    this.disease,
  });

  factory AdminTreatment.fromJson(Map<String, dynamic> json) {
    return AdminTreatment(
      id: json['id'],
      diseaseId: json['disease_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'],
      dosage: json['dosage'],
      dosageUnit: json['dosage_unit'],
      priority: json['priority'],
      disease: json['disease'] != null
          ? DiseaseOption.fromJson(json['disease'])
          : null,
    );
  }
}

class AdminUser {
  final int id;
  final String name;
  final String email;
  final String role;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }
}

extension AdminApiExtensions on ApiClient {
  // Knowledge Base - Diseases
  Future<List<DiseaseOption>> fetchAdminDiseases(String token) async {
    final json = await request(
      'GET',
      '/private/api/v1/admin/knowledge-base/diseases',
      token: token,
    );
    final data = json['diseases'] ?? [];
    return (data as List).map((d) => DiseaseOption.fromJson(d)).toList();
  }

  Future<void> createDisease(String token, Map<String, dynamic> data) async {
    await request(
      'POST',
      '/private/api/v1/admin/knowledge-base/diseases',
      token: token,
      body: data,
    );
  }

  Future<void> updateDisease(
    String token,
    int id,
    Map<String, dynamic> data,
  ) async {
    await request(
      'PUT',
      '/private/api/v1/admin/knowledge-base/diseases/$id',
      token: token,
      body: data,
    );
  }

  Future<void> deleteDisease(String token, int id) async {
    await request(
      'DELETE',
      '/private/api/v1/admin/knowledge-base/diseases/$id',
      token: token,
    );
  }

  // Knowledge Base - Symptoms
  Future<List<AdminSymptom>> fetchSymptoms(String token) async {
    final json = await request(
      'GET',
      '/private/api/v1/admin/knowledge-base/symptoms',
      token: token,
    );
    final data = json['symptoms'] ?? [];
    return (data as List).map((d) => AdminSymptom.fromJson(d)).toList();
  }

  Future<void> createSymptom(String token, Map<String, dynamic> data) async {
    await request(
      'POST',
      '/private/api/v1/admin/knowledge-base/symptoms',
      token: token,
      body: data,
    );
  }

  Future<void> updateSymptom(
    String token,
    int id,
    Map<String, dynamic> data,
  ) async {
    await request(
      'PUT',
      '/private/api/v1/admin/knowledge-base/symptoms/$id',
      token: token,
      body: data,
    );
  }

  Future<void> deleteSymptom(String token, int id) async {
    await request(
      'DELETE',
      '/private/api/v1/admin/knowledge-base/symptoms/$id',
      token: token,
    );
  }

  // Knowledge Base - Treatments
  Future<List<AdminTreatment>> fetchTreatments(String token) async {
    final json = await request(
      'GET',
      '/private/api/v1/admin/knowledge-base/treatments',
      token: token,
    );
    final data = json['treatments'] ?? [];
    return (data as List).map((d) => AdminTreatment.fromJson(d)).toList();
  }

  Future<void> createTreatment(String token, Map<String, dynamic> data) async {
    await request(
      'POST',
      '/private/api/v1/admin/knowledge-base/treatments',
      token: token,
      body: data,
    );
  }

  Future<void> updateTreatment(
    String token,
    int id,
    Map<String, dynamic> data,
  ) async {
    await request(
      'PUT',
      '/private/api/v1/admin/knowledge-base/treatments/$id',
      token: token,
      body: data,
    );
  }

  Future<void> deleteTreatment(String token, int id) async {
    await request(
      'DELETE',
      '/private/api/v1/admin/knowledge-base/treatments/$id',
      token: token,
    );
  }

  // System - Users
  Future<List<AdminUser>> fetchUsers(String token) async {
    final json = await request(
      'GET',
      '/private/api/v1/admin/system/users',
      token: token,
    );
    final usersData = json['users'] ?? {};
    final data = usersData['data'] ?? [];
    return (data as List).map((d) => AdminUser.fromJson(d)).toList();
  }

  Future<void> updateUserRole(String token, int userId, String role) async {
    await request(
      'PUT',
      '/private/api/v1/admin/system/users/$userId',
      token: token,
      body: {'role': role},
    );
  }

  Future<void> deleteUser(String token, int userId) async {
    await request(
      'DELETE',
      '/private/api/v1/admin/system/users/$userId',
      token: token,
    );
  }

  // Admin - All Detections
  Future<List<DetectionItem>> fetchAllDetections(
    String token, {
    String? city,
    int? diseaseId,
    String? timeRange,
  }) async {
    String url =
        '/private/api/v1/admin/detections?_t=${DateTime.now().millisecondsSinceEpoch}';
    if (city != null) {
      url += '&city=${Uri.encodeComponent(city)}';
    }
    if (diseaseId != null) {
      url += '&disease_id=$diseaseId';
    }
    if (timeRange != null) {
      url += '&time_range=$timeRange';
    }
    final json = await request('GET', url, token: token);
    final data = json['data'];
    if (data is! List) return [];

    return data
        .where((d) => d is Map)
        .map((d) => DetectionItem.fromJson(Map<String, dynamic>.from(d as Map)))
        .toList();
  }
}

// ============================================================================
// PAKAR DASHBOARD (Modern UI)
// ============================================================================

class PakarDashboardPage extends StatefulWidget {
  final ApiClient api;
  final String? token;
  final UserProfile? user;
  final VoidCallback? onGoToHistory;

  const PakarDashboardPage({
    super.key,
    required this.api,
    this.token,
    this.user,
    this.onGoToHistory,
  });

  @override
  State<PakarDashboardPage> createState() => _PakarDashboardPageState();
}

class _PakarDashboardPageState extends State<PakarDashboardPage> {
  DashboardStats _stats = DashboardStats.fallback();
  List<DetectionItem> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant PakarDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _loadData();
    }
  }



  Future<void> _loadData() async {
    final token = widget.token ?? '';
    if (token.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      DashboardStats stats;
      try {
        stats = await widget.api.fetchDashboardStats(token);
      } catch (e) {
        throw Exception('fetchDashboardStats failed: $e');
      }

      List<DetectionItem> detections;
      try {
        detections = await widget.api.fetchAllDetections(token);
      } catch (e) {
        throw Exception('fetchAllDetections failed: $e');
      }

      if (mounted) {
        setState(() {
          _stats = stats;
          _reports = detections;
        });
      }
    } catch (e, stack) {
      debugPrint('PakarDashboardPage Error: $e');
      debugPrint('$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.t('failed_load_report', listen: false)} $e',
            ),
          ),
        );
      }
      // keep fallback
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topDiseases = _stats.trendingDiseases;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with overlapping cards
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  48,
                  24,
                  80,
                ), // extra padding for overlap
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF006948), Color(0xFF00C988)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('welcome_expert'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.user?.name ?? context.t('expert_mapan'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 140, // overlap bottom edge
                left: 24,
                right: 24,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context.t('total_reports'),
                              _stats.totalDetections.toString(),
                              Icons.article_outlined,
                              const Color(0xFF009688),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context.t('total_diseases'),
                              _stats.totalDiseases.toString(),
                              Icons.coronavirus_outlined,
                              const Color(0xFFE65100),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          const SizedBox(height: 120), // Spacing below overlapping cards
          // Trending Diseases Carousel
          if (topDiseases.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t('trending_now'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => AllTrendingDiseasesPage(
                            trendingDiseases: topDiseases,
                            api: widget.api,
                            token: widget.token,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      context.t('see_all'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: topDiseases.length,
                itemBuilder: (context, index) {
                  final item = topDiseases[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => TrendingDiseaseReportsPage(
                            api: widget.api,
                            token: widget.token,
                            diseaseId: item['disease_id'],
                            diseaseName: item['title'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Stack(
                        children: [
                          if (item['image'] != null)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Opacity(
                                  opacity: 0.15,
                                  child: Image.network(
                                    item['image'],
                                    headers: const {
                                      'ngrok-skip-browser-warning': 'true',
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item['percentage']}% ${context.t('from_reports')}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.t('recent_reports'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: widget.onGoToHistory,
                  child: Text(
                    context.t('see_all'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          // Recent reports list
          if (_reports.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(child: Text(context.t('no_report_yet'))),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _reports.length > 5 ? 5 : _reports.length,
              itemBuilder: (ctx, i) {
                final report = _reports[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: report.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  report.imageUrl!,
                                  headers: const {
                                    'ngrok-skip-browser-warning': 'true',
                                  },
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey.shade200,
                      ),
                      child: report.imageUrl == null
                          ? const Icon(Icons.image, color: Colors.grey)
                          : null,
                    ),
                    title: Text(
                      report.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        report.createdAt,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    trailing: Builder(
                      builder: (ctx) {
                        final st = report.status.toLowerCase();
                        Color bgColor = Colors.grey.shade100;
                        Color textColor = Colors.grey.shade800;
                        String text = 'UNKNOWN';

                        if (st == 'verified' || st == 'confirmed') {
                          bgColor = Colors.green.shade100;
                          textColor = Colors.green.shade800;
                          text = context.t('verified_caps');
                        } else if (st == 'rejected') {
                          bgColor = Colors.red.shade100;
                          textColor = Colors.red.shade800;
                          text = context.t('rejected_caps');
                        } else if (st == 'diproses_pakar') {
                          bgColor = Colors.blue.shade100;
                          textColor = Colors.blue.shade800;
                          text = context.t('processing_caps');
                        } else {
                          bgColor = Colors.orange.shade100;
                          textColor = Colors.orange.shade800;
                          text = context.t('waiting_caps');
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => DetectionDetailPage(
                            item: report,
                            api: widget.api,
                            token: widget.token,
                            isPakar: true,
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadData();
                      }
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAKAR HUB (Knowledge Base Management)
// ============================================================================

class _InteractiveGridCard extends StatefulWidget {
  final dynamic item;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const _InteractiveGridCard({
    required this.item,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
    required this.index,
  });

  @override
  State<_InteractiveGridCard> createState() => _InteractiveGridCardState();
}

class _InteractiveGridCardState extends State<_InteractiveGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
    ];
    final color = colors[widget.index % colors.length];
    final iconColor = color
        .withOpacity(1.0)
        .withRed(color.red ~/ 1.5)
        .withGreen(color.green ~/ 1.5)
        .withBlue(color.blue ~/ 1.5);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered ? iconColor : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? iconColor.withOpacity(0.4)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _isHovered ? 20 : 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.coronavirus_outlined,
                          color: iconColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz, color: Colors.grey.shade400),
                    onSelected: (val) {
                      if (val == 'edit') widget.onEdit();
                      if (val == 'delete') widget.onDelete();
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(context.t('edit', listen: false)),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          context.t('delete', listen: false),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpertHubPage extends StatefulWidget {
  const ExpertHubPage({super.key, required this.api, required this.token});
  final ApiClient api;
  final String? token;

  @override
  State<ExpertHubPage> createState() => _ExpertHubPageState();
}

class _ExpertHubPageState extends State<ExpertHubPage> {
  bool _isLoading = true;
  List<DiseaseOption> _diseases = [];
  List<AdminSymptom> _symptoms = [];
  List<AdminTreatment> _treatments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant ExpertHubPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final token = widget.token ?? '';
    if (token.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      _diseases = await widget.api.fetchAdminDiseases(token);
      _symptoms = await widget.api.fetchSymptoms(token);
      _treatments = await widget.api.fetchTreatments(token);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.t('failed_load_data', listen: false)} $e'),
          ),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          context.t('disease_list'),
          style: const TextStyle(
            color: Color(0xFF006948),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _isLoading
          ? _buildShimmerGrid()
          : _buildGrid(
              items: _diseases,
              titleBuilder: (item) => (item as DiseaseOption).name,
              subtitleBuilder: (item) =>
                  (item as DiseaseOption).description ??
                  context.t('no_description'),
              onEdit: (item) => _showDiseaseForm(item as DiseaseOption),
              onDelete: (item) => _confirmDelete(
                'Penyakit',
                (item as DiseaseOption).name,
                () => _deleteDisease(item.id),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00C988),
        elevation: 8,
        onPressed: () => _showDiseaseForm(null),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          context.t('add'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(String type, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${context.t('delete', listen: false)} $type'),
        content: Text(
          context
              .t('confirm_delete_name', listen: false)
              .replaceAll('{name}', name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('cancel', listen: false)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              context.t('delete', listen: false),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDisease(int id) async {
    try {
      await widget.api.deleteDisease(widget.token ?? '', id);
      _loadData();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.t('failed_delete', listen: false)} $e'),
          ),
        );
    }
  }

  Future<void> _deleteSymptom(int id) async {
    try {
      await widget.api.deleteSymptom(widget.token ?? '', id);
      _loadData();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.t('failed_delete', listen: false)} $e'),
          ),
        );
    }
  }

  Future<void> _deleteTreatment(int id) async {
    try {
      await widget.api.deleteTreatment(widget.token ?? '', id);
      _loadData();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.t('failed_delete', listen: false)} $e'),
          ),
        );
    }
  }

  void _showDiseaseForm(DiseaseOption? disease) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiseaseFormPage(
          api: widget.api,
          token: widget.token ?? '',
          disease: disease,
          symptoms: _symptoms,
        ),
      ),
    ).then((_) => _loadData());
  }

  void _showSymptomForm(AdminSymptom? symptom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SymptomFormBottomSheet(
        api: widget.api,
        token: widget.token ?? '',
        symptom: symptom,
      ),
    ).then((_) => _loadData());
  }

  void _showTreatmentForm(AdminTreatment? treatment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TreatmentFormBottomSheet(
        api: widget.api,
        token: widget.token ?? '',
        treatment: treatment,
        diseases: _diseases,
      ),
    ).then((_) => _loadData());
  }

  Widget _buildGrid({
    required List<dynamic> items,
    required String Function(dynamic) titleBuilder,
    required String Function(dynamic) subtitleBuilder,
    required void Function(dynamic) onEdit,
    required void Function(dynamic) onDelete,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          context.t('empty_data'),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _InteractiveGridCard(
          item: item,
          title: titleBuilder(item),
          subtitle: subtitleBuilder(item),
          index: index,
          onEdit: () => onEdit(item),
          onDelete: () => onDelete(item),
        );
      },
    );
  }
}

// ============================================================================
// ADMIN DASHBOARD (System Monitoring)
// ============================================================================

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key, required this.api, required this.token});
  final ApiClient api;
  final String? token;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isLoading = true;
  List<DetectionItem> _reports = [];

  // Pagination & Sorting
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _sortNewestFirst = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant AdminDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final token = widget.token ?? '';
    if (token.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final allDetections = await widget.api.fetchAllDetections(token);
      // Hanya ambil laporan (status bukan diprediksi_ai)
      final reportsOnly = allDetections
          .where((d) => d.status != 'diprediksi_ai')
          .toList();

      if (mounted) {
        setState(() {
          _reports = reportsOnly;
          _currentPage = 1;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Menghitung jumlah laporan per bulan
  Map<String, int> _getMonthlyStats() {
    final Map<String, int> stats = {};
    for (var report in _reports) {
      // Asumsi format ISO "2026-06-23" atau format "23 Jun 2026"
      String monthYear = 'Unknown';
      try {
        if (report.createdAt.contains('-')) {
          final parts = report.createdAt.split('-');
          if (parts.length >= 2) {
            monthYear = '${parts[0]}-${parts[1]}';
          }
        } else {
          final parts = report.createdAt.split(' ');
          if (parts.length >= 3) {
            monthYear = '${parts[1]} ${parts[2]}'; // Misal "Jun 2026"
          }
        }
      } catch (_) {}
      stats[monthYear] = (stats[monthYear] ?? 0) + 1;
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Sort
    final sortedReports = List<DetectionItem>.from(_reports);
    sortedReports.sort((a, b) {
      if (_sortNewestFirst) {
        return b.createdAt.compareTo(a.createdAt);
      } else {
        return a.createdAt.compareTo(b.createdAt);
      }
    });

    // Pagination
    final totalItems = sortedReports.length;
    final totalPages = (totalItems / _itemsPerPage).ceil() == 0
        ? 1
        : (totalItems / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage > totalItems)
        ? totalItems
        : startIndex + _itemsPerPage;
    final paginatedReports = startIndex < totalItems
        ? sortedReports.sublist(startIndex, endIndex)
        : <DetectionItem>[];

    final monthlyStats = _getMonthlyStats();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Dashboard Laporan',
          style: TextStyle(
            color: Color(0xFF006948),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stat Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Laporan',
                      totalItems.toString(),
                      Icons.analytics,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Monthly Stats
              if (monthlyStats.isNotEmpty) ...[
                const Text(
                  'Laporan Per Bulan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: monthlyStats.length,
                    itemBuilder: (ctx, i) {
                      final key = monthlyStats.keys.elementAt(i);
                      final count = monthlyStats[key];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006948),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Laporan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    icon: Icon(
                      _sortNewestFirst
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      size: 16,
                    ),
                    label: Text(_sortNewestFirst ? 'Terbaru' : 'Terlama'),
                    onPressed: () {
                      setState(() {
                        _sortNewestFirst = !_sortNewestFirst;
                        _currentPage = 1; // reset to first page on sort
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List
              if (paginatedReports.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Belum ada laporan',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paginatedReports.length,
                  itemBuilder: (context, index) {
                    final item = paginatedReports[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          backgroundImage: item.userAvatarUrl != null
                              ? NetworkImage(
                                  item.userAvatarUrl!,
                                  headers: const {
                                    'ngrok-skip-browser-warning': 'true',
                                  },
                                )
                              : null,
                          child: item.userAvatarUrl == null
                              ? const Icon(Icons.person, color: Colors.green)
                              : null,
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Pelapor: ${item.userName ?? "Pengguna"}\n${item.location}\n${item.createdAt}',
                        ),
                        isThreeLine: true,
                        trailing: Builder(
                          builder: (ctx) {
                            final st = item.status.toLowerCase();
                            Color bgColor = Colors.grey.shade100;
                            Color textColor = Colors.grey.shade800;
                            String text = 'UNKNOWN';

                            if (st == 'verified' || st == 'confirmed') {
                              bgColor = Colors.green.shade100;
                              textColor = Colors.green.shade800;
                              text = 'TERVERIFIKASI';
                            } else if (st == 'rejected') {
                              bgColor = Colors.red.shade100;
                              textColor = Colors.red.shade800;
                              text = 'DITOLAK';
                            } else if (st == 'diproses_pakar') {
                              bgColor = Colors.blue.shade100;
                              textColor = Colors.blue.shade800;
                              text = 'DIPROSES';
                            } else {
                              bgColor = Colors.orange.shade100;
                              textColor = Colors.orange.shade800;
                              text = 'MENUNGGU';
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DetectionDetailPage(
                                item: item,
                                api: widget.api,
                                token: widget.token,
                                isPakar:
                                    true, // admin acts as pakar for reviewing
                              ),
                            ),
                          ).then((_) => _loadData());
                        },
                      ),
                    );
                  },
                ),

              // Pagination Controls
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        color: Colors.white,
                        onPressed: _currentPage > 1
                            ? () => setState(() => _currentPage--)
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Halaman $_currentPage dari $totalPages',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        color: Colors.white,
                        onPressed: _currentPage < totalPages
                            ? () => setState(() => _currentPage++)
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF006948).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF006948), size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SUPER ADMIN DASHBOARD (User Management)
// ============================================================================

class SuperAdminDashboardPage extends StatefulWidget {
  const SuperAdminDashboardPage({
    super.key,
    required this.api,
    required this.token,
  });
  final ApiClient api;
  final String? token;

  @override
  State<SuperAdminDashboardPage> createState() =>
      _SuperAdminDashboardPageState();
}

class _SuperAdminDashboardPageState extends State<SuperAdminDashboardPage> {
  bool _isLoading = true;
  List<AdminUser> _users = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant SuperAdminDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final token = widget.token ?? '';
    if (token.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      _users = await widget.api.fetchUsers(token);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.t('failed_load_user', listen: false)} $e'),
          ),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showRoleDialog(AdminUser user) {
    String selectedRole = user.role;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.t('change_role', listen: false)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${context.t('user_label', listen: false)}: ${user.name}'),
              const SizedBox(height: 16),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedRole,
                items: [
                  DropdownMenuItem(
                    value: 'user',
                    child: Text(context.t('user', listen: false)),
                  ),
                  DropdownMenuItem(
                    value: 'pakar',
                    child: Text(context.t('expert', listen: false)),
                  ),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text(context.t('admin', listen: false)),
                  ),
                  DropdownMenuItem(
                    value: 'super_admin',
                    child: Text(context.t('super_admin', listen: false)),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedRole = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.t('cancel', listen: false)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF006948),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() => _isLoading = true);
                try {
                  await widget.api.updateUserRole(
                    widget.token ?? '',
                    user.id,
                    selectedRole,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.t('role_change_success', listen: false),
                      ),
                    ),
                  );
                  _loadData();
                } catch (e) {
                  setState(() => _isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${context.t('role_change_failed', listen: false)} $e',
                      ),
                    ),
                  );
                }
              },
              child: Text(context.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(
            color: Color(0xFF006948),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: user.role == 'super_admin'
                      ? Colors.purple[100]
                      : (user.role == 'admin'
                            ? Colors.blue[100]
                            : Colors.green[100]),
                  child: Icon(
                    user.role == 'super_admin'
                        ? Icons.manage_accounts
                        : (user.role == 'admin'
                              ? Icons.admin_panel_settings
                              : Icons.person),
                    color: user.role == 'super_admin'
                        ? Colors.purple
                        : (user.role == 'admin' ? Colors.blue : Colors.green),
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${user.email}\nRole: ${user.role}'),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'role') _showRoleDialog(user);
                    if (val == 'delete')
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.t('delete_user_under_construction'),
                          ),
                        ),
                      );
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'role',
                      child: Text(context.t('change_role_btn')),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        context.t('delete'),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// PAKAR WORKSPACE (Role: Pakar)
// ============================================================================

class PakarWorkspacePage extends StatefulWidget {
  final ApiClient api;
  final String? token;
  final UserProfile? user;

  const PakarWorkspacePage({
    super.key,
    required this.api,
    this.token,
    this.user,
  });

  @override
  State<PakarWorkspacePage> createState() => _PakarWorkspacePageState();
}

class _PakarWorkspacePageState extends State<PakarWorkspacePage>
    with SingleTickerProviderStateMixin {
  List<DetectionItem> _pendingReports = [];
  bool _isLoading = true;
  int _unreadCount = 0;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _loadData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PakarWorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final token = widget.token ?? '';
    if (token.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final allDetections = await widget.api.fetchAllDetections(token);
      final notifData = await widget.api.fetchNotifications(token);
      if (mounted) {
        setState(() {
          _pendingReports = allDetections
              .where(
                (d) =>
                    d.status.toLowerCase() != 'selesai' &&
                    d.status.toLowerCase() != 'verified',
              )
              .toList();
          _unreadCount = notifData['unread_count'] ?? 0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.t('failed_load_queue', listen: false)} $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Ruang Kerja Pakar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Builder(
            builder: (ctx) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  tooltip: context.t('notifications'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsPage(
                          api: widget.api,
                          token: widget.token ?? '',
                        ),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
                if (_unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Glassmorphism Kinerja Pribadi Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _animController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pendingReports.isNotEmpty
                                  ? 1.0 + (_animController.value * 0.1)
                                  : 1.0,
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00C988), Color(0xFF009688)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00C988,
                                  ).withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              _pendingReports.isEmpty
                                  ? Icons.verified
                                  : Icons.notification_important,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t('pending_tasks'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_pendingReports.length} ${context.t('reports_label')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    context.t('priority_queue'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_pendingReports.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 64,
                            color: Colors.yellow.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hore! Semua tugas selesai.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pendingReports.length,
                      itemBuilder: (context, index) {
                        final report = _pendingReports[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOutQuart,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 50 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: _InteractiveReportCard(
                            report: report,
                            api: widget.api,
                            token: widget.token,
                            onVerified: _loadData,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}

class _InteractiveReportCard extends StatefulWidget {
  final DetectionItem report;
  final ApiClient api;
  final String? token;
  final VoidCallback onVerified;

  const _InteractiveReportCard({
    required this.report,
    required this.api,
    this.token,
    required this.onVerified,
  });

  @override
  State<_InteractiveReportCard> createState() => _InteractiveReportCardState();
}

class _InteractiveReportCardState extends State<_InteractiveReportCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => DetectionDetailPage(
              item: widget.report,
              api: widget.api,
              token: widget.token,
              isPakar: true,
            ),
          ),
        );
        if (result == true) {
          widget.onVerified();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 16),
        transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isPressed ? 0.05 : 0.15),
              blurRadius: _isPressed ? 10 : 20,
              offset: Offset(0, _isPressed ? 5 : 10),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: widget.report.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(
                        widget.report.imageUrl!,
                        headers: const {'ngrok-skip-browser-warning': 'true'},
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: widget.report.imageUrl == null
                ? const Icon(Icons.image, color: Colors.grey)
                : null,
          ),
          title: Text(
            widget.report.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laporan dari: ${widget.report.userName ?? "Anonim"}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                if (widget.report.pakarName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Ditinjau oleh Pakar: ${widget.report.pakarName}',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  widget.report.createdAt,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF006948), Color(0xFF00C988)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF006948).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              context.t('verify'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
