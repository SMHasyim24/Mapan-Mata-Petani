import 'package:flutter/material.dart';
import 'main.dart'; // ApiClient, DiseaseOption, context.colors
import 'admin_pages.dart'; // AdminSymptom, AdminTreatment

// ============================================================================
// WIDGET KUSTOM: SoftTextField (Neumorphism / Modern Glow)
// ============================================================================
class _SoftTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int maxLines;

  const _SoftTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<_SoftTextField> createState() => _SoftTextFieldState();
}

class _SoftTextFieldState extends State<_SoftTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused ? const Color(0xFF00C988) : Colors.transparent,
          width: 2,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF00C988).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        validator: widget.validator,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: _isFocused ? const Color(0xFF006948) : Colors.grey.shade600,
            fontWeight: _isFocused ? FontWeight.bold : FontWeight.normal,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

// ============================================================================
// FORM PENYAKIT (DISEASE)
// ============================================================================
class DiseaseFormPage extends StatefulWidget {
  final ApiClient api;
  final String token;
  final DiseaseOption? disease;
  final List<AdminSymptom> symptoms;

  const DiseaseFormPage({
    super.key,
    required this.api,
    required this.token,
    this.disease,
    required this.symptoms,
  });

  @override
  State<DiseaseFormPage> createState() => _DiseaseFormPageState();
}

