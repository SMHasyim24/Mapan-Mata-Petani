#!/usr/bin/env python3
"""
Fast Retraining Script: Rice Disease Classification
Model: Loading existing rice_disease_model.h5 and fine-tuning.

Usage:
    cd ml
    source venv/bin/activate
    python split_dataset.py      # Make sure to split the NEW dataset first
    python retrain_model.py      # Run this instead of train_model.py
    python convert_to_tfjs.py    # Convert to TF.js
"""

import sys
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

from PIL import ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True

import tensorflow as tf
import tensorflow.keras.backend as K
from tensorflow.keras.models import load_model
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau, ModelCheckpoint

# ============================================================
# Focal Loss Definition
# ============================================================
def focal_loss(gamma=2., alpha=0.25):
    def focal_loss_fixed(y_true, y_pred):
        y_pred = tf.clip_by_value(y_pred, K.epsilon(), 1.0 - K.epsilon())
        cross_entropy = -y_true * tf.math.log(y_pred)
        weight = alpha * tf.math.pow(1 - y_pred, gamma)
        loss = weight * cross_entropy
        return tf.reduce_sum(loss, axis=1)
    return focal_loss_fixed
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

# ============================================================
# Configuration
# ============================================================

IMG_SIZE = 224
BATCH_SIZE = 32   # Lebih kecil sedikit agar gradien Focal Loss stabil
EPOCHS = 5        # 5 epoch agar AI punya waktu belajar membedakan penyakit mirip (BPB vs Dead Heart)
LEARNING_RATE = 1e-5  # Sangat kecil (1e-5) agar model 88% tidak hancur, hanya beradaptasi
RANDOM_SEED = 42

CLASS_NAMES = [
    'Bacterial Leaf Blight',
    'Bacterial Leaf Streak',
    'Bacterial Panicle Blight',
    'Bakanae',
    'Blast',
    'Brown Spot',
    'Dead Heart',
    'Downy Mildew',
    'False Smut',
    'Grassy Stunt Virus',
    'Healthy',
    'Hispa',
    'Leaf Scald',
    'Leaf Smut',
    'Narrow Brown Leaf Spot',
    'Neck Blast',
    'Ragged Stunt Virus',
    'Sheath Blight',
    'Sheath Rot',
    'Stem Rot',
    'Tungro',
]

NUM_CLASSES = len(CLASS_NAMES)

SCRIPT_DIR = Path(__file__).parent
MODEL_DIR = SCRIPT_DIR / 'model'
OUTPUT_MODEL_PATH = MODEL_DIR / 'rice_disease_model.h5'
DATASET_DIR = SCRIPT_DIR / 'dataset_split'

# ============================================================
# Data Preparation
# ============================================================

def create_data_generators():
    train_dir = DATASET_DIR / 'train'
    val_dir = DATASET_DIR / 'val'
    test_dir = DATASET_DIR / 'test'

    for d in [train_dir, val_dir, test_dir]:
        if not d.exists():
            print(f"ERROR: Directory not found: {d}")
            sys.exit(1)

    import cv2
    import random

    def potato_camera_effect(image):
        # 1. 30% chance for Gaussian Blur (motion blur/out of focus)
        if random.random() < 0.3:
            k = random.choice([3, 5])
            image = cv2.GaussianBlur(image, (k, k), 0)
        
        # 2. 30% chance for ISO Noise (grainy sensor in low light)
        if random.random() < 0.3:
            noise = np.random.normal(loc=0, scale=15, size=image.shape)
            image = np.clip(image + noise, 0, 255)
            
        # 3. MobileNetV2 Preprocessing: scale [0, 255] to [-1, 1]
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

    print(f"\nLoading data from: {DATASET_DIR}")

    train_gen = train_datagen.flow_from_directory(
        str(train_dir),
        target_size=(IMG_SIZE, IMG_SIZE),
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        seed=RANDOM_SEED,
        shuffle=True,
    )

    val_gen = val_datagen.flow_from_directory(
        str(val_dir),
        target_size=(IMG_SIZE, IMG_SIZE),
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        seed=RANDOM_SEED,
        shuffle=False,
    )

    test_gen = val_datagen.flow_from_directory(
        str(test_dir),
        target_size=(IMG_SIZE, IMG_SIZE),
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        seed=RANDOM_SEED,
        shuffle=False,
    )

    return train_gen, val_gen, test_gen

# ============================================================
# Training
# ============================================================

