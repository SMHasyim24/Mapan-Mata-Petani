import os
import random
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from pathlib import Path
import tensorflow.keras.backend as K

def focal_loss(gamma=2., alpha=0.25):
    def focal_loss_fixed(y_true, y_pred):
        y_pred = tf.clip_by_value(y_pred, K.epsilon(), 1.0 - K.epsilon())
        cross_entropy = -y_true * tf.math.log(y_pred)
        weight = alpha * tf.math.pow(1 - y_pred, gamma)
        loss = weight * cross_entropy
        return tf.reduce_sum(loss, axis=1)
    return focal_loss_fixed

# Configuration
SCRIPT_DIR = Path(__file__).parent
MODEL_PATH = SCRIPT_DIR / 'model' / 'rice_disease_model_fixed.h5'
TEST_DIR = SCRIPT_DIR / 'dataset_split' / 'test'
IMG_SIZE = 224

CLASS_NAMES = sorted([d.name for d in TEST_DIR.iterdir() if d.is_dir()])

def preprocess_image(img_path):
    img = load_img(img_path, target_size=(IMG_SIZE, IMG_SIZE))
    img_array = img_to_array(img)
    # Same preprocessing as validation generator in retrain_model.py
    img_array = (img_array / 127.5) - 1.0
    return np.expand_dims(img_array, axis=0)

def main():
    print("=" * 50)
    print("Loading Model...")
    model = load_model(str(MODEL_PATH), compile=False)
    print("Model Loaded!")
    
    print("\nMemilih 5 gambar acak dari dataset test untuk simulasi...\n")
    print("=" * 60)
    print(f"{'GAMBAR ASLI (BENAR)':<25} | {'PREDIKSI MODEL':<25} | {'CONFIDENCE':<10}")
    print("-" * 60)
    
    # Pick 5 random classes
    random_classes = random.sample(CLASS_NAMES, 5)
    
    correct_count = 0
    
    for cls in random_classes:
        cls_dir = TEST_DIR / cls
        images = list(cls_dir.glob('*.jpg')) + list(cls_dir.glob('*.png'))
        if not images:
            continue
        
        img_path = random.choice(images)
        img_tensor = preprocess_image(str(img_path))
        
        predictions = model.predict(img_tensor, verbose=0)
        predicted_idx = np.argmax(predictions[0])
        predicted_class = CLASS_NAMES[predicted_idx]
        confidence = np.max(predictions[0]) * 100
        
        if cls == predicted_class:
            correct_count += 1
            marker = "✅"
        else:
            marker = "❌"
            
        print(f"{cls:<25} | {predicted_class:<25} | {confidence:.2f}% {marker}")
        
    print("=" * 60)
    print(f"Akurasi Sampel Acak: {correct_count}/5 ({correct_count/5 * 100:.0f}%)")
    print("=" * 60)

if __name__ == '__main__':
    main()
