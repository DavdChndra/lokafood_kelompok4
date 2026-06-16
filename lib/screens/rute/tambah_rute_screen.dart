import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/rute_viewmodel.dart';
import '../route_screen.dart';

const _kPrimary = Color(0xFF7F2020);
const _kSecondary = Color(0xFF869B7E);
const _kBackground = Color(0xFFF6F3EB);

class TambahRuteScreen extends StatefulWidget {
  final RuteModel? existingRute;
  const TambahRuteScreen({super.key, this.existingRute});

  @override
  State<TambahRuteScreen> createState() => _TambahRuteScreenState();
}

class _TambahRuteScreenState extends State<TambahRuteScreen> {
  final _namaRuteCtrl = TextEditingController();
  final _kotaCtrl = TextEditingController();
  final _durasiCtrl = TextEditingController();
  bool _isPublic = false;
  final List<Map<String, TextEditingController>> _stops = [];

  bool get isEdit => widget.existingRute != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final r = widget.existingRute!;
      _namaRuteCtrl.text = r.namaRute;
      _kotaCtrl.text = r.kota;
      _durasiCtrl.text = r.durasi;
      _isPublic = r.isPublic;
      for (final titik in r.titik) {
        _stops.add({
          'nama': TextEditingController(text: titik['nama']),
          'waktu': TextEditingController(text: titik['waktu']),
          'catatan': TextEditingController(text: titik['catatan']),
        });
      }
      if (_stops.isEmpty) _addStop();
    } else {
      _addStop();
    }
  }

  @override
  void dispose() {
    _namaRuteCtrl.dispose();
    _kotaCtrl.dispose();
    _durasiCtrl.dispose();
    for (final stop in _stops) {
      stop['nama']!.dispose();
      stop['waktu']!.dispose();
      stop['catatan']!.dispose();
    }
    super.dispose();
  }

  void _addStop() {
    setState(() {
      _stops.add({
        'nama': TextEditingController(),
        'waktu': TextEditingController(),
        'catatan': TextEditingController(),
      });
    });
  }

  void _removeStop(int index) {
    setState(() {
      _stops[index]['nama']!.dispose();
      _stops[index]['waktu']!.dispose();
      _stops[index]['catatan']!.dispose();
      _stops.removeAt(index);
    });
  }

  Future<void> _simpan() async {
    if (_namaRuteCtrl.text.trim().isEmpty ||
        _kotaCtrl.text.trim().isEmpty ||
        _durasiCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nama rute, kota, dan durasi wajib diisi')),
      );
      return;
    }

    final titik = _stops
        .where((s) => s['nama']!.text.trim().isNotEmpty)
        .map((s) => {
              'nama': s['nama']!.text.trim(),
              'waktu': s['waktu']!.text.trim(),
              'catatan': s['catatan']!.text.trim(),
            })
        .toList();

    if (titik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Tambahkan minimal 1 stop perjalanan')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final rute = RuteModel(
      uid: uid,
      namaRute: _namaRuteCtrl.text.trim(),
      kota: _kotaCtrl.text.trim(),
      durasi: _durasiCtrl.text.trim(),
      isPublic: _isPublic,
      titik: titik,
    );

    final vm = context.read<RuteViewModel>();
    bool success;

    if (isEdit && widget.existingRute?.docId != null) {
      success = await vm.updateRute(widget.existingRute!.docId!, rute);
    } else {
      success = await vm.addRute(rute);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit
              ? 'Rute berhasil diupdate!'
              : 'Rute berhasil disimpan!'),
          backgroundColor: _kSecondary,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const RouteScreen(initialTab: 1),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RuteViewModel>();

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEdit ? 'Edit Rute' : 'Buat Rute Perjalanan',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: vm.isLoading ? null : _simpan,
            child: Text(
              isEdit ? 'Update' : 'Simpan',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Informasi Rute'),
            const SizedBox(height: 12),
            _buildTextField(_namaRuteCtrl, 'Nama Rute',
                Icons.route, 'Contoh: Wisata Kuliner Bandung'),
            const SizedBox(height: 12),
            _buildTextField(_kotaCtrl, 'Kota Tujuan',
                Icons.location_city, 'Contoh: Bandung'),
            const SizedBox(height: 12),
            _buildTextField(_durasiCtrl, 'Estimasi Durasi',
                Icons.schedule, 'Contoh: 1 Hari'),
            const SizedBox(height: 16),

            // Toggle Public
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.public, color: _kPrimary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bagikan ke Komunitas',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        Text('Rute bisa dilihat pengguna lain',
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isPublic,
                    onChanged: (v) => setState(() => _isPublic = v),
                    activeColor: _kPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Titik Perjalanan'),
            const SizedBox(height: 12),

            ..._stops.asMap().entries.map((entry) {
              final index = entry.key;
              final stop = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: _kPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stop ${index + 1}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const Spacer(),
                        if (_stops.length > 1)
                          GestureDetector(
                            onTap: () => _removeStop(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.red, size: 16),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInlineField(stop['nama']!,
                        'Nama Tempat / Kuliner', Icons.restaurant),
                    const SizedBox(height: 8),
                    _buildInlineField(stop['waktu']!,
                        'Waktu (contoh: 08.00 - 09.00)', Icons.access_time),
                    const SizedBox(height: 8),
                    _buildInlineField(stop['catatan']!,
                        'Catatan (opsional)', Icons.note_outlined,
                        maxLines: 2),
                  ],
                ),
              );
            }),

            // Tombol Tambah Stop
            GestureDetector(
              onTap: _addStop,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: _kPrimary, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                  color: _kPrimary.withOpacity(0.05),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline,
                        color: _kPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tambah Stop',
                      style: GoogleFonts.poppins(
                        color: _kPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Tombol Simpan/Update
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 4,
                ),
                onPressed: vm.isLoading ? null : _simpan,
                child: vm.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        isEdit ? 'Update Rute' : 'Simpan Rute',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _kPrimary,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        const SizedBox(width: 8),
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label,
      IconData icon, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: TextField(
        controller: ctrl,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: _kPrimary, size: 20),
          labelText: label,
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12),
          labelStyle:
              GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildInlineField(TextEditingController ctrl, String hint,
      IconData icon,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 13),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey, size: 18),
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12),
        filled: true,
        fillColor: _kBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
  }
}