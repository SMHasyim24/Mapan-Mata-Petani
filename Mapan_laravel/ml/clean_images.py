import os
from pathlib import Path
from PIL import Image

def clean_directory(directory):
    print(f"Scanning {directory} for corrupted images...")
    bad_files = []
    
    # Menelusuri semua file di dalam folder
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                filepath = os.path.join(root, file)
                try:
                    # Membuka dan memverifikasi gambar
                    with Image.open(filepath) as img:
                        img.verify()
                except Exception as e:
                    # Jika error, catat file tersebut
                    bad_files.append(filepath)
    
    # Menghapus file-file rusak
    for bad_file in bad_files:
        print(f"Menghapus file rusak: {bad_file}")
        try:
            os.remove(bad_file)
        except Exception as e:
            print(f"Gagal menghapus {bad_file}: {e}")
            
    print(f"Selesai! Berhasil menghapus {len(bad_files)} gambar rusak/corrupt.")

def remove_augmented_images(directory, prefix='aug'):
    print(f"\n--- Scanning {directory} untuk menghapus file augmentasi ('{prefix}') ---")
    count = 0
    if not os.path.exists(directory):
        return
    for root, _, files in os.walk(directory):
        for file in files:
            # Mengecek apakah nama file berawalan 'aug' (huruf besar/kecil)
            if file.lower().startswith(prefix.lower()):
                filepath = os.path.join(root, file)
                try:
                    os.remove(filepath)
                    count += 1
                    # print(f"Menghapus: {file}") # Dihilangkan agar terminal tidak terlalu penuh
                except Exception as e:
                    print(f"Gagal menghapus {file}: {e}")
    print(f"Selesai! Berhasil menghapus {count} file augmentasi dari {directory}.")

if __name__ == "__main__":
    print("Memulai proses pembersihan dataset...\n")
    
    # 1. Hapus gambar augmentasi yang menyebabkan Data Leakage
    remove_augmented_images("dataset", prefix="aug")
    remove_augmented_images("dataset_split", prefix="aug")
    
    print("\n------------------------------------------------\n")
    
    # 2. Hapus gambar corrupt (fungsi bawaan Anda)
    if os.path.exists("dataset"):
        clean_directory("dataset")
    if os.path.exists("dataset_split"):
        clean_directory("dataset_split")
