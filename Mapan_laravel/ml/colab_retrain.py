# ============================================================
# 🌾 MAPAN - Rice Disease Retraining (Google Colab Version)
# ============================================================
# CARA PAKAI:
# 1. Buka Google Colab (colab.research.google.com)
# 2. Buat notebook baru
# 3. Pastikan Runtime > Change runtime type > GPU (T4)
# 4. Copy-paste SETIAP CELL di bawah ke cell terpisah di Colab
# 5. Jalankan satu per satu dari atas ke bawah
# ============================================================

# ====================== CELL 1 ======================
# Mount Google Drive & Upload Data
from google.colab import drive
drive.mount('/content/drive')

# ====================== CELL 2 ======================
# Unzip dataset dari Google Drive
# PENTING: Upload file "mapan_training_small.zip" dan "rice_disease_model_88_backup.h5"
# ke folder "My Drive" di Google Drive Anda SEBELUM menjalankan cell ini!
import os
import zipfile

DRIVE_PATH = '/content/drive/MyDrive'
WORK_DIR = '/content/mapan_ml'

os.makedirs(WORK_DIR, exist_ok=True)

# Unzip dataset
zip_path = f'{DRIVE_PATH}/mapan_training_small.zip'
print(f'Mengekstrak {zip_path}...')
with zipfile.ZipFile(zip_path, 'r') as z:
    z.extractall(WORK_DIR)
print('Dataset berhasil diekstrak!')

# Copy model backup
import shutil
model_src = f'{DRIVE_PATH}/rice_disease_model_88_backup.h5'
model_dst = f'{WORK_DIR}/rice_disease_model.h5'
shutil.copy2(model_src, model_dst)
print(f'Model backup berhasil disalin ke {model_dst}')

# Verifikasi
for split in ['train', 'val', 'test']:
    split_dir = f'{WORK_DIR}/dataset_split_small/{split}'
    if os.path.exists(split_dir):
        classes = os.listdir(split_dir)
        total = sum(len(os.listdir(f'{split_dir}/{c}')) for c in classes)
        print(f'{split}: {len(classes)} kelas, {total} gambar')

# ====================== CELL 3 ======================
# Konfigurasi & Import
import sys
import numpy as np
import matplotlib.pyplot as plt
import cv2
import random

from PIL import ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True

import tensorflow as tf
import tensorflow.keras.backend as K
from tensorflow.keras.models import load_model
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau, ModelCheckpoint
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

# Cek GPU
print(f'TensorFlow version: {tf.__version__}')
print(f'GPU tersedia: {tf.config.list_physical_devices("GPU")}')

WORK_DIR = '/content/mapan_ml'
IMG_SIZE = 224
BATCH_SIZE = 32
EPOCHS = 5
LEARNING_RATE = 1e-5
RANDOM_SEED = 42

CLASS_NAMES = [
    'Bacterial Leaf Blight', 'Bacterial Leaf Streak', 'Bacterial Panicle Blight',
    'Bakanae', 'Blast', 'Brown Spot', 'Dead Heart', 'Downy Mildew',
    'False Smut', 'Grassy Stunt Virus', 'Healthy', 'Hispa',
    'Leaf Scald', 'Leaf Smut', 'Narrow Brown Leaf Spot', 'Neck Blast',
    'Ragged Stunt Virus', 'Sheath Blight', 'Sheath Rot', 'Stem Rot', 'Tungro',
]
NUM_CLASSES = len(CLASS_NAMES)
print(f'Jumlah kelas: {NUM_CLASSES}')

# ====================== CELL 4 ======================
# Focal Loss & Data Generators

def focal_loss(gamma=2., alpha=0.25):
    def focal_loss_fixed(y_true, y_pred):
        y_pred = tf.clip_by_value(y_pred, K.epsilon(), 1.0 - K.epsilon())
        cross_entropy = -y_true * tf.math.log(y_pred)
        weight = alpha * tf.math.pow(1 - y_pred, gamma)
        loss = weight * cross_entropy
        return tf.reduce_sum(loss, axis=1)
    return focal_loss_fixed

def potato_camera_effect(image):
    """Simulasi kamera HP murah: blur + noise"""
    if random.random() < 0.3:
        k = random.choice([3, 5])
        image = cv2.GaussianBlur(image, (k, k), 0)
    if random.random() < 0.3:
        noise = np.random.normal(loc=0, scale=15, size=image.shape)
        image = np.clip(image + noise, 0, 255)
    return (image / 127.5) - 1.0

train_datagen = ImageDataGenerator(
    preprocessing_function=potato_camera_effect,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    horizontal_flip=True,
    vertical_flip=True,
    zoom_range=0.2,
    brightness_range=[0.8, 1.2],
    fill_mode='nearest',
)