def retrain_existing_model(train_gen, val_gen):
    if not OUTPUT_MODEL_PATH.exists():
        print(f"ERROR: Model lama tidak ditemukan di {OUTPUT_MODEL_PATH}")
        print("Anda harus menjalankan train_model.py dari awal dulu.")
        sys.exit(1)

    print("\n" + "=" * 60)
    print(f"Membuka Model Lama: {OUTPUT_MODEL_PATH}")
    print("=" * 60)
    
    # Custom loss function harus dipassing saat meload model
    model = load_model(
        str(OUTPUT_MODEL_PATH), 
        custom_objects={'focal_loss_fixed': focal_loss()}
    )
    
    # ================================================================
    # STRATEGI: TARGETED RETRAINING (OVERSAMPLED)
    #
    # Mempertahankan layer yang terbuka sebelumnya, tapi dilatih dengan
    # dataset yang sudah di-Oversample (Sheath Rot & Bacterial Panicle Blight).
    # ================================================================
    print("\nMembuka layer bagian atas MobileNetV2 untuk Targeted Retraining...")
    for layer in model.layers:
        layer.trainable = False
        if any(keyword in layer.name for keyword in ['block_15', 'block_16', 'Conv_1']):
            layer.trainable = True

    # Buka juga 3 layer Dense terakhir
    for layer in model.layers[-3:]:
        layer.trainable = True

    print("\nLayer yang dilatih:")
    for layer in model.layers:
        if layer.trainable:
            print(f"  [AKTIF] {layer.name} ({layer.count_params():,} params)")

    trainable_count = sum(p.numpy().size for p in model.trainable_weights)
    print(f"\nTotal parameter yang akan dilatih: {trainable_count:,}")

    # Gunakan Focal Loss pengganti Categorical Crossentropy & Class Weights
    model.compile(
        optimizer=Adam(learning_rate=LEARNING_RATE),
        loss=focal_loss(gamma=2.0, alpha=0.25),
        metrics=['accuracy'],
    )

    callbacks = [
        EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True, verbose=1),
        ReduceLROnPlateau(monitor='val_loss', factor=0.5, patience=2, min_lr=1e-6, verbose=1),
        ModelCheckpoint(str(OUTPUT_MODEL_PATH), monitor='val_accuracy', save_best_only=True, verbose=1),
    ]

    print("\n" + "=" * 60)
    print(f"TARGETED RETRAINING (Maksimal {EPOCHS} Epochs) - OVERSAMPLED DATA")
    print("=" * 60)

    history = model.fit(
        train_gen, 
        epochs=EPOCHS, 
        validation_data=val_gen, 
        callbacks=callbacks, 
        verbose=1
    )

    return model, history

# ============================================================
# Evaluation
# ============================================================

def evaluate_model(model, test_gen):
    print("\n" + "=" * 60)
    print("Evaluating on TEST set...")
    print("=" * 60)

    loss, accuracy = model.evaluate(test_gen, verbose=1)
    print(f"\nTest Loss: {loss:.4f}")
    print(f"Test Accuracy: {accuracy:.4f} ({accuracy * 100:.2f}%)")

    test_gen.reset()
    predictions = model.predict(test_gen, verbose=1)
    predicted_classes = np.argmax(predictions, axis=1)
    true_classes = test_gen.classes

    class_labels = list(test_gen.class_indices.keys())
    print("\nClassification Report:")
    print(classification_report(true_classes, predicted_classes, target_names=class_labels))

    return true_classes, predicted_classes, class_labels

def plot_confusion_matrix(true_classes, predicted_classes, class_labels):
    cm = confusion_matrix(true_classes, predicted_classes)

    plt.figure(figsize=(14, 12))
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=class_labels, yticklabels=class_labels)
    plt.title('Confusion Matrix (After Retraining)')
    plt.xlabel('Predicted')
    plt.ylabel('True')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(str(MODEL_DIR / 'confusion_matrix_retrained.png'), dpi=150)
    plt.close()
    print(f"Confusion matrix saved: {MODEL_DIR / 'confusion_matrix_retrained.png'}")

# ============================================================
# Main
# ============================================================

def main():
    print("=" * 60)
    print("Rice Disease - FAST RETRAINING SCRIPT")
    print("=" * 60)

    train_gen, val_gen, test_gen = create_data_generators()
    model, history = retrain_existing_model(train_gen, val_gen)
    true_classes, predicted_classes, class_labels = evaluate_model(model, test_gen)
    plot_confusion_matrix(true_classes, predicted_classes, class_labels)

    print(f"\nModel berhasil diupdate: {OUTPUT_MODEL_PATH}")
    print("Next: python convert_to_tfjs.py")

if __name__ == '__main__':
    main()
