import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kuliner_model.dart';
import '../data/kuliner_data.dart';

class KulinerViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  String? get errorMessage => _errorMessage;

  Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;
  bool isFavorite(String id) => _favoriteIds.contains(id);

  // Load favorit dari Firestore
  Future<void> loadFavorites(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _favoriteIds = Set<String>.from(data['favorit'] ?? []);
      notifyListeners();
    }
  }

  // Toggle favorit & simpan ke Firestore
  Future<void> toggleFavorite(String uid, String kulinerDocId) async {
    if (_favoriteIds.contains(kulinerDocId)) {
      _favoriteIds.remove(kulinerDocId);
    } else {
      _favoriteIds.add(kulinerDocId);
    }
    notifyListeners();

    await _db.collection('users').doc(uid).set({
      'favorit': _favoriteIds.toList(),
    }, SetOptions(merge: true));
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<KulinerModel> applyFilter(List<KulinerModel> list) {
    return list.where((k) {
      final matchFilter =
          _selectedFilter == 'Semua' || k.pulau == _selectedFilter;
      final matchSearch = _searchQuery.isEmpty ||
          k.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          k.daerah.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  Stream<List<KulinerModel>> watchKuliner() {
    return _db
        .collection('kuliner')
        .orderBy('nama')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => KulinerModel.fromFirestore(doc)).toList());
  }

  Future<void> addKuliner(KulinerModel kuliner) async {
    _setLoading(true);
    try {
      await _db.collection('kuliner').add(kuliner.toMap());
    } catch (e) {
      _errorMessage = 'Gagal menambah data: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateKuliner(String docId, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _db.collection('kuliner').doc(docId).update(data);
    } catch (e) {
      _errorMessage = 'Gagal mengupdate data: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteKuliner(String docId) async {
    try {
      await _db.collection('kuliner').doc(docId).delete();
    } catch (e) {
      _errorMessage = 'Gagal menghapus data: $e';
      notifyListeners();
    }
  }

  // Auto seed — hanya upload kalau Firestore masih kosong
  Future<void> autoSeed() async {
    try {
      final existing = await _db.collection('kuliner').limit(1).get();
      if (existing.docs.isNotEmpty) return; // Sudah ada data, skip

      final batch = _db.batch();
      for (final k in daftarKuliner) {
        final ref = _db.collection('kuliner').doc();
        batch.set(ref, k.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Auto seed error: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}