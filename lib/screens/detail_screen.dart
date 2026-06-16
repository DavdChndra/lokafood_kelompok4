import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/kuliner_model.dart';
import '../viewmodels/kuliner_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import 'route_screen.dart';
import 'admin/tambah_kuliner_screen.dart';

const _kPrimary = Color(0xFF7F2020);
const _kSecondary = Color(0xFF869B7E);

class DetailScreen extends StatelessWidget {
  final KulinerModel kuliner;
  const DetailScreen({super.key, required this.kuliner});

  // 3 warna card sesuai palet
  static const List<Color> _colors = [
    Color(0xFF869B7E),
    Color(0xFFC9CAAC),
    Color(0xFFF6F3EB),
  ];

  String _getEmoji(String pulau) {
    switch (pulau) {
      case 'Sumatera': return '🍛';
      case 'Jawa': return '🍜';
      case 'Bali': return '🐷';
      case 'Sulawesi': return '🥘';
      case 'Papua': return '🐟';
      case 'Kalimantan': return '🦐';
      default: return '🍽️';
    }
  }

  void _showShareSheet(BuildContext context) {
    final text =
        '🍽️ *${kuliner.nama}*\n'
        '📍 ${kuliner.daerah}, ${kuliner.provinsi} — ${kuliner.pulau}\n'
        '⭐ Rating: ${kuliner.rating}\n\n'
        '🥘 Bahan Utama: ${kuliner.bahanUtama.join(', ')}\n\n'
        '— Dibagikan dari LokaFood 🇮🇩';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bagikan ${kuliner.nama}',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.copy, color: _kPrimary, size: 22),
              ),
              title: Text('Salin Teks',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('Salin info kuliner ke clipboard',
                  style:
                      GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text('Teks berhasil disalin!',
                            style:
                                GoogleFonts.poppins(color: Colors.white)),
                      ],
                    ),
                    backgroundColor: _kSecondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.chat,
                    color: Color(0xFF25D366), size: 22),
              ),
              title: Text('Bagikan ke WhatsApp',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('Buka WhatsApp dengan teks sudah terisi',
                  style:
                      GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              onTap: () async {
                Navigator.pop(ctx);
                final encoded = Uri.encodeComponent(text);
                final url = 'https://wa.me/?text=$encoded';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, KulinerViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Kuliner',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
            'Apakah kamu yakin ingin menghapus "${kuliner.nama}"?',
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
              if (kuliner.docId != null) {
                await vm.deleteKuliner(kuliner.docId!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Hapus',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorIndex = kuliner.id.hashCode.abs() % _colors.length;
    final color = _colors[colorIndex];
    final vm = context.watch<KulinerViewModel>();
    final userVm = context.watch<UserViewModel>();
    final isFav = vm.isFavorite(kuliner.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3EB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 270,
            pinned: true,
            backgroundColor: _kPrimary,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              // Favorit
              Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.pink[200] : Colors.white,
                  ),
                  onPressed: () {
                    final uid =
                        FirebaseAuth.instance.currentUser?.uid ?? '';
                    vm.toggleFavorite(uid, kuliner.docId ?? kuliner.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                              ? '${kuliner.nama} dihapus dari favorit'
                              : '${kuliner.nama} ditambah ke favorit',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        backgroundColor:
                            isFav ? Colors.grey[600] : _kPrimary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),

              // Share
              Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () => _showShareSheet(context),
                ),
              ),

              // Edit (admin)
              if (userVm.isAdmin)
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
                        builder: (_) =>
                            TambahKulinerScreen(existingKuliner: kuliner),
                      ),
                    ),
                  ),
                ),

              // Hapus (admin)
              if (userVm.isAdmin)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.white),
                    onPressed: () => _showDeleteDialog(context, vm),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(36)),
                ),
                child: kuliner.imagePath.startsWith('http')
                    ? Image.network(
                        kuliner.imagePath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(_getEmoji(kuliner.pulau),
                              style: const TextStyle(fontSize: 100)),
                        ),
                      )
                    : Image.asset(
                        kuliner.imagePath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(_getEmoji(kuliner.pulau),
                              style: const TextStyle(fontSize: 100)),
                        ),
                      ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          kuliner.nama,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF39C12).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFF39C12), size: 18),
                            Text(
                              ' ${kuliner.rating}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF39C12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: _kPrimary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${kuliner.daerah}, ${kuliner.provinsi}',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: _kPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          kuliner.pulau,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: _kPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _SectionTitle(title: 'Deskripsi', color: _kPrimary),
                  const SizedBox(height: 8),
                  Text(kuliner.deskripsi,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.6,
                          color: Colors.grey[700])),
                  const SizedBox(height: 20),

                  _SectionTitle(title: 'Bahan Utama', color: _kPrimary),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kuliner.bahanUtama
                        .map((b) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: _kPrimary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: _kPrimary.withOpacity(0.3)),
                              ),
                              child: Text(b,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: _kPrimary,
                                      fontWeight: FontWeight.w500)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  _SectionTitle(title: 'Sejarah', color: _kPrimary),
                  const SizedBox(height: 8),
                  Text(kuliner.sejarah,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.6,
                          color: Colors.grey[700])),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}