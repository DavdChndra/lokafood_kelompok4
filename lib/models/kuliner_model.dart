import 'package:cloud_firestore/cloud_firestore.dart';

class KulinerModel {
  final String id;
  final String nama;
  final String daerah;
  final String provinsi;
  final String deskripsi;
  final String sejarah;
  final List<String> bahanUtama;
  final String imagePath;
  final double rating;
  final String lokasi;
  final String pulau;
  final String? docId;

  KulinerModel({
    required this.id,
    required this.nama,
    required this.daerah,
    required this.provinsi,
    required this.deskripsi,
    required this.sejarah,
    required this.bahanUtama,
    required this.imagePath,
    required this.rating,
    required this.lokasi,
    required this.pulau,
    this.docId,
  });

  factory KulinerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KulinerModel(
      id: doc.id,
      docId: doc.id,
      nama: data['nama'] ?? '',
      daerah: data['daerah'] ?? '',
      provinsi: data['provinsi'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      sejarah: data['sejarah'] ?? '',
      bahanUtama: List<String>.from(data['bahanUtama'] ?? []),
      imagePath: data['imagePath'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      lokasi: data['lokasi'] ?? '',
      pulau: data['pulau'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'daerah': daerah,
      'provinsi': provinsi,
      'deskripsi': deskripsi,
      'sejarah': sejarah,
      'bahanUtama': bahanUtama,
      'imagePath': imagePath,
      'rating': rating,
      'lokasi': lokasi,
      'pulau': pulau,
    };
  }
}
