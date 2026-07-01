import ftplib
import os
from PIL import Image

# Konfigurasi FTP (Dataset Baru)
FTP_HOST = "ftp.scidb.cn"
FTP_PORT = 2121
FTP_USER = "bY7zEb"
FTP_PASS = "bENbue"

# Folder tujuan
DOWNLOAD_DIR = "dataset/false_smut"
MAX_IMAGES = 250  # Batas maksimal gambar yang didownload

if not os.path.exists(DOWNLOAD_DIR):
    os.makedirs(DOWNLOAD_DIR)

print(f"Menghubungkan ke FTP {FTP_HOST}:{FTP_PORT}...")
try:
    ftp = ftplib.FTP()
    ftp.connect(FTP_HOST, FTP_PORT)
    ftp.login(FTP_USER, FTP_PASS)
    print("Berhasil login! Mengambil daftar file...")

    # Ambil daftar file menggunakan perintah LIST
    lines = []
    ftp.retrlines('LIST', lines.append)
    
    # Parsing output LIST untuk mendapatkan nama file
    files = []
    for line in lines:
        parts = line.split()
        if len(parts) > 8:
            filename = " ".join(parts[8:])
            files.append(filename)
    
    # Filter file gambar dan BATASI HANYA 250 GAMBAR
    image_files = [f for f in files if f.lower().endswith(('.jpg', '.jpeg', '.png', '.zip', '.rar'))]
    
    if len(image_files) > MAX_IMAGES:
        print(f"Ditemukan {len(image_files)} file gambar. Membatasi hanya {MAX_IMAGES} gambar pertama.")
        image_files = image_files[:MAX_IMAGES]
    else:
        print(f"Ditemukan {len(image_files)} file gambar untuk didownload.")
    
    for i, filename in enumerate(image_files, 1):
        local_filepath = os.path.join(DOWNLOAD_DIR, filename)
        
        # Cek jika file sudah ada dan ukurannya lebih dari 0
        if os.path.exists(local_filepath) and os.path.getsize(local_filepath) > 0:
            print(f"[{i}/{len(image_files)}] Skip: {filename} (sudah didownload)")
            continue
            
        print(f"[{i}/{len(image_files)}] Mendownload: {filename}...")
        
        try:
            with open(local_filepath, 'wb') as local_file:
                ftp.retrbinary(f"RETR {filename}", local_file.write)
            
            # Kompresi gambar setelah didownload untuk mengurangi ukuran
            try:
                with Image.open(local_filepath) as img:
                    # Resize setengah ukuran jika resolusi terlalu besar (opsional)
                    # width, height = img.size
                    # img = img.resize((width // 2, height // 2), Image.Resampling.LANCZOS)
                    
                    # Simpan kembali dengan kualitas 60 untuk mengurangi ukuran MB
                    img.save(local_filepath, "JPEG", optimize=True, quality=50)
            except Exception as e:
                print(f"Gagal mengkompres {filename}: {e}")

        except Exception as e:
            print(f"Koneksi terputus saat mendownload {filename}, menyambung kembali... ({e})")
            # Coba reconnect
            ftp = ftplib.FTP()
            ftp.connect(FTP_HOST, FTP_PORT)
            ftp.login(FTP_USER, FTP_PASS)
            # Ulangi download dan kompresi
            with open(local_filepath, 'wb') as local_file:
                ftp.retrbinary(f"RETR {filename}", local_file.write)
            try:
                with Image.open(local_filepath) as img:
                    img.save(local_filepath, "JPEG", optimize=True, quality=50)
            except:
                pass
            
    print("\nSelesai! Semua file berhasil didownload ke folder:", DOWNLOAD_DIR)
    ftp.quit()

except Exception as e:
    print(f"Terjadi kesalahan: {e}")
