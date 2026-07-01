import os
import tensorflow as tf
import tf2onnx
from pathlib import Path

def main():
    print("=" * 60)
    print("  Keras to ONNX Converter")
    print("=" * 60)

    # Path setup
    model_path = Path("model/rice_disease_model.h5")
    output_dir = Path("../public/models/rice-disease")
    output_path = output_dir / "model.onnx"

    if not model_path.exists():
        print(f"ERROR: Model not found at {model_path}")
        return

    # Buat folder output jika belum ada
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"1. Memuat Keras model dari: {model_path}")
    
    # Fix kompatibilitas Keras 3 (Colab) -> Keras 2 (Lokal)
    from tensorflow.keras.layers import DepthwiseConv2D
    class CustomDepthwiseConv2D(DepthwiseConv2D):
        def __init__(self, **kwargs):
            kwargs.pop('groups', None)
            super().__init__(**kwargs)
    
    model = tf.keras.models.load_model(
        model_path, compile=False,
        custom_objects={'DepthwiseConv2D': CustomDepthwiseConv2D}
    )

    print("2. Mengonversi ke format ONNX...")
    # opset 13-15 adalah versi standar yang sangat stabil untuk MobileNetV2
    onnx_model, _ = tf2onnx.convert.from_keras(model, opset=13)

    print(f"3. Menyimpan ONNX model ke: {output_path}")
    with open(output_path, "wb") as f:
        f.write(onnx_model.SerializeToString())

    print(f"\nSelesai! Model berhasil dikonversi ke ONNX ({output_path.stat().st_size / (1024*1024):.2f} MB)")
    print("Website Anda sekarang siap digunakan!")

if __name__ == "__main__":
    main()
