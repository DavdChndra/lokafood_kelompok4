import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/kuliner_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../models/kuliner_model.dart';
import 'explore_screen.dart';
import 'route_screen.dart';
import 'profile_screen.dart';
import 'detail_screen.dart';
import 'admin/tambah_kuliner_screen.dart';

// Palet warna
const kPrimary = Color(0xFF7F2020);
const kSecondary = Color(0xFF869B7E);
const kSurface = Color(0xFFC9CAAC);
const kBackground = Color(0xFFF6F3EB); // udah diatur lagi soalnya lebih cocok ini warnanya -Rafi

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Map<String, dynamic>> _banners = [
    {
      'emoji': '🍛', 
      'title': 'Kuliner Nusantara',
      'sub': 'Jelajahi Seluruh Kuliner Nusantara !!!', 
      'color': Color(0xFF7F2020), // warna nya udah ku edit (lagi) -Rafi
    },
  ];

  static const List<String> _kategori = [
    'Semua', 'Jawa', 'Sumatera',
    'Kalimantan', 'Sulawesi', 'Papua', 'Bali',
  ];

  static const List<String> _filterNames = [
    'Semua', 'Jawa', 'Sumatera', 'Kalimantan', 'Sulawesi', 'Papua', 'Bali',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<KulinerViewModel>().loadFavorites(user.uid);
        context.read<UserViewModel>().loadUserRole(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final vm = context.watch<KulinerViewModel>();
    final userVm = context.watch<UserViewModel>();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 2,
        centerTitle: false,
        toolbarHeight: 64,
        title: Row(
          children: [
            const Text('🍜', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              'LokaFood',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          if (userVm.isAdmin)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kSecondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const Icon(Icons.admin_panel_settings,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('Admin',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: userVm.isAdmin
          ? FloatingActionButton.extended(
              backgroundColor: kPrimary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('Tambah Kuliner',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahKulinerScreen()),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + Search
            Container(
              color: kPrimary,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Halo, ${user.displayName ?? 'Pengguna'} 👋',
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                  ],
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ExploreScreen())),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search_rounded, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            'Cari kuliner daerah...',
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Banner
            SizedBox(
              height: 190,
              child: PageView.builder(
                itemCount: _banners.length,
                itemBuilder: (context, index) {
                  final b = _banners[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    decoration: BoxDecoration(
                      color: b['color'],
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  b['title'],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  b['sub'],
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 14),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const ExploreScreen())),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      'Jelajahi',
                                      style: GoogleFonts.poppins(
                                        color: kPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(b['emoji'],
                              style: const TextStyle(fontSize: 64)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Kategori
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Jelajah Berdasarkan Daerah',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _kategori.length,
                itemBuilder: (context, index) {
                  final isFirst = index == 0;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExploreScreen(
                            initialFilter: _filterNames[index],
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isFirst ? kPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: kPrimary, width: 1.5),
                          boxShadow: isFirst
                              ? [
                                  BoxShadow(
                                    color: kPrimary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          _kategori[index],
                          style: GoogleFonts.poppins(
                            color: isFirst ? Colors.white : kPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Kuliner Populer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kuliner Populer',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploreScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Lihat Semua',
                        style: GoogleFonts.poppins(
                          color: kPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            StreamBuilder<List<KulinerModel>>(
              stream: vm.watchKuliner(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(color: kPrimary),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('🍽️', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada data kuliner.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final list = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      _KulinerCard(kuliner: list[index]),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }
}

class _KulinerCard extends StatelessWidget {
  final KulinerModel kuliner;
  const _KulinerCard({required this.kuliner});

  // 3 warna card sesuai palet
  static const List<Color> _colors = [
    Color(0xFF869B7E),
    Color(0xFFC9CAAC),
    Color(0xFFF6F3EB),
  ];

  @override
  Widget build(BuildContext context) {
    final colorIndex = kuliner.id.hashCode.abs() % _colors.length;
    final color = _colors[colorIndex];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(kuliner: kuliner)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: kuliner.imagePath.startsWith('http')
                  ? Image.network(
                      kuliner.imagePath,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildEmojiBox(color),
                    )
                  : Image.asset(
                      kuliner.imagePath,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildEmojiBox(color),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kuliner.nama,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${kuliner.daerah}, ${kuliner.provinsi}',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFF39C12), size: 16),
                      Text(
                        ' ${kuliner.rating}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7F2020).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          kuliner.pulau,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF7F2020),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF7F2020).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.chevron_right,
                  color: Color(0xFF7F2020), size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiBox(Color color) {
    return Container(
      width: 90,
      height: 90,
      color: color.withOpacity(0.3),
      child: Center(
          child: Text(_getEmoji(kuliner.pulau),
              style: const TextStyle(fontSize: 38))),
    );
  }

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
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: kPrimary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle:
              GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded), label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded), label: 'Rute'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
          onTap: (index) {
            if (index == currentIndex) return;
            if (index == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false);
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ExploreScreen()));
            } else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RouteScreen()));
            } else if (index == 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }
          },
        ),
      ),
    );
  }
}