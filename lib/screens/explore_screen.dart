import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/kuliner_viewmodel.dart';
import '../models/kuliner_model.dart';
import 'detail_screen.dart';
import 'home_screen.dart';
import 'route_screen.dart';
import 'profile_screen.dart';

const _kPrimary = Color(0xFF7F2020);
const _kSecondary = Color(0xFF869B7E);
const _kSurface = Color(0xFFC9CAAC);
const _kBackground = Color(0xFFF6F3EB);

class ExploreScreen extends StatefulWidget {
  final String initialFilter;
  const ExploreScreen({super.key, this.initialFilter = 'Semua'});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 3 warna card sesuai palet
  static const List<Color> _colors = [
    Color(0xFF869B7E),
    Color(0xFFC9CAAC),
    Color(0xFFF6F3EB),
  ];

  static const List<String> _filters = [
    'Semua', 'Jawa', 'Sumatera', 'Kalimantan', 'Sulawesi', 'Papua', 'Bali'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KulinerViewModel>().setFilter(widget.initialFilter);
    });
  }

  @override
  void dispose() {
    context.read<KulinerViewModel>().setFilter('Semua');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<KulinerViewModel>();

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kPrimary,
        elevation: 2,
        toolbarHeight: 64,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Jelajahi Kuliner',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: vm.setSearch,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari nama kuliner atau daerah...',
                  hintStyle:
                      GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.grey),
                  suffixIcon: vm.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.grey),
                          onPressed: () => vm.setSearch(''),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = vm.selectedFilter == filter;
                return GestureDetector(
                  onTap: () => vm.setFilter(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? _kPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _kPrimary, width: 1.5),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _kPrimary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : _kPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // StreamBuilder
          Expanded(
            child: StreamBuilder<List<KulinerModel>>(
              stream: vm.watchKuliner(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: _kPrimary),
                  );
                }

                final allList = snapshot.data ?? [];
                final filtered = vm.applyFilter(allList);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filtered.length} kuliner ditemukan',
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('😕',
                                      style: TextStyle(fontSize: 48)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Kuliner tidak ditemukan',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.78,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final kuliner = filtered[index];
                                final colorIndex =
                                    kuliner.id.hashCode.abs() % _colors.length;
                                final color = _colors[colorIndex];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            DetailScreen(kuliner: kuliner)),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.06),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(28),
                                            ),
                                            child: kuliner.imagePath
                                                    .startsWith('http')
                                                ? Image.network(
                                                    kuliner.imagePath,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            Container(
                                                      color: color
                                                          .withOpacity(0.3),
                                                      child: Center(
                                                          child: Text(
                                                              _getEmoji(kuliner
                                                                  .pulau),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      54))),
                                                    ),
                                                  )
                                                : Image.asset(
                                                    kuliner.imagePath,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            Container(
                                                      color: color
                                                          .withOpacity(0.3),
                                                      child: Center(
                                                          child: Text(
                                                              _getEmoji(kuliner
                                                                  .pulau),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      54))),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                kuliner.nama,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                kuliner.daerah,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey[500]),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.star_rounded,
                                                      size: 14,
                                                      color: Color(
                                                          0xFFF39C12)),
                                                  Text(
                                                    ' ${kuliner.rating}',
                                                    style:
                                                        GoogleFonts.poppins(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
          currentIndex: 1,
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