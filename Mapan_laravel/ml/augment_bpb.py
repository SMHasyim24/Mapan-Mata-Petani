import os
import glob
import numpy as np
from pathlib import Path
from tensorflow.keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img

SCRIPT_DIR = Path(__file__).parent
TRAIN_DIR = SCRIPT_DIR / 'dataset_split' / 'train'
BPB_DIR = TRAIN_DIR / 'Bacterial Panicle Blight'

TARGET_COUNT = 1500

def remove_old_augmentations():
    """Menghapus gambar augmentasi lama agar kita mulai dari gambar asli."""
    print("Menghapus augmentasi lama...")
    aug_files = glob.glob(str(BPB_DIR / "*_aug_*.jpg"))
    for f in aug_files:
        os.remove(f)
    print(f"Dihapus {len(aug_files)} gambar lama.")

def main():
    print("=" * 60)
    print("DEEP AUGMENTATION: BACTERIAL PANICLE BLIGHT")
    print("=" * 60)
    
    if not BPB_DIR.exists():
        print(f"ERROR: {BPB_DIR} tidak ditemukan!")
        return

    remove_old_augmentations()
    
    # Ambil gambar asli
    original_images = glob.glob(str(BPB_DIR / "*.jpg")) + glob.glob(str(BPB_DIR / "*.JPG"))
    current_count = len(original_images)
    
    print(f"Jumlah gambar asli BPB: {current_count}")
    if current_count == 0:
        print("Tidak ada gambar asli!")
        return

    needed = TARGET_COUNT - current_count
    if needed <= 0:
        print("Sudah memenuhi target.")
        return

    print(f"Membutuhkan {needed} gambar tambahan. Memulai augmentasi spasial Keras...")
    
    # Konfigurasi Augmentasi Keras yang lebih agresif (Rotasi, Zoom, Geser)
    datagen = ImageDataGenerator(
        rotation_range=40,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.3,
        horizontal_flip=True,
        fill_mode='nearest',
        brightness_range=[0.8, 1.2]
    )

    success_count = 0
    
    # Looping sampai mencapai target
    while success_count < needed:
        for img_path in original_images:
            if success_count >= needed:
                break
                
            try:
                img = load_img(img_path)
                x = img_to_array(img)
                x = x.reshape((1,) + x.shape)
                
                # Prefix nama berdasarkan gambar asli
                base_name = Path(img_path).stem
                
                # .flow() menghasilkan batch gambar yang sudah dimodifikasi
                i = 0
                for batch in datagen.flow(x, batch_size=1, save_to_dir=str(BPB_DIR), save_prefix=f"{base_name}_deepaug", save_format='jpeg'):
                    i += 1
                    success_count += 1
                    if success_count % 100 == 0:
                        print(f"  Diperbanyak: {success_count}/{needed}")
                    break # Hanya ambil 1 variasi per gambar dalam iterasi ini, lalu lanjut ke gambar berikutnya agar merata
            except Exception as e:
                print(f"Error pada {img_path}: {e}")

    final_count = len(glob.glob(str(BPB_DIR / "*.jpg")) + glob.glob(str(BPB_DIR / "*.JPG")) + glob.glob(str(BPB_DIR / "*.jpeg")))
    print(f"[SELESAI] BPB sekarang memiliki {final_count} gambar.")

if __name__ == '__main__':
    main()
