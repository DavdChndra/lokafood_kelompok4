import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/kuliner_model.dart';
import '../../viewmodels/kuliner_viewmodel.dart';

const _kPrimary = Color(0xFF7F2020);
const _kSecondary = Color(0xFF869B7E);
const _kBackground = Color(0xFFF6F3EB);

class TambahKulinerScreen extends StatefulWidget {
  final KulinerModel? existingKuliner;
  const TambahKulinerScreen({super.key, this.existingKuliner});

  @override
  State<TambahKulinerScreen> createState() => _TambahKulinerScreenState();
}

class _TambahKulinerScreenState extends State<TambahKulinerScreen> {
  final _namaCtrl = TextEditingController();
  final _daerahCtrl = TextEditingController();
  final _provinsiCtrl = TextEditingController();
  final _deskripsiCtrl = TextEditingController();
  final _sejarahCtrl = TextEditingController();
  final _lokasiCtrl = TextEditingController();
  final _bahanCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  double _rating = 4.0;
  String _selectedPulau = 'Jawa';
  List<String> _bahanList = [];

  static const List<String> _pulauList = [
    'Jawa', 'Sumatera', 'Kalimantan', 'Sulawesi', 'Bali', 'Papua', 'Nusa Tenggara'
  ];

  bool get isEdit => widget.existingKuliner != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final k = widget.existingKuliner!;
      _namaCtrl.text = k.nama;
      _daerahCtrl.text = k.daerah;
      _provinsiCtrl.text = k.provinsi;
      _deskripsiCtrl.text = k.deskripsi;
      _sejarahCtrl.text = k.sejarah;
      _lokasiCtrl.text = k.lokasi;
      _rating = k.rating;
      _selectedPulau = k.pulau;
      _bahanList = List.from(k.bahanUtama);
      _imageUrlCtrl.text = k.imagePath;
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _daerahCtrl.dispose();
    _provinsiCtrl.dispose();
    _deskripsiCtrl.dispose();
    _sejarahCtrl.dispose();
    _lokasiCtrl.dispose();
    _bahanCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  void _addBahan() {
    final bahan = _bahanCtrl.text.trim();
    if (bahan.isNotEmpty) {
      setState(() {
        _bahanList.add(bahan);
        _bahanCtrl.clear();
      });
    }
  }

  Future<void> _simpan() async {
    if (_namaCtrl.text.trim().isEmpty ||
        _daerahCtrl.text.trim().isEmpty ||
        _provinsiCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nama, daerah, dan provinsi wajib diisi')),
      );
      return;
    }

    final vm = context.read<KulinerViewModel>();
    final kuliner = KulinerModel(
      id: widget.existingKuliner?.id ?? '',
      docId: widget.existingKuliner?.docId,
      nama: _namaCtrl.text.trim(),
      daerah: _daerahCtrl.text.trim(),
      provinsi: _provinsiCtrl.text.trim(),
      deskripsi: _deskripsiCtrl.text.trim(),
      sejarah: _sejarahCtrl.text.trim(),
      bahanUtama: _bahanList,
      imagePath: _imageUrlCtrl.text.trim(),
      rating: _rating,
      lokasi: _lokasiCtrl.text.trim(),
      pulau: _selectedPulau,
    );

    if (isEdit && widget.existingKuliner?.docId != null) {
      await vm.updateKuliner(widget.existingKuliner!.docId!, kuliner.toMap());
    } else {
      await vm.addKuliner(kuliner);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit
              ? 'Kuliner berhasil diupdate!'
              : 'Kuliner berhasil ditambahkan!'),
          backgroundColor: _kSecondary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<KulinerViewModel>();

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEdit ? 'Edit Kuliner' : 'Tambah Kuliner',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: vm.isLoading ? null : _simpan,
            child: Text(
              'Simpan',
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
            // Badge Admin
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border:
                    Border.all(color: _kPrimary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.admin_panel_settings,
                      color: _kPrimary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Mode Admin',
                    style: GoogleFonts.poppins(
                        color: _kPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSection('Informasi Dasar', [
              _buildTextField(
                  _namaCtrl, 'Nama Kuliner', Icons.restaurant),
              const SizedBox(height: 12),
              _buildTextField(_daerahCtrl, 'Daerah/Kota Asal',
                  Icons.location_city),
              const SizedBox(height: 12),
              _buildTextField(
                  _provinsiCtrl, 'Provinsi', Icons.map_outlined),
            ]),
            const SizedBox(height: 20),

            _buildSection('Gambar Kuliner', [
              _buildTextField(_imageUrlCtrl, 'URL Gambar (opsional)',
                  Icons.image_outlined),
              const SizedBox(height: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _imageUrlCtrl,
                builder: (context, value, _) {
                  final url = value.text.trim();
                  if (url.isEmpty) {
                    return Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              color: Colors.grey[400], size: 40),
                          const SizedBox(height: 8),
                          Text('Preview gambar akan muncul di sini',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      url,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image_outlined,
                                color: Colors.red, size: 40),
                            const SizedBox(height: 8),
                            Text('URL gambar tidak valid',
                                style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Tip: Klik kanan gambar di Google → "Copy image address" → paste di atas',
                style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 11,
                    fontStyle: FontStyle.italic),
              ),
            ]),
            const SizedBox(height: 20),

            _buildSection('Pulau & Lokasi', [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10)
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedPulau,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.public,
                        color: _kPrimary, size: 20),
                    labelText: 'Pulau',
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: _pulauList
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child:
                                Text(p, style: GoogleFonts.poppins()),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedPulau = v!),
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(_lokasiCtrl,
                  'Koordinat Lokasi (opsional)', Icons.pin_drop),
            ]),
            const SizedBox(height: 20),

            _buildSection('Rating', [
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFF39C12), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    _rating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 8,
                      activeColor: _kPrimary,
                      onChanged: (v) =>
                          setState(() => _rating = v),
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20),

            _buildSection('Deskripsi & Sejarah', [
              _buildTextField(_deskripsiCtrl, 'Deskripsi Kuliner',
                  Icons.description_outlined,
                  maxLines: 4),
              const SizedBox(height: 12),
              _buildTextField(_sejarahCtrl, 'Sejarah Kuliner',
                  Icons.history_edu,
                  maxLines: 4),
            ]),
            const SizedBox(height: 20),

            _buildSection('Bahan Utama', [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_bahanCtrl,
                        'Tambah bahan...', Icons.restaurant_menu),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _addBahan,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _kPrimary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (_bahanList.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _bahanList
                      .map((b) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _kPrimary.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(50),
                              border: Border.all(
                                  color:
                                      _kPrimary.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(b,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: _kPrimary)),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => setState(
                                      () => _bahanList.remove(b)),
                                  child: const Icon(Icons.close,
                                      size: 14, color: _kPrimary),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ]),
            const SizedBox(height: 32),

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
                        isEdit ? 'Update Kuliner' : 'Tambah Kuliner',
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

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
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
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: maxLines == 1
              ? Icon(icon, color: _kPrimary, size: 20)
              : null,
          labelText: label,
          labelStyle:
              GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: 16, horizontal: maxLines > 1 ? 16 : 8),
        ),
      ),
    );
  }
}