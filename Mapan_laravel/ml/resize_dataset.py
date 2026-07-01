import os
from PIL import Image
from concurrent.futures import ThreadPoolExecutor

SRC_DIR = 'dataset_split'
DST_DIR = 'dataset_split_small'
TARGET_SIZE = (224, 224)

# Create destination directory structure
for root, dirs, files in os.walk(SRC_DIR):
    rel_path = os.path.relpath(root, SRC_DIR)
    dst_path = os.path.join(DST_DIR, rel_path)
    os.makedirs(dst_path, exist_ok=True)

# Gather all image files
image_files = []
for root, dirs, files in os.walk(SRC_DIR):
    for f in files:
        if f.lower().endswith(('.jpg', '.jpeg', '.png')):
            src = os.path.join(root, f)
            rel_path = os.path.relpath(src, SRC_DIR)
            dst = os.path.join(DST_DIR, rel_path)
            
            # Change extension to .jpg for uniformity
            dst = os.path.splitext(dst)[0] + '.jpg'
            image_files.append((src, dst))

total_images = len(image_files)
print(f"Mulai me-resize {total_images} gambar ke {TARGET_SIZE}...")

def process_image(paths):
    src, dst = paths
    try:
        if not os.path.exists(dst):
            with Image.open(src) as img:
                if img.mode != 'RGB':
                    img = img.convert('RGB')
                img = img.resize(TARGET_SIZE, Image.Resampling.LANCZOS)
                img.save(dst, format='JPEG', quality=85)
        return True
    except Exception as e:
        print(f"Error pada {src}: {e}")
        return False

# Gunakan ThreadPoolExecutor untuk mempercepat proses (I/O bound)
processed = 0
with ThreadPoolExecutor(max_workers=8) as executor:
    for result in executor.map(process_image, image_files):
        processed += 1
        if processed % 1000 == 0:
            print(f"Selesai me-resize {processed}/{total_images} gambar...")

print(f"SELESAI! Semua gambar telah di-resize ke {DST_DIR}")
