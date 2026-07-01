import os
import glob
import numpy as np
from pathlib import Path
from tensorflow.keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img

SCRIPT_DIR = Path(__file__).parent
TRAIN_DIR = SCRIPT_DIR / 'dataset_split' / 'train'
LEAF_SMUT_DIR = TRAIN_DIR / 'Leaf Smut'

TARGET_COUNT = 1500

def remove_old_augmentations():
    """Menghapus gambar augmentasi lama agar kita mulai dari gambar asli."""
    print("Menghapus augmentasi lama...")
    aug_files = glob.glob(str(LEAF_SMUT_DIR / "*_aug_*.jpg")) + glob.glob(str(LEAF_SMUT_DIR / "*_deepaug_*.jpg"))
    for f in aug_files:
        try:
            os.remove(f)
        except Exception:
            pass
    print(f"Dihapus {len(aug_files)} gambar lama.")

def main():
    print("=" * 60)
    print("DEEP AUGMENTATION: LEAF SMUT")
    print("=" * 60)
    
    if not LEAF_SMUT_DIR.exists():
        print(f"ERROR: {LEAF_SMUT_DIR} tidak ditemukan!")
        return

    remove_old_augmentations()
    
    # Ambil gambar asli
    original_images = glob.glob(str(LEAF_SMUT_DIR / "*.jpg")) + glob.glob(str(LEAF_SMUT_DIR / "*.JPG")) + glob.glob(str(LEAF_SMUT_DIR / "*.jpeg"))
    current_count = len(original_images)
    
    print(f"Jumlah gambar asli Leaf Smut di folder train: {current_count}")
    if current_count == 0:
        print("Tidak ada gambar asli!")
        return

    needed = TARGET_COUNT - current_count
    if needed <= 0:
        print("Sudah memenuhi target.")
        return

    print(f"Membutuhkan {needed} gambar tambahan. Memulai augmentasi spasial Keras...")
    
    # Konfigurasi Augmentasi Keras sesuai permintaan user (Flip, Rotate, Zoom, Contrast/Brightness)
    datagen = ImageDataGenerator(
        rotation_range=90,          # Putaran agresif
        width_shift_range=0.3,      # Geser horizontal
        height_shift_range=0.3,     # Geser vertikal
        shear_range=0.2,            # Geser diagonal
        zoom_range=0.4,             # Zoom in/out
        horizontal_flip=True,       # Balik horizontal
        vertical_flip=True,         # Balik vertikal
        fill_mode='reflect',        # Mengisi area kosong saat diputar dengan refleksi gambar
        brightness_range=[0.5, 1.5] # Pencahayaan 50% lebih gelap hingga 50% lebih terang
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
                for batch in datagen.flow(x, batch_size=1, save_to_dir=str(LEAF_SMUT_DIR), save_prefix=f"{base_name}_deepaug", save_format='jpeg'):
                    success_count += 1
                    if success_count % 100 == 0:
                        print(f"  Diperbanyak: {success_count}/{needed}")
                    break # Hanya ambil 1 variasi per gambar dalam iterasi ini, lalu lanjut ke gambar berikutnya agar merata
            except Exception as e:
                print(f"Error pada {img_path}: {e}")

    final_count = len(glob.glob(str(LEAF_SMUT_DIR / "*.jpg")) + glob.glob(str(LEAF_SMUT_DIR / "*.JPG")) + glob.glob(str(LEAF_SMUT_DIR / "*.jpeg")))
    print(f"[SELESAI] Leaf Smut sekarang memiliki {final_count} gambar di folder train.")

if __name__ == '__main__':
    main()
