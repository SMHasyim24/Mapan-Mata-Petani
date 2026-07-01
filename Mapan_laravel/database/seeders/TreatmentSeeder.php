<?php

namespace Database\Seeders;

use App\Models\Disease;
use App\Models\Treatment;
use Illuminate\Database\Seeder;

class TreatmentSeeder extends Seeder
{
    public function run(): void
    {
        $treatments = [
            // ===== BLAST =====
            'blast' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Tricyclazole 75 WP', 'dosage' => '0.6', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Isoprothiolane 40 EC', 'dosage' => '2', 'dosage_unit' => 'ml/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Gunakan varietas tahan blast (Inpari 33, Ciherang)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Kurangi pemupukan nitrogen berlebihan', 'dosage' => '250', 'dosage_unit' => 'kg urea/ha (maks)', 'priority' => 2],
                ['type' => 'biological', 'description' => 'Aplikasi Trichoderma sp. sebagai biofungisida', 'dosage' => '5', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Sanitasi lahan dan pergiliran varietas', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== BROWN SPOT =====
            'brown-spot' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Mancozeb 80 WP', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Propiconazole 250 EC', 'dosage' => '1', 'dosage_unit' => 'ml/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Pemupukan berimbang NPK', 'dosage' => '300', 'dosage_unit' => 'kg NPK/ha', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Perbaiki drainase dan tingkatkan bahan organik tanah', 'dosage' => '2000', 'dosage_unit' => 'kg kompos/ha', 'priority' => 1],
            ],
            // ===== TUNGRO =====
            'tungro' => [
                ['type' => 'chemical', 'description' => 'Pengendalian wereng hijau dengan BPMC 50 EC', 'dosage' => '1.5', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Aplikasi Imidakloprid 200 SL', 'dosage' => '0.5', 'dosage_unit' => 'ml/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Gunakan varietas tahan tungro (Inpari 9, Tukad Unda)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Eradikasi tanaman terinfeksi dan tanam serempak', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== BLB =====
            'bacterial-leaf-blight' => [
                ['type' => 'chemical', 'description' => 'Aplikasi bakterisida Streptomycin sulfat', 'dosage' => '1.5', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan tembaga hidroksida 77 WP', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Gunakan varietas tahan BLB (Code, Angke, Inpari 13)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Atur drainase dan kurangi nitrogen berlebihan', 'dosage' => '200', 'dosage_unit' => 'kg urea/ha (maks)', 'priority' => 1],
            ],
            // ===== HEALTHY =====
            'healthy' => [
                ['type' => 'prevention', 'description' => 'Lanjutkan pemeliharaan rutin dan pemupukan berimbang', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Monitoring rutin setiap 7 hari untuk deteksi dini', 'dosage' => null, 'dosage_unit' => null, 'priority' => 2],
            ],
            // ===== HISPA =====
            'hispa' => [
                ['type' => 'chemical', 'description' => 'Aplikasi insektisida Karbofuran 3 GR pada pangkal tanaman', 'dosage' => '17', 'dosage_unit' => 'kg/ha', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan Chlorpyrifos 20 EC', 'dosage' => '2', 'dosage_unit' => 'ml/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Potong ujung daun yang terserang saat tanam', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'biological', 'description' => 'Pemanfaatan musuh alami (parasitoid Eulophidae)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Bersihkan gulma di sekitar sawah sebagai inang alternatif', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== DEAD HEART =====
            'dead-heart' => [
                ['type' => 'chemical', 'description' => 'Aplikasi Karbofuran 3 GR pada 7 HST', 'dosage' => '17', 'dosage_unit' => 'kg/ha', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan Fipronil 50 SC', 'dosage' => '1.5', 'dosage_unit' => 'ml/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Gunakan varietas tahan penggerek batang', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'biological', 'description' => 'Pelepasan parasitoid Trichogramma japonicum', 'dosage' => '100000', 'dosage_unit' => 'ekor/ha', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Cabut dan musnahkan tanaman yang menunjukkan gejala sundep', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== DOWNY MILDEW =====
            'downy-mildew' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Metalaksil 35 SD sebagai perlakuan benih', 'dosage' => '5', 'dosage_unit' => 'gram/kg benih', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan Mankozeb 80 WP pada fase vegetatif', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Gunakan benih bersertifikat bebas penyakit', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Perbaiki drainase sawah, hindari genangan berlebihan', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Eradikasi tanaman terinfeksi untuk mencegah penyebaran', 'dosage' => null, 'dosage_unit' => null, 'priority' => 2],
            ],
            // ===== BACTERIAL LEAF STREAK =====
            'bacterial-leaf-streak' => [
                ['type' => 'chemical', 'description' => 'Aplikasi bakterisida tembaga hidroksida', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan Streptomycin sulfat', 'dosage' => '1', 'dosage_unit' => 'gram/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Hindari irigasi berlebihan dan percikan air', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Kurangi kepadatan tanaman untuk sirkulasi udara', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== BACTERIAL PANICLE BLIGHT =====
            'bacterial-panicle-blight' => [
                ['type' => 'chemical', 'description' => 'Perlakuan benih dengan bakterisida sebelum tanam', 'dosage' => '3', 'dosage_unit' => 'gram/kg benih', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Aplikasi Oxolinic acid pada fase pembungaan', 'dosage' => '1', 'dosage_unit' => 'gram/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Gunakan benih sehat dan bersertifikat', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Hindari penanaman saat suhu sangat tinggi (>35°C)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 2],
                ['type' => 'cultural', 'description' => 'Atur waktu tanam agar pembungaan tidak bertepatan suhu puncak', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== LEAF SMUT =====
            'leaf-smut' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Propiconazole 250 EC', 'dosage' => '1', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan Mancozeb 80 WP', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 2],
                ['type' => 'prevention', 'description' => 'Pemupukan kalium yang cukup untuk ketahanan tanaman', 'dosage' => '100', 'dosage_unit' => 'kg KCl/ha', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Bersihkan sisa tanaman terinfeksi setelah panen', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== LEAF SCALD =====
            'leaf-scald' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Benomyl 50 WP', 'dosage' => '1', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Hindari pemupukan nitrogen berlebihan', 'dosage' => '200', 'dosage_unit' => 'kg urea/ha (maks)', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Gunakan jarak tanam yang lebih renggang (sistem legowo)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== NARROW BROWN LEAF SPOT =====
            'narrow-brown-leaf-spot' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Propiconazole', 'dosage' => '1', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Pastikan pemupukan Kalium (K) mencukupi', 'dosage' => '100', 'dosage_unit' => 'kg KCl/ha', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Gunakan varietas berumur genjah', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== SHEATH BLIGHT =====
            'sheath-blight' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Azoxystrobin', 'dosage' => '1', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'chemical', 'description' => 'Penyemprotan Validamycin A', 'dosage' => '2', 'dosage_unit' => 'ml/L', 'priority' => 2],
                ['type' => 'cultural', 'description' => 'Sanitasi gulma dan kurangi kelembaban lahan', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== BAKANAE =====
            'bakanae' => [
                ['type' => 'chemical', 'description' => 'Perlakuan benih (seed treatment) dengan fungisida Prochloraz atau Thiram', 'dosage' => '2', 'dosage_unit' => 'gram/kg benih', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Seleksi benih menggunakan larutan garam', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Cabut dan bakar tanaman yang tumbuh abnormal (roguing)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== RAGGED STUNT VIRUS =====
            'ragged-stunt-virus' => [
                ['type' => 'chemical', 'description' => 'Kendalikan vektor Wereng Batang Coklat dengan insektisida BPMC/Buprofezin', 'dosage' => '2', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Gunakan varietas tahan wereng (VUTW)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Terapkan pergiliran tanaman selain padi', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== SHEATH ROT =====
            'sheath-rot' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Carbendazim atau Mancozeb pada fase bunting', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Kendalikan serangan penggerek batang dan tungau', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Perlebar jarak tanam untuk sirkulasi udara', 'dosage' => null, 'dosage_unit' => null, 'priority' => 2],
            ],
            // ===== STEM ROT =====
            'stem-rot' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Heksakonazol atau Propikonazol di pangkal batang', 'dosage' => '1.5', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Keringkan sawah sesekali (intermittent irrigation) untuk mencegah busuk', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Bakar jerami sisa panen untuk membunuh sklerotia jamur', 'dosage' => null, 'dosage_unit' => null, 'priority' => 2],
            ],
            // ===== GRASSY STUNT VIRUS =====
            'grassy-stunt-virus' => [
                ['type' => 'chemical', 'description' => 'Aplikasi insektisida sistemik untuk Wereng Batang Coklat (Imidakloprid)', 'dosage' => '1', 'dosage_unit' => 'ml/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Tanam serempak dalam areal yang luas', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Cabut segera tanaman yang terlihat kerdil rimbun (eradikasi)', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
            ],
            // ===== FALSE SMUT =====
            'false-smut' => [
                ['type' => 'chemical', 'description' => 'Aplikasi fungisida Tembaga Hidroksida atau Klorotalonil saat padi bunting', 'dosage' => '2', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Hindari pupuk nitrogen terlalu tinggi pada saat pembungaan', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'cultural', 'description' => 'Bersihkan galengan dari gulma inang jamur', 'dosage' => null, 'dosage_unit' => null, 'priority' => 2],
            ],
            // ===== NECK BLAST =====
            'neck-blast' => [
                ['type' => 'chemical', 'description' => 'Aplikasi preventif Trisiklazol atau Difenokonazol pada awal keluar malai', 'dosage' => '1.5', 'dosage_unit' => 'gram/L', 'priority' => 1],
                ['type' => 'prevention', 'description' => 'Gunakan varietas berleher kuat dan tahan blast', 'dosage' => null, 'dosage_unit' => null, 'priority' => 1],
                ['type' => 'biological', 'description' => 'Aplikasi agen hayati Paenibacillus polymyxa sebelum berbunga', 'dosage' => '5', 'dosage_unit' => 'ml/L', 'priority' => 2],
            ],
        ];

        foreach ($treatments as $diseaseSlug => $diseaseTreatments) {
            $disease = Disease::where('slug', $diseaseSlug)->first();
            if (! $disease) {
                continue;
            }
            foreach ($diseaseTreatments as $treatment) {
                Treatment::create(array_merge($treatment, ['disease_id' => $disease->id]));
            }
        }
    }
}
