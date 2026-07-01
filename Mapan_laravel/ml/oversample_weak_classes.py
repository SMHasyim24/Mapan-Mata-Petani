#!/usr/bin/env python3
import os
import glob
import random
import shutil
from pathlib import Path
from PIL import Image, ImageEnhance, ImageOps

SCRIPT_DIR = Path(__file__).parent
TRAIN_DIR = SCRIPT_DIR / 'dataset_split' / 'train'

WEAK_CLASSES = {
    # Kelas dengan data sangat sedikit (80 gambar) → target 500
    'Bakanae': 500,
    'Grassy Stunt Virus': 500,
    'Ragged Stunt Virus': 500,
    'Stem Rot': 500,
    # Kelas dengan data sedang → target 700
    'False Smut': 700,
    'Downy Mildew': 700,
    'Sheath Blight': 700,
    # Kelas yang sudah di-oversample sebelumnya (tetap dipertahankan)
    'Bacterial Panicle Blight': 700,
    'Sheath Rot': 700,
}

def augment_image(img_path, output_path):
    try:
        with Image.open(img_path) as img:
            img = img.convert('RGB')
            
            # Random augmentations
            # 1. Flip
            if random.random() > 0.5:
                img = ImageOps.mirror(img)
            
            # 2. Brightness
            enhancer = ImageEnhance.Brightness(img)
            img = enhancer.enhance(random.uniform(0.7, 1.3))
            
            # 3. Contrast (khususnya untuk Blast agar bercaknya lebih jelas)
            enhancer = ImageEnhance.Contrast(img)
            img = enhancer.enhance(random.uniform(1.0, 1.5))
            
            # 4. Color
            enhancer = ImageEnhance.Color(img)
            img = enhancer.enhance(random.uniform(0.8, 1.2))
            
            img.save(output_path, 'JPEG', quality=95)
            return True
    except Exception as e:
        print(f"Error processing {img_path}: {e}")
        return False

def main():
    print("=" * 60)
    print("OVERSAMPLING WEAK CLASSES")
    print("=" * 60)
    
    if not TRAIN_DIR.exists():
        print(f"ERROR: {TRAIN_DIR} tidak ditemukan!")
        return

    for cls, target in WEAK_CLASSES.items():
        cls_dir = TRAIN_DIR / cls
        if not cls_dir.exists():
            print(f"Melewati {cls} (Folder tidak ada)")
            continue
            
        images = glob.glob(str(cls_dir / "*.jpg")) + glob.glob(str(cls_dir / "*.JPG")) + glob.glob(str(cls_dir / "*.jpeg")) + glob.glob(str(cls_dir / "*.JPEG"))
        current_count = len(images)
        
        print(f"\nKelas: {cls}")
        print(f"Jumlah saat ini: {current_count}")
        
        if current_count >= target:
            print("Sudah mencapai target, tidak perlu oversampling.")
            continue
            
        needed = target - current_count
        print(f"Kekurangan: {needed} gambar. Memulai augmentasi...")
        
        success_count = 0
        while success_count < needed:
            # Pilih gambar asli secara acak
            src_img = random.choice(images)
            src_name = Path(src_img).stem
            # Hindari nama file kepanjangan jika berkali-kali di-augment
            if "_aug_" in src_name:
                base_name = src_name.split("_aug_")[0]
            else:
                base_name = src_name
                
            out_name = f"{base_name}_aug_{success_count}.jpg"
            out_path = cls_dir / out_name
            
            if augment_image(src_img, out_path):
                success_count += 1
                if success_count % 50 == 0:
                    print(f"  Diperbanyak: {success_count}/{needed}")
                    
        print(f"[SELESAI] {cls} sekarang memiliki {current_count + success_count} gambar.")

if __name__ == '__main__':
    main()