class _DiseaseFormPageState extends State<DiseaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _latinNameController;
  late TextEditingController _causeController;
  late TextEditingController _descController;

  List<Map<String, dynamic>> _selectedSymptoms = [];
  List<AdminSymptom> _allSymptoms = [];
  List<AdminTreatment> _treatments = [];
  bool _isLoadingTreatments = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.disease?.name);
    _latinNameController = TextEditingController(
      text: widget.disease?.latinName,
    );
    _causeController = TextEditingController(text: widget.disease?.cause);
    _descController = TextEditingController(text: widget.disease?.description);
    _allSymptoms = List.from(widget.symptoms);

    if (widget.disease?.symptoms != null) {
      for (var s in widget.disease!.symptoms!) {
        if (s is Map) {
          _selectedSymptoms.add({
            'id': s['id'],
            'name': s['name'],
            'weight': s['pivot'] != null ? s['pivot']['weight'] : 1.0,
          });
        }
      }
    }

    if (widget.disease != null) {
      _loadTreatments();
    }
  }

  Future<void> _loadTreatments() async {
    setState(() => _isLoadingTreatments = true);
    try {
      final all = await widget.api.fetchTreatments(widget.token);
      if (mounted) {
        setState(() {
          _treatments = all
              .where((t) => t.diseaseId == widget.disease!.id)
              .toList();
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingTreatments = false);
    }
  }

  Future<void> _refreshSymptoms() async {
    try {
      final updated = await widget.api.fetchSymptoms(widget.token);
      if (mounted) setState(() => _allSymptoms = updated);
    } catch (_) {}
  }

  void _toggleSymptom(AdminSymptom symptom) {
    setState(() {
      final idx = _selectedSymptoms.indexWhere((s) => s['id'] == symptom.id);
      if (idx >= 0) {
        _selectedSymptoms.removeAt(idx);
      } else {
        _selectedSymptoms.add({
          'id': symptom.id,
          'name': symptom.name,
          'weight': 1.0,
        });
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final data = {
        'name': _nameController.text,
        'latin_name': _latinNameController.text,
        'description': _descController.text,
        'cause': _causeController.text,
        'symptoms': _selectedSymptoms
            .map((s) => {'id': s['id'], 'weight': s['weight']})
            .toList(),
      };

      if (widget.disease == null) {
        await widget.api.createDisease(widget.token, data);
      } else {
        await widget.api.updateDisease(widget.token, widget.disease!.id, data);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('disease_save_success'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed_save')} $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.disease == null ? context.t('add_disease') : context.t('edit_disease'),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SoftTextField(
              controller: _nameController,
              labelText: context.t('disease_name'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            _SoftTextField(
              controller: _latinNameController,
              labelText: context.t('latin_name_optional'),
            ),
            const SizedBox(height: 16),
            _SoftTextField(
              controller: _causeController,
              labelText: context.t('main_cause'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _SoftTextField(
              controller: _descController,
              labelText: context.t('detailed_desc'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gejala Terkait',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final res = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SymptomFormBottomSheet(
                        api: widget.api,
                        token: widget.token,
                      ),
                    );
                    if (res == true) await _refreshSymptoms();
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(context.t('new_symptom')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSymptoms.map((s) {
                final isSelected = _selectedSymptoms.any((sel) => sel['id'] == s.id);
                return FilterChip(
                  label: Text('${s.code} - ${s.name}'),
                  selected: isSelected,
                  onSelected: (val) => _toggleSymptom(s),
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: const Color(0xFF006948),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: isSelected ? 4 : 0,
                  shadowColor: const Color(0xFF006948).withOpacity(0.4),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Penanganan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (widget.disease != null)
                  TextButton.icon(
                    onPressed: () async {
                      final res = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => TreatmentFormBottomSheet(
                          api: widget.api,
                          token: widget.token,
                          diseases: [widget.disease!],
                        ),
                      );
                      if (res == true) await _loadTreatments();
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(context.t('new_treatment')),
                  ),
              ],
            ),
            if (widget.disease == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Simpan penyakit ini terlebih dahulu untuk menambahkan penanganan.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else if (_isLoadingTreatments)
              const Center(child: CircularProgressIndicator())
            else if (_treatments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Belum ada penanganan.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _treatments.length,
                itemBuilder: (context, index) {
                  final t = _treatments[index];
                  return Card(
                    elevation: 0,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        t.title.isNotEmpty ? t.title : (t.type ?? 'Penanganan'),
                      ),
                      subtitle: Text(
                        t.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onPressed: () async {
                          final res = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => TreatmentFormBottomSheet(
                              api: widget.api,
                              token: widget.token,
                              treatment: t,
                              diseases: [widget.disease!],
                            ),
                          );
                          if (res == true) await _loadTreatments();
                        },
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF006948).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006948),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FORM GEJALA (SYMPTOM)
// ============================================================================
class SymptomFormBottomSheet extends StatefulWidget {
  final ApiClient api;
  final String token;
  final AdminSymptom? symptom;

  const SymptomFormBottomSheet({
    super.key,
    required this.api,
    required this.token,
    this.symptom,
  });

  @override
  State<SymptomFormBottomSheet> createState() => _SymptomFormBottomSheetState();
}

class _SymptomFormBottomSheetState extends State<SymptomFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.symptom?.code);
    _nameController = TextEditingController(text: widget.symptom?.name);
    _descController = TextEditingController(text: widget.symptom?.description);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final data = {
        'code': _codeController.text,
        'name': _nameController.text,
        'description': _descController.text,
      };
      if (widget.symptom == null) {
        await widget.api.createSymptom(widget.token, data);
      } else {
        await widget.api.updateSymptom(widget.token, widget.symptom!.id, data);
      }
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('symptom_save_success'))),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed')} $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.symptom == null ? context.t('add_symptom') : context.t('edit_symptom'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: context.t('symptom_code_example'),
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.t('symptom_name'),
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: context.t('additional_desc'),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006948),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FORM PENANGANAN (TREATMENT)
// ============================================================================
class TreatmentFormBottomSheet extends StatefulWidget {
  final ApiClient api;
  final String token;
  final AdminTreatment? treatment;
  final List<DiseaseOption> diseases;

  const TreatmentFormBottomSheet({
    super.key,
    required this.api,
    required this.token,
    this.treatment,
    required this.diseases,
  });

  @override
  State<TreatmentFormBottomSheet> createState() =>
      _TreatmentFormBottomSheetState();
}

class _TreatmentFormBottomSheetState extends State<TreatmentFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _descController;
  late TextEditingController _dosageController;
  late TextEditingController _dosageUnitController;
  late TextEditingController _priorityController;

  int? _selectedDiseaseId;
  String? _selectedType;

  final List<String> _types = [
    'prevention',
    'chemical',
    'biological',
    'cultural',
  ];

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: widget.treatment?.description,
    );
    _dosageController = TextEditingController(text: widget.treatment?.dosage);
    _dosageUnitController = TextEditingController(
      text: widget.treatment?.dosageUnit,
    );
    _priorityController = TextEditingController(
      text: widget.treatment?.priority?.toString() ?? '0',
    );
    _selectedDiseaseId = widget.treatment?.diseaseId;
    if (_selectedDiseaseId == null && widget.diseases.length == 1) {
      _selectedDiseaseId = widget.diseases.first.id;
    }
    _selectedType = widget.treatment?.type ?? 'prevention';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDiseaseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('select_disease_first'))),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final data = {
        'disease_id': _selectedDiseaseId,
        'type': _selectedType,
        'description': _descController.text,
        'dosage': _dosageController.text.isNotEmpty
            ? _dosageController.text
            : null,
        'dosage_unit': _dosageUnitController.text.isNotEmpty
            ? _dosageUnitController.text
            : null,
        'priority': int.tryParse(_priorityController.text) ?? 0,
      };

      if (widget.treatment == null) {
        await widget.api.createTreatment(widget.token, data);
      } else {
        await widget.api.updateTreatment(
          widget.token,
          widget.treatment!.id,
          data,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('treatment_save_success'))),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${context.t('failed')} $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.treatment == null
                    ? context.t('add_treatment')
                    : context.t('edit_treatment'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedDiseaseId,
                decoration: InputDecoration(
                  labelText: context.t('related_disease'),
                  border: OutlineInputBorder(),
                ),
                items: widget.diseases
                    .map(
                      (d) => DropdownMenuItem(value: d.id, child: Text(d.displayName)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedDiseaseId = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: context.t('treatment_type'),
                  border: OutlineInputBorder(),
                ),
                items: _types
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: context.t('solution_desc'),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dosageController,
                      decoration: InputDecoration(
                        labelText: context.t('dosage_optional'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _dosageUnitController,
                      decoration: InputDecoration(
                        labelText: context.t('unit_optional'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: context.t('priority_0_9'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006948),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
