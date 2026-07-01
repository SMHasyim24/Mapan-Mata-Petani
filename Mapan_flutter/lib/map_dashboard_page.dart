import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:geolocator/geolocator.dart';
import 'main.dart';
import 'admin_pages.dart';
import 'detection_detail_page.dart';

class DiseaseMapPage extends StatefulWidget {
  final ApiClient api;
  final String token;
  final UserProfile? user; // Added to check role if needed

  const DiseaseMapPage({super.key, required this.api, required this.token, this.user});

  @override
  State<DiseaseMapPage> createState() => _DiseaseMapPageState();
}

class _DiseaseMapPageState extends State<DiseaseMapPage> with TickerProviderStateMixin {
  List<MapDetection> _detections = [];
  List<DiseaseOption> _diseases = [];
  bool _isLoading = true;
  final MapController _mapController = MapController();
  
  // Filters
  String? _selectedDiseaseId;
  DateTime? _startDate;
  DateTime? _endDate;
  
  // View Mode
  bool _isHeatmapMode = false;

  @override
  void initState() {
    super.initState();
    _checkLocation();
    _fetchDiseases();
    _loadData();
  }

  Future<void> _checkLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
        if (position.isMocked) {
          widget.api.logFakeGpsAttempt(widget.token, position.latitude, position.longitude);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fake GPS terdeteksi! Akses Peta Sebaran diblokir demi keamanan data.', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context); // Keluarkan user dari halaman peta
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchDiseases() async {
    try {
      final diseases = await widget.api.fetchDiseases();
      if (mounted) {
        setState(() {
          _diseases = diseases;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      String? diseaseId = _selectedDiseaseId == 'all' ? null : _selectedDiseaseId;
      String? startStr = _startDate != null ? "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}" : null;
      String? endStr = _endDate != null ? "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}" : null;
      
      final data = await widget.api.fetchMapDetections(
        widget.token,
        diseaseId: diseaseId,
        startDate: startStr,
        endDate: endStr,
      );
      if (mounted) {
        setState(() {
          _detections = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_load_map')} $e')),
        );
      }
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'berbahaya':
        return Colors.red;
      case 'waspada':
        return Colors.orange;
      case 'ringan':
        return Colors.yellow;
      case 'sehat':
        return Colors.green;
      case 'belum dikonfirmasi':
      default:
        return Colors.grey;
    }
  }

  void _showDetectionBottomSheet(MapDetection det) {
    Color severityColor = _getSeverityColor(det.severity);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return _GlassBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      image: det.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(det.imageUrl!, headers: const {'ngrok-skip-browser-warning': 'true'}),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: det.imageUrl == null
                        ? const Icon(Icons.image_not_supported, color: Colors.white54, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          det.diseaseName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: severityColor.withOpacity(0.2),
                            border: Border.all(color: severityColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Status: ${det.severity.toUpperCase()}',
                            style: TextStyle(
                              color: severityColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoRow(Icons.person, 'Pelapor', det.userName),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.calendar_today, 'Tanggal Lapor', det.date),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, 'Koordinat', '${det.latitude.toStringAsFixed(5)}, ${det.longitude.toStringAsFixed(5)}'),
              if (det.confidence != null) ...[
                const SizedBox(height: 12),
                _buildInfoRow(Icons.analytics, 'Tingkat Keyakinan AI', '${(det.confidence! * 100).toStringAsFixed(1)}%'),
              ],
              const SizedBox(height: 30),
              if (det.city != null && det.city!.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 20),
                        label: Text(context.t('download_pdf', listen: false), style: const TextStyle(fontSize: 12)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _exportReportForCity('pdf', det.city!);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.table_chart, color: Colors.greenAccent, size: 20),
                        label: Text(context.t('download_excel', listen: false), style: const TextStyle(fontSize: 12)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _exportReportForCity('excel', det.city!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        String? tempDiseaseId = _selectedDiseaseId;
        DateTime? tempStart = _startDate;
        DateTime? tempEnd = _endDate;
        
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text('Filter Peta', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Penyakit', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tempDiseaseId,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2E2E2E),
                          hint: const Text('Semua Penyakit', style: TextStyle(color: Colors.white54)),
                          style: const TextStyle(color: Colors.white),
                          items: [
                            const DropdownMenuItem(value: 'all', child: Text('Semua Penyakit')),
                            ..._diseases.map((d) => DropdownMenuItem(
                                  value: d.id.toString(),
                                  child: Text(d.name),
                                )),
                          ],
                          onChanged: (val) {
                            setStateDialog(() {
                              tempDiseaseId = val;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Rentang Tanggal', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempStart ?? DateTime.now().subtract(const Duration(days: 30)),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setStateDialog(() => tempStart = picked);
                              }
                            },
                            child: Text(tempStart != null ? "${tempStart!.day}/${tempStart!.month}/${tempStart!.year}" : 'Dari Tanggal'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempEnd ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setStateDialog(() => tempEnd = picked);
                              }
                            },
                            child: Text(tempEnd != null ? "${tempEnd!.day}/${tempEnd!.month}/${tempEnd!.year}" : 'Sampai Tanggal'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setStateDialog(() {
                      tempDiseaseId = null;
                      tempStart = null;
                      tempEnd = null;
                    });
                  },
                  child: const Text('Reset', style: TextStyle(color: Colors.redAccent)),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _selectedDiseaseId = tempDiseaseId;
                      _startDate = tempStart;
                      _endDate = tempEnd;
                    });
                    _loadData();
                  },
                  child: const Text('Terapkan Filter'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _exportReportGlobal(String format) async {
    debugPrint('DEBUG MAP EXPORT: _exportReportGlobal started, format=$format');
    if (!mounted) {
      debugPrint('DEBUG MAP EXPORT: Widget not mounted, aborting');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${context.t('downloading_report', listen: false)} $format...')),
    );

    try {
      debugPrint('DEBUG MAP EXPORT: Starting request...');
      final baseUrl = widget.api.baseUrl;
      String url = '$baseUrl/private/api/v1/admin/export-report?format=$format';
      if (_selectedDiseaseId != null && _selectedDiseaseId != 'all') url += '&disease_id=$_selectedDiseaseId';
      if (_startDate != null) url += '&start_date=${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}';
      if (_endDate != null) url += '&end_date=${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'X-App-Secret': 'MapanRahasia2026',
        },
      );
      debugPrint('DEBUG MAP EXPORT: Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        Directory? dir;
        if (Platform.isAndroid) {
          dir = await getExternalStorageDirectory();
        }
        dir ??= await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = format == 'pdf' ? 'pdf' : 'xlsx';
        final file = File('${dir.path}/Laporan_Wabah_Global_$timestamp.$ext');
        debugPrint('DEBUG MAP EXPORT: Saving to ${file.path}');
        await file.writeAsBytes(response.bodyBytes);
        debugPrint('DEBUG MAP EXPORT: File saved. Attempting to open with OpenFilex...');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t('download_success_opening', listen: false)),
              action: SnackBarAction(
                label: context.t('open', listen: false),
                onPressed: () => OpenFilex.open(file.path),
              ),
            ),
          );
        }
        final openResult = await OpenFilex.open(file.path);
        debugPrint('DEBUG MAP EXPORT: OpenFilex result: ${openResult.type} - ${openResult.message}');
      } else {
        debugPrint('DEBUG MAP EXPORT: Server returned error: ${response.body}');
        throw Exception('${context.t('server_response_status', listen: false)} ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('DEBUG MAP EXPORT: Exception caught: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_download', listen: false)} $e')),
        );
      }
    }
  }

  void _exportReportForCity(String format, String city) async {
    debugPrint('DEBUG MAP EXPORT CITY: _exportReportForCity started, format=$format, city=$city');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${context.t('downloading_report', listen: false)} $format...')),
    );

    try {
      final baseUrl = widget.api.baseUrl;
      String url = '$baseUrl/private/api/v1/admin/export-report?format=$format&city=${Uri.encodeComponent(city)}';
      
      if (_startDate != null) {
        url += '&start_date=${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}';
      }
      if (_endDate != null) {
        url += '&end_date=${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'X-App-Secret': 'MapanRahasia2026',
        },
      );

      if (response.statusCode == 200) {
        Directory? dir;
        if (Platform.isAndroid) {
          dir = await getExternalStorageDirectory();
        }
        dir ??= await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = format == 'pdf' ? 'pdf' : 'xlsx';
        final file = File('${dir.path}/Laporan_Wabah_${city.replaceAll(' ', '_')}_$timestamp.$ext');
        await file.writeAsBytes(response.bodyBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t('download_success_opening', listen: false)),
              action: SnackBarAction(
                label: context.t('open', listen: false),
                onPressed: () => OpenFilex.open(file.path),
              ),
            ),
          );
        }
        await OpenFilex.open(file.path);
      } else {
        throw Exception('${context.t('server_response_status', listen: false)} ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_download', listen: false)} $e')),
        );
      }
    }
  }

  Widget _buildLegend() {
    return Positioned(
      left: 16,
      bottom: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Keterangan Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                _legendItem(Colors.red, 'Berbahaya'),
                const SizedBox(height: 4),
                _legendItem(Colors.orange, 'Waspada / Awas'),
                const SizedBox(height: 4),
                _legendItem(Colors.yellow, 'Ringan'),
                const SizedBox(height: 4),
                _legendItem(Colors.green, 'Sehat'),
                const SizedBox(height: 4),
                _legendItem(Colors.grey, 'Belum Dikonfirmasi'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.user?.role == 'admin' || widget.user?.role == 'super_admin';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.t('outbreak_spread_map'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: 'Filter Peta',
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.download, color: Colors.white),
            tooltip: 'Unduh Laporan Filter',
            onSelected: _exportReportGlobal,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  value: 'pdf',
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(context.t('download_pdf', listen: false)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'excel',
                  child: ListTile(
                    leading: const Icon(Icons.table_chart, color: Colors.green),
                    title: Text(context.t('download_excel', listen: false)),
                  ),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(-0.789275, 113.921327), // Center of Indonesia
                    initialZoom: 5.0,
                    maxZoom: 18.0,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                    cameraConstraint: CameraConstraint.contain(
                      bounds: LatLngBounds(
                        const LatLng(-15.0, 85.0),
                        const LatLng(10.0, 150.0),
                      ),
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.mapan.app',
                    ),
                    if (_isHeatmapMode)
                      CircleLayer(
                        circles: _detections.map((det) {
                          Color c = _getSeverityColor(det.severity);
                          return CircleMarker(
                            point: LatLng(det.latitude, det.longitude),
                            color: c.withOpacity(0.15),
                            borderStrokeWidth: 0,
                            useRadiusInMeter: false,
                            radius: 35, // Large radius for heatmap overlap effect
                          );
                        }).toList(),
                      )
                    else
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 45,
                          size: const Size(50, 50),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(50),
                          maxZoom: 15,
                          markers: _detections.map((det) {
                            return Marker(
                              point: LatLng(det.latitude, det.longitude),
                              width: 30,
                              height: 30,
                              child: GestureDetector(
                                onTap: () => _showDetectionBottomSheet(det),
                                child: PulsatingMarker(color: _getSeverityColor(det.severity)),
                              ),
                            );
                          }).toList(),
                          builder: (context, markers) {
                            return ClusterMarkerWidget(markers: markers);
                          },
                        ),
                      ),
                  ],
                ),
                _buildLegend(),
                // Floating Action Buttons for Map Controls
                Positioned(
                  right: 16,
                  bottom: 30,
                  child: Column(
                    children: [
                      _GlassFab(
                          icon: _isHeatmapMode ? Icons.pin_drop : Icons.local_fire_department,
                          color: _isHeatmapMode ? Colors.blueAccent : Colors.redAccent,
                          onPressed: () {
                            setState(() {
                              _isHeatmapMode = !_isHeatmapMode;
                            });
                          },
                        ),
                      if (isAdmin) const SizedBox(height: 12),
                      _GlassFab(
                        icon: Icons.add,
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(_mapController.camera.center, currentZoom + 1);
                        },
                      ),
                      const SizedBox(height: 12),
                      _GlassFab(
                        icon: Icons.remove,
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(_mapController.camera.center, currentZoom - 1);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ============================================================================
// MICRO-INTERACTION WIDGETS
// ============================================================================

class PulsatingMarker extends StatefulWidget {
  final Color color;
  const PulsatingMarker({super.key, required this.color});

  @override
  State<PulsatingMarker> createState() => _PulsatingMarkerState();
}

class _PulsatingMarkerState extends State<PulsatingMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 10 * _scaleAnim.value,
                  spreadRadius: 2 * _scaleAnim.value,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.coronavirus, color: Colors.white, size: 16),
            ),
          ),
        );
      },
    );
  }
}

