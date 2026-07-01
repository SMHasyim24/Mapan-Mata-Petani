import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'dart:math' as math;
import 'package:onnxruntime/onnxruntime.dart';

// ============================================================
// Top-level function — wajib di luar class agar bisa di-compute()
// Dijalankan di background isolate, TIDAK memblokir UI thread
// ============================================================
Future<List<Map<String, dynamic>?>> _runBatchOnnxInference(Map<String, dynamic> params) async {
  final imagesBytes = params['imagesBytes'] as List<Uint8List>;
  final modelBytes = params['modelBytes'] as Uint8List;
  final labels = params['labels'] as List<String>;

  try {
    OrtEnv.instance.init();
    final sessionOptions = OrtSessionOptions();
    final session = OrtSession.fromBuffer(modelBytes, sessionOptions);
    final inputNames = session.inputNames;

    final results = <Map<String, dynamic>?>[];

    if (inputNames.isEmpty) {
      session.release();
      OrtEnv.instance.release();
      return List.filled(imagesBytes.length, null);
    }

    // 2. Loop untuk memproses setiap gambar
    for (final imageBytes in imagesBytes) {
      Map<String, dynamic>? result;
      try {
        final image = img.decodeImage(imageBytes);
        if (image != null) {
          final resized = img.copyResize(image, width: 224, height: 224);
          final inputData = Float32List(1 * 224 * 224 * 3);
          int index = 0;
          for (int y = 0; y < 224; y++) {
            for (int x = 0; x < 224; x++) {
              final pixel = resized.getPixel(x, y);
              inputData[index++] = pixel.r / 255.0;
              inputData[index++] = pixel.g / 255.0;
              inputData[index++] = pixel.b / 255.0;
            }
          }

          final inputTensor = OrtValueTensor.createTensorWithDataList(
            inputData,
            [1, 224, 224, 3],
          );
          final runOptions = OrtRunOptions();
          final outputs = session.run(runOptions, {inputNames.first: inputTensor});

          final outputValue = outputs[0];
          if (outputValue != null) {
            final rawOutput = (outputValue.value as List<List<double>>)[0];
            
            // Cek apakah output adalah logits (sum bukan 1)
            double sum = rawOutput.fold(0.0, (a, b) => a + b);
            List<double> probabilities = rawOutput;
            if ((sum - 1.0).abs() > 0.1) {
              // Apply Softmax
              double maxVal = rawOutput.reduce((curr, next) => curr > next ? curr : next);
              double sumExp = 0.0;
              probabilities = [];
              for (double val in rawOutput) {
                double expVal = math.exp(val - maxVal);
                probabilities.add(expVal);
                sumExp += expVal;
              }
              for (int i = 0; i < probabilities.length; i++) {
                probabilities[i] /= sumExp;
              }
            }

            // Dapatkan Top 3 Prediksi
            final List<Map<String, dynamic>> predictions = [];
            for (int i = 0; i < probabilities.length; i++) {
              if (i < labels.length) {
                predictions.add({
                  'label': labels[i],
                  'confidence': probabilities[i],
                });
              }
            }
            // Sort berdasarkan confidence tertinggi ke terendah
            predictions.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));
            
            if (predictions.isNotEmpty) {
              result = {
                'label': predictions.first['label'],
                'confidence': predictions.first['confidence'],
                'top3': predictions.take(3).toList(),
              };
            }
          }

          inputTensor.release();
          runOptions.release();
          for (final e in outputs) {
            e?.release();
          }
        }
      } catch (e) {
        print('Isolate inference error on single image: $e');
      }
      results.add(result);
    }

    // 3. Bersihkan memori dan environment
    session.release();
    OrtEnv.instance.release();
    
    return results;
  } catch (e) {
    print('ONNX batch inference error: $e');
    try { OrtEnv.instance.release(); } catch (_) {}
    return List.filled(imagesBytes.length, null);
  }
}

// ============================================================
// MlService — hanya menyimpan bytes, session dibuat per-isolate
// ============================================================
class MlService {
  static final MlService _instance = MlService._internal();

  factory MlService() {
    return _instance;
  }

  MlService._internal();

  static Uint8List? _modelBytes;
  static List<String> _labels = [];
  static bool _isInitialized = false;

  /// Panggil sekali di initState() — hanya memuat bytes ke RAM
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final labelsData =
          await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final rawAsset = await rootBundle.load('assets/models/model.onnx');
      _modelBytes = rawAsset.buffer.asUint8List(
        rawAsset.offsetInBytes,
        rawAsset.lengthInBytes,
      );

      _isInitialized = true;
    } catch (e) {
      print('MlService init error: $e');
    }
  }

  /// Deteksi penyakit untuk BANYAK gambar sekaligus dalam 1 isolate
  Future<List<Map<String, dynamic>?>> detectDiseases(List<String> imagePaths) async {
    if (!_isInitialized) await init();
    if (_modelBytes == null || imagePaths.isEmpty) return List.filled(imagePaths.length, null);

    try {
      // Baca semua file sebagai bytes
      final imagesBytes = <Uint8List>[];
      for (final path in imagePaths) {
        imagesBytes.add(await File(path).readAsBytes());
      }

      // Jalankan batch inference di background isolate
      final results = await compute<Map<String, dynamic>, List<Map<String, dynamic>?>>(
        _runBatchOnnxInference,
        {
          'imagesBytes': imagesBytes,
          'modelBytes': _modelBytes!,
          'labels': _labels,
        },
      );
      return results;
    } catch (e) {
      print('detectDiseases error: $e');
      return List.filled(imagePaths.length, null);
    }
  }

  /// Backwards compatibility untuk scan 1 gambar
  Future<Map<String, dynamic>?> detectDisease(String imagePath) async {
    final res = await detectDiseases([imagePath]);
    return res.isNotEmpty ? res.first : null;
  }

  void dispose() {}
}
