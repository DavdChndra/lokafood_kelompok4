import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/kuliner_data.dart';
import '../viewmodels/rute_viewmodel.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'rute/tambah_rute_screen.dart';
import 'rute/detail_rute_screen.dart';

const _kPrimary = Color(0xFF7F2020);
const _kSecondary = Color(0xFF869B7E);
const _kBackground = Color(0xFFF6F3EB);

class RouteScreen extends StatefulWidget {
  final int initialTab;
  const RouteScreen({super.key, this.initialTab = 0});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen>
    with SingleTickerProviderStateMixin {
  int _selectedRouteIndex = 0;
  late TabController _tabController;

  // Warna kota menggunakan palet baru
  static const List<Color> _cityColors = [
    Color(0xFF7F2020),
    Color(0xFF869B7E),
    Color(0xFFC9CAAC),
  ];

  static const List<String> _cityEmojis = ['🍜', '🍢', '🥘'];

  // Warna rute card menggunakan 3 warna palet
  static const List<Color> _ruteColors = [
    Color(0xFF7F2020),
    Color(0xFF869B7E),
    Color(0xFFC9CAAC),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoute = daftarRute[_selectedRouteIndex];
    final titik = selectedRoute['titik'] as List<Map<String, String>>;
    final color = _cityColors[_selectedRouteIndex];
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final ruteVm = context.watch<RuteViewModel>();

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kPrimary,
        elevation: 2,
        toolbarHeight: 64,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Rute Kuliner',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Rute Resmi'),
            Tab(text: 'Rute Saya'),
            Tab(text: 'Komunitas'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _kPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Buat Rute',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahRuteScreen()),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1 — Rute Resmi
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: _kPrimary,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Kota',
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: daftarRute.length,
                        itemBuilder: (context, index) {
                          final rute = daftarRute[index];
                          final isSelected = _selectedRouteIndex == index;
                          return GestureDetector(
                            onTap: () => setState(
                                () => _selectedRouteIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_cityEmojis[index],
                                      style:
                                          const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    rute['kota'] as String,
                                    style: GoogleFonts.poppins(
                                      color: isSelected
                                          ? _kPrimary
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rute Kuliner ${selectedRoute['kota']}',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${titik.length} destinasi • ${selectedRoute['durasi']}',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.schedule, color: _kPrimary, size: 14),
                          Text(
                            ' ${selectedRoute['durasi']}',
                            style: GoogleFonts.poppins(
                              color: _kPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: titik.length,
                  itemBuilder: (context, index) {
                    final stop = titik[index];
                    final isLast = index == titik.length - 1;
                    return _buildTimelineItem(
                        context, stop, index, isLast, _kPrimary);
                  },
                ),
              ),
            ],
          ),

          // TAB 2 — Rute Saya
          StreamBuilder<List<RuteModel>>(
            stream: ruteVm.watchMyRute(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: _kPrimary));
              }
              final list = snapshot.data ?? [];
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🗺️',
                          style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 16),
                      Text('Belum ada rute',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                          'Tekan tombol "Buat Rute" untuk\nmembuat rute perjalanan kamu',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    _buildRuteCard(context, list[index], index),
              );
            },
          ),

          // TAB 3 — Komunitas
          StreamBuilder<List<RuteModel>>(
            stream: ruteVm.watchRuteKomunitas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: _kPrimary));
              }
              final list = snapshot.data ?? [];
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌏',
                          style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 16),
                      Text('Belum ada rute komunitas',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                          'Buat rute dan aktifkan "Bagikan ke Komunitas"\nagar bisa dilihat pengguna lain',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    _buildRuteCard(context, list[index], index),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildRuteCard(
      BuildContext context, RuteModel rute, int index) {
    final color = _ruteColors[index % _ruteColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailRuteScreen(rute: rute)),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rute.namaRute,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white70, size: 13),
                            Text(' ${rute.kota}',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(width: 10),
                            const Icon(Icons.schedule,
                                color: Colors.white70, size: 13),
                            Text(' ${rute.durasi}',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (rute.isPublic)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.public,
                              color: Colors.white, size: 12),
                          Text(' Publik',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.place, color: Colors.grey, size: 16),
                  Text(
                    ' ${rute.titik.length} destinasi',
                    style: GoogleFonts.poppins(
                        color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    'Lihat Detail →',
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, Map<String, String> stop,
      int index, bool isLast, Color color) {
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
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.35),
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
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.25),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stop['nama']!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFF39C12).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 12, color: Color(0xFFF39C12)),
                          Text(
                            ' ${stop['waktu']}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFFF39C12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  stop['keterangan']!,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
          currentIndex: 2,
          selectedItemColor: _kPrimary,
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
            if (index == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false);
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ExploreScreen()));
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