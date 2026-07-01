<?php

namespace Database\Seeders;

use App\Models\Disease;
use Illuminate\Database\Seeder;

class DiseaseSeeder extends Seeder
{
    public function run(): void
    {
        $diseases = [
            [
                'name' => 'Blast',
                'slug' => 'blast',
                'latin_name' => 'Pyricularia oryzae',
                'description' => 'Penyakit blast disebabkan oleh jamur Pyricularia oryzae (Magnaporthe oryzae). Merupakan salah satu penyakit paling merusak pada tanaman padi di seluruh dunia. Jamur ini dapat menyerang semua bagian tanaman padi di atas tanah, termasuk daun, leher malai, buku batang, dan gabah. Serangan berat dapat menyebabkan kehilangan hasil panen hingga 50-100%.',
                'cause' => 'Jamur Pyricularia oryzae yang menyebar melalui spora udara (konidia). Berkembang pesat pada kondisi kelembaban tinggi (>90%), suhu 25-28°C, embun pagi yang lama, dan pemupukan nitrogen berlebihan.',
            ],
            [
                'name' => 'Brown Spot',
                'slug' => 'brown-spot',
                'latin_name' => 'Bipolaris oryzae',
                'description' => 'Penyakit bercak coklat (brown spot) disebabkan oleh jamur Bipolaris oryzae (Helminthosporium oryzae). Menyerang daun, pelepah daun, dan gabah. Penyakit ini sering terjadi pada tanah yang kekurangan nutrisi, terutama kalium dan fosfor.',
                'cause' => 'Jamur Bipolaris oryzae yang terkait erat dengan defisiensi kalium dan fosfor pada tanah. Berkembang pada suhu 25-30°C dengan kelembaban tinggi.',
            ],
            [
                'name' => 'Tungro',
                'slug' => 'tungro',
                'latin_name' => 'Rice Tungro Bacilliform Virus (RTBV) & Rice Tungro Spherical Virus (RTSV)',
                'description' => 'Penyakit tungro disebabkan oleh dua jenis virus (RTBV dan RTSV) yang ditularkan oleh wereng hijau (Nephotettix virescens). Menyebabkan pertumbuhan tanaman terhambat, daun menguning, dan penurunan hasil panen drastis.',
                'cause' => 'Virus RTBV dan RTSV yang ditularkan oleh vektor wereng hijau. Penyebaran cepat pada musim hujan saat populasi wereng tinggi.',
            ],
            [
                'name' => 'Bacterial Leaf Blight',
                'slug' => 'bacterial-leaf-blight',
                'latin_name' => 'Xanthomonas oryzae pv. oryzae',
                'description' => 'Penyakit hawar daun bakteri (HDB) disebabkan oleh bakteri Xanthomonas oryzae pv. oryzae. Merupakan penyakit bakteri paling penting pada tanaman padi. Bakteri masuk melalui luka atau stomata dan menyebar melalui pembuluh xylem.',
                'cause' => 'Bakteri Xanthomonas oryzae pv. oryzae yang masuk melalui luka mekanis atau lubang alami pada daun. Menyebar melalui air irigasi, percikan hujan, dan angin.',
            ],
            [
                'name' => 'Healthy',
                'slug' => 'healthy',
                'latin_name' => null,
                'description' => 'Tanaman padi dalam kondisi sehat tanpa gejala penyakit. Daun berwarna hijau segar dan cerah, pertumbuhan normal sesuai fase tumbuh, batang kokoh, dan anakan tumbuh optimal.',
                'cause' => 'Tidak ada penyebab penyakit. Tanaman dalam kondisi optimal dengan pemeliharaan yang baik.',
            ],
            // ===== 6 KELAS BARU =====
            [
                'name' => 'Hispa',
                'slug' => 'hispa',
                'latin_name' => 'Dicladispa armigera',
                'description' => 'Hispa (kumbang pengerek daun) adalah hama yang menyerang daun padi. Larva mengorok di dalam jaringan daun membentuk terowongan, sedangkan kumbang dewasa mengikis permukaan atas daun. Serangan berat menyebabkan daun memutih dan mengering.',
                'cause' => 'Kumbang Dicladispa armigera. Larva mengorok di dalam daun, kumbang dewasa mengikis permukaan daun. Populasi meningkat pada musim hujan dan kelembaban tinggi.',
            ],
            [
                'name' => 'Dead Heart',
                'slug' => 'dead-heart',
                'latin_name' => 'Scirpophaga incertulas',
                'description' => 'Dead heart (sundep) disebabkan oleh larva penggerek batang padi kuning (Scirpophaga incertulas). Larva menggerek batang padi sehingga pucuk tanaman mati dan mudah dicabut. Pada fase generatif menyebabkan beluk (malai hampa putih).',
                'cause' => 'Larva penggerek batang padi kuning (Scirpophaga incertulas) yang menggerek masuk ke dalam batang padi. Ngengat betina meletakkan telur pada daun, larva kemudian masuk ke batang.',
            ],
            [
                'name' => 'Downy Mildew',
                'slug' => 'downy-mildew',
                'latin_name' => 'Sclerophthora macrospora',
                'description' => 'Bulai (downy mildew) pada padi disebabkan oleh jamur Sclerophthora macrospora. Menyebabkan pertumbuhan abnormal, daun menguning dengan garis-garis klorotik, dan pembentukan malai yang tidak normal. Tanaman yang terinfeksi sering kerdil.',
                'cause' => 'Jamur Sclerophthora macrospora yang menyebar melalui zoospora di air. Berkembang pada kondisi tergenang dan suhu rendah (20-25°C). Infeksi terjadi melalui akar atau bagian tanaman yang terendam.',
            ],
            [
                'name' => 'Bacterial Leaf Streak',
                'slug' => 'bacterial-leaf-streak',
                'latin_name' => 'Xanthomonas oryzae pv. oryzicola',
                'description' => 'Garis bakteri daun (bacterial leaf streak) disebabkan oleh bakteri Xanthomonas oryzae pv. oryzicola. Berbeda dengan BLB, penyakit ini menunjukkan garis-garis coklat sempit di antara tulang daun. Eksudat bakteri berwarna kuning sering terlihat.',
                'cause' => 'Bakteri Xanthomonas oryzae pv. oryzicola yang masuk melalui stomata. Menyebar melalui percikan air hujan dan angin. Berkembang pada suhu 25-30°C dan kelembaban tinggi.',
            ],
            [
                'name' => 'Bacterial Panicle Blight',
                'slug' => 'bacterial-panicle-blight',
                'latin_name' => 'Burkholderia glumae',
                'description' => 'Hawar malai bakteri (bacterial panicle blight) disebabkan oleh bakteri Burkholderia glumae. Menyerang malai padi menyebabkan gabah berubah warna, steril, dan busuk. Penyakit ini sering muncul pada suhu tinggi saat fase pembungaan.',
                'cause' => 'Bakteri Burkholderia glumae yang menginfeksi malai saat pembungaan. Berkembang optimal pada suhu tinggi (>30°C) dan kelembaban tinggi. Bakteri dapat terbawa benih.',
            ],
            [
                'name' => 'Leaf Smut',
                'slug' => 'leaf-smut',
                'latin_name' => 'Entyloma oryzae',
                'description' => 'Noda hitam daun (leaf smut) disebabkan oleh jamur Entyloma oryzae. Menyebabkan bintik-bintik hitam kecil berbentuk sudut pada permukaan daun. Serangan berat menyebabkan daun menguning dan mengering prematur.',
                'cause' => 'Jamur Entyloma oryzae yang menyebar melalui spora udara. Berkembang pada kelembaban tinggi dan suhu 25-30°C. Spora bertahan pada sisa tanaman yang terinfeksi.',
            ],
            [
                'name' => 'Leaf Scald',
                'slug' => 'leaf-scald',
                'latin_name' => 'Microdochium oryzae',
                'description' => 'Penyakit hawar pelepah daun (Leaf Scald) disebabkan oleh jamur Microdochium oryzae. Ciri khasnya adalah munculnya bercak pada pinggiran daun yang lama kelamaan menyebar ke tengah.',
                'cause' => 'Infeksi jamur yang menyebar sangat cepat pada kondisi curah hujan tinggi dan nitrogen berlebihan.',
            ],
            [
                'name' => 'Narrow Brown Leaf Spot',
                'slug' => 'narrow-brown-leaf-spot',
                'latin_name' => 'Cercospora janseana',
                'description' => 'Penyakit bercak coklat sempit (Narrow Brown Leaf Spot) ditandai dengan bercak tipis dan sempit memanjang pada daun, yang sering muncul pada fase matang tanaman.',
                'cause' => 'Jamur Cercospora janseana, dipengaruhi oleh kekurangan nutrisi seperti kalium dan genangan air terus-menerus.',
            ],
            [
                'name' => 'Sheath Blight',
                'slug' => 'sheath-blight',
                'latin_name' => 'Rhizoctonia solani',
                'description' => 'Hawar pelepah (Sheath Blight) menyerang bagian pelepah daun dekat permukaan air, menyebabkan pembusukan. Bisa mengakibatkan tanaman padi roboh.',
                'cause' => 'Jamur tanah Rhizoctonia solani yang sangat agresif pada tingkat kelembaban tinggi dan tanaman yang ditanam terlalu rapat.',
            ],
            // ===== PENYAKIT TAMBAHAN BARU =====
            [
                'name' => 'Bakanae',
                'slug' => 'bakanae',
                'latin_name' => 'Fusarium fujikuroi',
                'description' => 'Penyakit Bakanae (bibit memanjang/bodoh) ditandai dengan tanaman padi yang tumbuh memanjang abnormal, kurus, pucat, dan layu. Tanaman sering mati sebelum mencapai fase berbunga.',
                'cause' => 'Infeksi jamur Fusarium fujikuroi yang menghasilkan hormon pertumbuhan giberelin berlebihan. Menyebar melalui benih yang terinfeksi.',
            ],
            [
                'name' => 'Ragged Stunt Virus',
                'slug' => 'ragged-stunt-virus',
                'latin_name' => 'Rice Ragged Stunt Virus (RRSV)',
                'description' => 'Penyakit kerdil hampa (Ragged Stunt Virus) menyebabkan tanaman kerdil, daun robek-robek (ragged) dan terpelintir, serta malai yang hampa atau tidak keluar sempurna.',
                'cause' => 'Virus RRSV yang ditularkan secara persisten oleh vektor wereng batang coklat (Nilaparvata lugens).',
            ],
            [
                'name' => 'Sheath Rot',
                'slug' => 'sheath-rot',
                'latin_name' => 'Sarocladium oryzae',
                'description' => 'Busuk pelepah (Sheath Rot) menyerang pelepah daun paling atas yang membungkus malai. Menyebabkan bercak tidak beraturan dengan bagian tengah berwarna abu-abu, membuat malai gagal keluar seluruhnya.',
                'cause' => 'Jamur Sarocladium oryzae, sering masuk melalui luka bekas gigitan serangga atau tanaman yang stres nutrisi/cuaca.',
            ],
            [
                'name' => 'Stem Rot',
                'slug' => 'stem-rot',
                'latin_name' => 'Sclerotium oryzae',
                'description' => 'Busuk batang (Stem Rot) menyebabkan bercak hitam kecil pada pelepah luar di dekat permukaan air yang membesar dan membusukkan batang bagian dalam, membuat tanaman rebah.',
                'cause' => 'Jamur Sclerotium oryzae yang bertahan di tanah atau jerami sisa panen (sebagai sklerotia).',
            ],
            [
                'name' => 'Grassy Stunt Virus',
                'slug' => 'grassy-stunt-virus',
                'latin_name' => 'Rice Grassy Stunt Virus (RGSV)',
                'description' => 'Penyakit kerdil rumput menyebabkan tanaman sangat kerdil dengan anakan berlebihan (menyerupai rumpun rumput), daun sempit, kaku, dan berbintik karat, serta umumnya gagal menghasilkan malai.',
                'cause' => 'Virus RGSV yang secara persisten ditularkan melalui gigitan wereng batang coklat (Nilaparvata lugens).',
            ],
            [
                'name' => 'False Smut',
                'slug' => 'false-smut',
                'latin_name' => 'Ustilaginoidea virens',
                'description' => 'Penyakit noda palsu (False Smut) menyerang bulir padi saat fase pematangan. Bulir padi diubah menjadi gumpalan spora besar (bola spora) yang awalnya kuning lalu berubah hijau kehitaman.',
                'cause' => 'Jamur Ustilaginoidea virens yang diuntungkan oleh kelembaban udara yang sangat tinggi dan curah hujan saat padi mulai berbunga.',
            ],
            [
                'name' => 'Neck Blast',
                'slug' => 'neck-blast',
                'latin_name' => 'Pyricularia oryzae',
                'description' => 'Penyakit busuk leher (Neck Blast) adalah varian dari penyakit Blast yang secara spesifik menyerang tangkai (leher) malai padi, menyebabkan leher malai membusuk, patah, dan bulir hampa.',
                'cause' => 'Jamur Pyricularia oryzae yang menginfeksi leher malai saat fase pembungaan pada kondisi kelembaban tinggi.',
            ],
        ];

        foreach ($diseases as $disease) {
            Disease::create($disease);
        }
    }
}