class ClusterMarkerWidget extends StatefulWidget {
  final List<Marker> markers;
  const ClusterMarkerWidget({super.key, required this.markers});

  @override
  State<ClusterMarkerWidget> createState() => _ClusterMarkerWidgetState();
}

class _ClusterMarkerWidgetState extends State<ClusterMarkerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getClusterColor(int count) {
    if (count < 10) return Colors.greenAccent;
    if (count < 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.markers.length;
    Color clusterColor = _getClusterColor(count);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double scale = 1.0 + (_controller.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: clusterColor.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: clusterColor.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlassFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _GlassFab({required this.icon, required this.onPressed, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: color.withOpacity(0.2),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassBottomSheet extends StatelessWidget {
  final Widget child;

  const _GlassBottomSheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CITY DETECTIONS PAGE
// ============================================================================

class CityDetectionsPage extends StatefulWidget {
  final ApiClient api;
  final String token;
  final String city;
  final String province;
  final DateTime? startDate;
  final DateTime? endDate;

  const CityDetectionsPage({
    super.key,
    required this.api,
    required this.token,
    required this.city,
    required this.province,
    this.startDate,
    this.endDate,
  });

  @override
  State<CityDetectionsPage> createState() => _CityDetectionsPageState();
}

class _CityDetectionsPageState extends State<CityDetectionsPage> {
  List<DetectionItem> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await widget.api.fetchAllDetections(widget.token, city: widget.city);
      if (mounted) {
        setState(() {
          _reports = data;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_load_report_data')} $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _exportCityReport(String format) async {
    debugPrint('DEBUG MAP EXPORT CITY: _exportCityReport started, format=$format, city=${widget.city}');
    if (!mounted) {
      debugPrint('DEBUG MAP EXPORT CITY: not mounted');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${context.t('downloading_report', listen: false)} $format...')),
    );

    try {
      final baseUrl = widget.api.baseUrl;
      String url = '$baseUrl/private/api/v1/admin/export-report?format=$format&city=${Uri.encodeComponent(widget.city)}';
      debugPrint('DEBUG MAP EXPORT CITY: URL=$url');
      
      if (widget.startDate != null) {
        url += '&start_date=${widget.startDate!.year}-${widget.startDate!.month.toString().padLeft(2, '0')}-${widget.startDate!.day.toString().padLeft(2, '0')}';
      }
      if (widget.endDate != null) {
        url += '&end_date=${widget.endDate!.year}-${widget.endDate!.month.toString().padLeft(2, '0')}-${widget.endDate!.day.toString().padLeft(2, '0')}';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'X-App-Secret': 'MapanRahasia2026',
        },
      );
      debugPrint('DEBUG MAP EXPORT CITY: Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        Directory? dir;
        if (Platform.isAndroid) {
          dir = await getExternalStorageDirectory();
        }
        dir ??= await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = format == 'pdf' ? 'pdf' : 'xlsx';
        final file = File('${dir.path}/Laporan_Wabah_${widget.city.replaceAll(' ', '_')}_$timestamp.$ext');
        debugPrint('DEBUG MAP EXPORT CITY: Saving to ${file.path}');
        await file.writeAsBytes(response.bodyBytes);
        debugPrint('DEBUG MAP EXPORT CITY: File saved. Attempting to open with OpenFilex...');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t('download_success_opening', listen: false)),
              action: SnackBarAction(
                label: context.t('open', listen: false),
                onPressed: () => OpenFilex.open(file.path),
              ),
            ),
          );
        }
        await OpenFilex.open(file.path);
      } else {
        throw Exception('${context.t('server_response_status')} ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t('failed_download')} $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${context.t('report_in')} ${widget.city}'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            tooltip: 'Unduh Laporan ${widget.city}',
            onSelected: _exportCityReport,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'pdf',
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(context.t('download_pdf', listen: false)),
                ),
              ),
              PopupMenuItem<String>(
                value: 'excel',
                child: ListTile(
                  leading: const Icon(Icons.table_chart, color: Colors.green),
                  title: Text(context.t('download_excel', listen: false)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? Center(child: Text(context.t('no_report_in_city')))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return _InteractiveCityReportCard(
                      report: report,
                      api: widget.api,
                      token: widget.token,
                      onReturn: _loadData,
                    );
                  },
                ),
    );
  }
}

class _InteractiveCityReportCard extends StatefulWidget {
  final DetectionItem report;
  final ApiClient api;
  final String token;
  final VoidCallback onReturn;

  const _InteractiveCityReportCard({
    required this.report,
    required this.api,
    required this.token,
    required this.onReturn,
  });

  @override
  State<_InteractiveCityReportCard> createState() => _InteractiveCityReportCardState();
}

class _InteractiveCityReportCardState extends State<_InteractiveCityReportCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        transform: Matrix4.identity()..scale(_isHovering ? 1.02 : 1.0),
        child: Card(
          elevation: _isHovering ? 8 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: widget.report.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(widget.report.imageUrl!, headers: const {'ngrok-skip-browser-warning': 'true'}),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey.shade100,
              ),
              child: widget.report.imageUrl == null
                  ? const Icon(Icons.image, color: Colors.grey)
                  : null,
            ),
            title: Text(
              widget.report.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.report.createdAt,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
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
                widget.onReturn();
              }
            },
          ),
        ),
      ),
    );
  }
}
