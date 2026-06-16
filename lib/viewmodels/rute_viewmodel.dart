import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RuteModel {
  final String? docId;
  final String uid;
  final String namaRute;
  final String kota;
  final String durasi;
  final bool isPublic;
  final List<Map<String, String>> titik;
  final DateTime? createdAt;

  RuteModel({
    this.docId,
    required this.uid,
    required this.namaRute,
    required this.kota,
    required this.durasi,
    required this.isPublic,
    required this.titik,
    this.createdAt,
  });

  factory RuteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RuteModel(
      docId: doc.id,
      uid: data['uid'] ?? '',
      namaRute: data['namaRute'] ?? '',
      kota: data['kota'] ?? '',
      durasi: data['durasi'] ?? '',
      isPublic: data['isPublic'] ?? false,
      titik: List<Map<String, String>>.from(
        (data['titik'] as List<dynamic>? ?? []).map(
          (e) => Map<String, String>.from(e as Map),
        ),
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'namaRute': namaRute,
      'kota': kota,
      'durasi': durasi,
      'isPublic': isPublic,
      'titik': titik,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class RuteViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Stream rute milik user sendiri
  Stream<List<RuteModel>> watchMyRute(String uid) {
    return _db
        .collection('rute_user')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => RuteModel.fromFirestore(doc)).toList());
  }

  // Stream rute komunitas (public)
  Stream<List<RuteModel>> watchRuteKomunitas() {
    return _db
        .collection('rute_user')
        .where('isPublic', isEqualTo: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => RuteModel.fromFirestore(doc)).toList());
  }

  // Tambah rute baru
  Future<bool> addRute(RuteModel rute) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _db.collection('rute_user').add(rute.toMap());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan rute: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Hapus rute
  Future<void> deleteRute(String docId) async {
    try {
      await _db.collection('rute_user').doc(docId).delete();
    } catch (e) {
      _errorMessage = 'Gagal menghapus rute: $e';
      notifyListeners();
    }
  }

  // Update rute
  Future<bool> updateRute(String docId, RuteModel rute) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.collection('rute_user').doc(docId).update({
        'namaRute': rute.namaRute,
        'kota': rute.kota,
        'durasi': rute.durasi,
        'isPublic': rute.isPublic,
        'titik': rute.titik,
      });
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengupdate rute: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
