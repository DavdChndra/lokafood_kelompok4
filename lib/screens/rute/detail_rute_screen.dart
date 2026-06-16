import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/rute_viewmodel.dart';
import 'tambah_rute_screen.dart';

const _kPrimary = Color(0xFF7F2020);
const _kBackground = Color(0xFFF6F3EB);

class DetailRuteScreen extends StatelessWidget {
  final RuteModel rute;
  const DetailRuteScreen({super.key, required this.rute});

  // 3 warna palet
  static const List<Color> _colors = [
    Color(0xFF7F2020),
    Color(0xFF869B7E),
    Color(0xFFC9CAAC),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[rute.namaRute.hashCode.abs() % _colors.length];
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isOwner = rute.uid == uid;

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: color,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          rute.namaRute,
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (isOwner)
            Container(
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TambahRuteScreen(existingRute: rute),
                  ),
                ),
              ),
            ),
          if (isOwner)
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header info
          Container(
            width: double.infinity,
            color: color,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(rute.kota,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(rute.durasi,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    if (rute.isPublic) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.public,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text('Publik',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${rute.titik.length} destinasi wisata kuliner',
                  style: GoogleFonts.poppins(
                      color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Timeline
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rute.titik.length,
              itemBuilder: (context, index) {
                final stop = rute.titik[index];
                final isLast = index == rute.titik.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 44,
                      child: Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _kPrimary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _kPrimary.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 72,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4),
                              decoration: BoxDecoration(
                                color: _kPrimary.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    stop['nama'] ?? '',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                if ((stop['waktu'] ?? '').isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF39C12)
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            size: 12,
                                            color: Color(0xFFF39C12)),
                                        Text(
                                          ' ${stop['waktu']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color:
                                                const Color(0xFFF39C12),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            if ((stop['catatan'] ?? '').isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                stop['catatan'] ?? '',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    height: 1.5),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Rute',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
            'Apakah kamu yakin ingin menghapus rute "${rute.namaRute}"?',
            style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<RuteViewModel>().deleteRute(rute.docId!);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Hapus',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}