val_datagen = ImageDataGenerator(
    preprocessing_function=lambda x: (x / 127.5) - 1.0,
)

train_gen = train_datagen.flow_from_directory(
    f'{WORK_DIR}/dataset_split_small/train',
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    seed=RANDOM_SEED, shuffle=True,
)

val_gen = val_datagen.flow_from_directory(
    f'{WORK_DIR}/dataset_split_small/val',
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    seed=RANDOM_SEED, shuffle=False,
)

test_gen = val_datagen.flow_from_directory(
    f'{WORK_DIR}/dataset_split_small/test',
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    seed=RANDOM_SEED, shuffle=False,
)

print(f'\nTrain: {train_gen.samples} gambar')
print(f'Val:   {val_gen.samples} gambar')
print(f'Test:  {test_gen.samples} gambar')

# ====================== CELL 5 ======================
# Load Model & Targeted Retraining (5 Epoch dengan GPU!)

model = load_model(
    f'{WORK_DIR}/rice_disease_model.h5',
    custom_objects={'focal_loss_fixed': focal_loss()}
)

# Freeze semua, buka hanya layer atas
for layer in model.layers:
    layer.trainable = False
    if any(kw in layer.name for kw in ['block_15', 'block_16', 'Conv_1']):
        layer.trainable = True

for layer in model.layers[-3:]:
    layer.trainable = True

print('Layer yang dilatih:')
for layer in model.layers:
    if layer.trainable:
        print(f'  [AKTIF] {layer.name} ({layer.count_params():,} params)')

model.compile(
    optimizer=Adam(learning_rate=LEARNING_RATE),
    loss=focal_loss(gamma=2.0, alpha=0.25),
    metrics=['accuracy'],
)

callbacks = [
    EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True, verbose=1),
    ReduceLROnPlateau(monitor='val_loss', factor=0.5, patience=2, min_lr=1e-6, verbose=1),
    ModelCheckpoint(f'{WORK_DIR}/rice_disease_model.h5', monitor='val_accuracy', save_best_only=True, verbose=1),
]

print('\n' + '=' * 60)
print(f'TRAINING DIMULAI! (5 Epoch dengan GPU)')
print('=' * 60)

history = model.fit(
    train_gen,
    epochs=EPOCHS,
    validation_data=val_gen,
    callbacks=callbacks,
    verbose=1
)

# ====================== CELL 6 ======================
# Evaluasi & Confusion Matrix

print('\n' + '=' * 60)
print('EVALUASI pada TEST SET...')
print('=' * 60)

loss, accuracy = model.evaluate(test_gen, verbose=1)
print(f'\nTest Loss: {loss:.4f}')
print(f'Test Accuracy: {accuracy:.4f} ({accuracy * 100:.2f}%)')

test_gen.reset()
predictions = model.predict(test_gen, verbose=1)
predicted_classes = np.argmax(predictions, axis=1)
true_classes = test_gen.classes
class_labels = list(test_gen.class_indices.keys())

print('\nClassification Report:')
print(classification_report(true_classes, predicted_classes, target_names=class_labels))

# Plot Confusion Matrix
cm = confusion_matrix(true_classes, predicted_classes)
plt.figure(figsize=(16, 14))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=class_labels, yticklabels=class_labels)
plt.title(f'Confusion Matrix (After Retraining) - Accuracy: {accuracy*100:.2f}%')
plt.xlabel('Predicted')
plt.ylabel('True')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig(f'{WORK_DIR}/confusion_matrix_retrained.png', dpi=150)
plt.show()
print('Confusion Matrix ditampilkan di atas!')

# ====================== CELL 7 ======================
# SIMPAN HASIL KE GOOGLE DRIVE
import shutil

DRIVE_PATH = '/content/drive/MyDrive'
WORK_DIR = '/content/mapan_ml'

# Copy model hasil training ke Google Drive
shutil.copy2(f'{WORK_DIR}/rice_disease_model.h5', f'{DRIVE_PATH}/rice_disease_model_NEW.h5')
shutil.copy2(f'{WORK_DIR}/confusion_matrix_retrained.png', f'{DRIVE_PATH}/confusion_matrix_retrained_NEW.png')

print('=' * 60)
print('✅ SELESAI! File tersimpan di Google Drive Anda:')
print(f'  📁 {DRIVE_PATH}/rice_disease_model_NEW.h5')
print(f'  📁 {DRIVE_PATH}/confusion_matrix_retrained_NEW.png')
print('=' * 60)
print()
print('LANGKAH SELANJUTNYA:')
print('1. Download "rice_disease_model_NEW.h5" dari Google Drive ke laptop')
print('2. Taruh di folder: tugas_uts_pcs/ml/model/')
print('3. Jalankan di laptop: python convert_to_onnx.py')
print('4. Copy file .onnx ke folder Flutter assets/models/')
