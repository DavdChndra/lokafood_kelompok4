import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _role = 'user';
  bool _isLoading = false;

  String get role => _role;
  bool get isLoading => _isLoading;
  bool get isAdmin => _role == 'admin';

  // Load role user dari Firestore
  Future<void> loadUserRole(String uid) async {
    _isLoading = true;
    notifyListeners();
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _role = data['role'] ?? 'user';
      } else {
        // Kalau dokumen belum ada, buat baru dengan role user
        await _db.collection('users').doc(uid).set({
          'role': 'user',
          'favorit': [],
        }, SetOptions(merge: true));
        _role = 'user';
      }
    } catch (e) {
      _role = 'user';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set role saat register (selalu user)
  Future<void> createUserProfile(String uid, String name, String email) async {
    try {
      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': 'user',
        'favorit': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      _role = 'user';
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating user profile: $e');
    }
  }

  void reset() {
    _role = 'user';
    notifyListeners();
  }
}
