import '../models/kuliner_model.dart';

final List<KulinerModel> daftarKuliner = [
  KulinerModel(
    id: '1',
    nama: 'Rendang',
    daerah: 'Padang',
    provinsi: 'Sumatera Barat',
    pulau: 'Sumatera',
    deskripsi:
        'Rendang adalah masakan daging sapi yang dimasak perlahan dengan santan dan bumbu rempah khas Minangkabau hingga mengering dan berwarna cokelat kehitaman. Rasanya kaya, gurih, pedas, dan sangat aromatik.',
    sejarah:
        'Rendang berasal dari tradisi memasak masyarakat Minangkabau sejak abad ke-16. Makanan ini awalnya dibuat sebagai bekal perjalanan jauh karena tahan lama tanpa lemari es. Rendang juga selalu hadir dalam upacara adat dan pesta pernikahan Minang.',
    bahanUtama: [
      'Daging sapi',
      'Santan kelapa',
      'Cabai merah',
      'Serai',
      'Lengkuas',
      'Kunyit',
      'Daun jeruk',
      'Daun kunyit',
    ],
    imagePath: 'assets/images/rendang.jpg',
    rating: 4.9,
    lokasi: 'Rumah Makan Sederhana, Jl. Minangkabau No. 1, Padang',
  ),
  KulinerModel(
    id: '2',
    nama: 'Soto Ayam Lamongan',
    daerah: 'Lamongan',
    provinsi: 'Jawa Timur',
    pulau: 'Jawa',
    deskripsi:
        'Soto Ayam Lamongan adalah sup ayam bening berkuah kuning dengan bumbu rempah khas Jawa Timur. Disajikan dengan soun, telur, tomat, dan taburan koya (kerupuk udang yang dihaluskan).',
    sejarah:
        'Soto Lamongan dikenal sejak zaman Kerajaan Majapahit dan menjadi hidangan rakyat yang merakyat. Koya sebagai topping khas menjadikan Soto Lamongan berbeda dari soto di daerah lain di Indonesia.',
    bahanUtama: [
      'Ayam kampung',
      'Kunyit',
      'Bawang merah',
      'Bawang putih',
      'Serai',
      'Daun jeruk',
      'Soun',
      'Koya udang',
    ],
    imagePath: 'assets/images/soto-lamongan.jpg',
    rating: 4.7,
    lokasi: 'Warung Soto Cak Har, Jl. Veteran No. 22, Lamongan',
  ),
  KulinerModel(
    id: '3',
    nama: 'Pempek',
    daerah: 'Palembang',
    provinsi: 'Sumatera Selatan',
    pulau: 'Sumatera',
    deskripsi:
        'Pempek adalah makanan khas Palembang berbahan dasar ikan tenggiri dan sagu. Disajikan dengan kuah cuka yang asam, manis, dan pedas, serta ditambah ebi dan mentimun.',
    sejarah:
        'Pempek sudah ada sejak abad ke-16, bermula dari orang Tionghoa di Palembang yang mengolah ikan dengan cara berbeda. Nama "pempek" konon berasal dari sebutan "apek" untuk orang Tionghoa tua.',
    bahanUtama: [
      'Ikan tenggiri',
      'Sagu',
      'Telur',
      'Bawang putih',
      'Cuka',
      'Cabai',
      'Ebi',
      'Mentimun',
    ],
    imagePath: 'assets/images/pempek.jpg',
    rating: 4.8,
    lokasi: 'Pempek Candy, Jl. Sudirman No. 75, Palembang',
  ),
  KulinerModel(
    id: '4',
    nama: 'Papeda',
    daerah: 'Jayapura',
    provinsi: 'Papua',
    pulau: 'Papua',
    deskripsi:
        'Papeda adalah makanan pokok masyarakat Papua berupa bubur sagu yang bertekstur lengket dan bening. Disajikan dengan ikan kuah kuning yang segar dan beraroma rempah.',
    sejarah:
        'Papeda merupakan makanan tradisional suku-suku di Papua dan Maluku yang telah dimakan sejak ratusan tahun lalu. Pohon sagu menjadi tanaman sakral yang diwariskan turun-temurun oleh masyarakat adat Papua.',
    bahanUtama: [
      'Sagu',
      'Ikan tongkol',
      'Kunyit',
      'Kemangi',
      'Jeruk nipis',
      'Cabai',
      'Serai',
      'Daun salam',
    ],
    imagePath: 'assets/images/papeda.jpg',
    rating: 4.6,
    lokasi: 'Warung Mama Yulce, Jl. Percetakan Negara, Jayapura',
  ),
  KulinerModel(
    id: '5',
    nama: 'Babi Guling',
    daerah: 'Ubud',
    provinsi: 'Bali',
    pulau: 'Bali',
    deskripsi:
        'Babi Guling adalah hidangan khas Bali berupa babi utuh yang dipanggang di atas bara api sambil diputar (diguling). Kulitnya renyah dengan bumbu base genep yang kaya rempah.',
    sejarah:
        'Babi Guling awalnya merupakan sajian khusus upacara adat dan keagamaan Hindu di Bali. Kini menjadi hidangan ikonik yang dicari wisatawan dari seluruh penjuru dunia.',
    bahanUtama: [
      'Babi muda',
      'Base genep',
      'Kunyit',
      'Cabai',
      'Serai',
      'Bawang putih',
      'Daun salam',
      'Kemiri',
    ],
    imagePath: 'assets/images/babi-guling.jpg',
    rating: 4.8,
    lokasi: 'Warung Babi Guling Ibu Oka, Jl. Suweta No.2, Ubud, Bali',
  ),
  KulinerModel(
    id: '6',
    nama: 'Coto Makassar',
    daerah: 'Makassar',
    provinsi: 'Sulawesi Selatan',
    pulau: 'Sulawesi',
    deskripsi:
        'Coto Makassar adalah sup daging sapi dan jeroan dengan kuah kacang yang kental dan gurih. Disajikan dengan ketupat atau burasa (lontong khas Bugis).',
    sejarah:
        'Coto Makassar telah ada sejak masa Kerajaan Gowa pada abad ke-16 dan menjadi hidangan kerajaan yang kini bisa dinikmati semua kalangan.',
    bahanUtama: [
      'Daging sapi',
      'Jeroan sapi',
      'Kacang tanah',
      'Serai',
      'Lengkuas',
      'Bawang merah',
      'Ketumbar',
      'Jinten',
    ],
    imagePath: 'assets/images/coto-makassar.jpg',
    rating: 4.7,
    lokasi: 'Coto Nusantara, Jl. Nusantara No. 32, Makassar',
  ),
  KulinerModel(
    id: '7',
    nama: 'Gudeg',
    daerah: 'Yogyakarta',
    provinsi: 'DI Yogyakarta',
    pulau: 'Jawa',
    deskripsi:
        'Gudeg adalah masakan khas Yogyakarta berbahan dasar nangka muda yang dimasak dengan santan dan gula merah berjam-jam hingga berwarna cokelat dan rasanya manis gurih.',
    sejarah:
        'Gudeg sudah ada sejak abad ke-17 dan menjadi makanan kerajaan di Keraton Yogyakarta. Hingga kini gudeg menjadi simbol kuliner ikonik kota pelajar.',
    bahanUtama: [
      'Nangka muda',
      'Santan',
      'Gula merah',
      'Daun salam',
      'Lengkuas',
      'Bawang merah',
      'Bawang putih',
      'Telur pindang',
    ],
    imagePath: 'assets/images/gudeg.jpg',
    rating: 4.6,
    lokasi: 'Gudeg Yu Djum, Jl. Kaliurang KM 4.5, Yogyakarta',
  ),
  KulinerModel(
    id: '8',
    nama: 'Amplang',
    daerah: 'Samarinda',
    provinsi: 'Kalimantan Timur',
    pulau: 'Kalimantan',
    deskripsi:
        'Amplang adalah kerupuk ikan khas Kalimantan Timur yang renyah, gurih, dan beraroma kuat. Terbuat dari ikan tenggiri segar yang dipadukan dengan tepung tapioka.',
    sejarah:
        'Amplang merupakan camilan tradisional masyarakat pesisir Kalimantan yang telah diwariskan turun-temurun dan kini menjadi oleh-oleh khas yang diburu wisatawan.',
    bahanUtama: [
      'Ikan tenggiri',
      'Tepung tapioka',
      'Bawang putih',
      'Telur',
      'Garam',
      'Gula',
    ],
    imagePath: 'assets/images/amplang.jpg',
    rating: 4.5,
    lokasi: 'Toko Amplang Mahakam, Jl. Pahlawan No.10, Samarinda',
  ),
];

final List<Map<String, dynamic>> daftarRute = [
  {
    'kota': 'Yogyakarta',
    'durasi': '1 Hari',
    'titik': [
      {
        'nama': 'Gudeg Yu Djum',
        'waktu': '07.00',
        'keterangan': 'Sarapan gudeg legendaris sejak 1950',
      },
      {
        'nama': 'Pasar Beringharjo',
        'waktu': '09.00',
        'keterangan': 'Jajanan pasar tradisional Yogya',
      },
      {
        'nama': 'Soto Kadipiro',
        'waktu': '12.00',
        'keterangan': 'Makan siang soto ayam otentik',
      },
      {
        'nama': 'Bakpia Pathok 25',
        'waktu': '15.00',
        'keterangan': 'Beli oleh-oleh bakpia khas Yogya',
      },
      {
        'nama': 'Angkringan Lik Man',
        'waktu': '19.00',
        'keterangan': 'Makan malam di angkringan bersejarah',
      },
    ],
  },
  {
    'kota': 'Palembang',
    'durasi': '1 Hari',
    'titik': [
      {
        'nama': 'Pempek Candy',
        'waktu': '08.00',
        'keterangan': 'Sarapan pempek asli Palembang',
      },
      {
        'nama': 'Pasar 16 Ilir',
        'waktu': '10.00',
        'keterangan': 'Berburu makanan khas di pasar tradisional',
      },
      {
        'nama': 'Model Lenjer Bu Rosita',
        'waktu': '12.30',
        'keterangan': 'Makan siang pempek model terenak',
      },
      {
        'nama': 'Martabak HAR',
        'waktu': '17.00',
        'keterangan': 'Martabak khas India-Melayu Palembang',
      },
    ],
  },
  {
    'kota': 'Makassar',
    'durasi': '1 Hari',
    'titik': [
      {
        'nama': 'Coto Nusantara',
        'waktu': '07.00',
        'keterangan': 'Sarapan coto makassar yang legendaris',
      },
      {
        'nama': 'Pasar Terong',
        'waktu': '09.30',
        'keterangan': 'Wisata pasar tradisional terbesar',
      },
      {
        'nama': 'Konro Karebosi',
        'waktu': '12.00',
        'keterangan': 'Makan siang sup iga sapi khas Bugis',
      },
      {
        'nama': 'Es Pisang Ijo Leko',
        'waktu': '15.00',
        'keterangan': 'Minuman segar khas Makassar',
      },
    ],
  },
];
