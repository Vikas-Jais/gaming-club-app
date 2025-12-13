// lib/screens/home.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _carouselController = PageController(viewportFraction: 0.86);
  Timer? _carouselTimer;
  int _carouselIndex = 0;

  @override
  void initState() {
    super.initState();

    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_carouselController.hasClients) {
        _carouselIndex = (_carouselIndex + 1) % _carouselItems.length;
        _carouselController.animateToPage(
          _carouselIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Ongoing: Battle Royale Clash',
      'subtitle': 'BGMI • ₹10,000 • 24/50 Registered'
    },
    {
      'title': 'Valorant: Champions Cup',
      'subtitle': 'Matches live now • Watch the action'
    },
    {
      'title': 'Top Clan of the Week',
      'subtitle': 'Team Nova — 12 wins'
    },
  ];

  Future<bool> _isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data()?['role'] == 'admin';
    } catch (_) {
      return false;
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _navCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: _HoverPulseCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulseIcon(icon: icon),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context, String game) {
    Map<String, List<Map<String, dynamic>>> gameButtons = {
      "BGMI": [
        {"title": "Tournaments", "icon": Icons.emoji_events, "route": "/tournaments"},
        {"title": "Leaderboard", "icon": Icons.leaderboard, "route": "/leaderboard"},
        {"title": "Clans", "icon": Icons.groups, "route": "/clans"},
        {"title": "Live Matches", "icon": Icons.live_tv, "route": "/live"},
      ],
      "Valorant": [
        {"title": "Agents", "icon": Icons.person, "route": "/valorant-agents"},
        {"title": "Search Player", "icon": Icons.search, "route": "/valorant-search"},
        {"title": "Match History", "icon": Icons.history, "route": "/valorant-history"},
        {"title": "Live Match", "icon": Icons.live_tv, "route": "/valorant-live"},
        {"title": "Rank Info", "icon": Icons.bar_chart, "route": "/valorant-rank"},
        {"title": "Matches", "icon": Icons.list_alt, "route": "/valorant-matches"},
      ]
    };

    final buttons = gameButtons[game] ?? gameButtons['BGMI']!;
    final int crossAxis = MediaQuery.of(context).size.width > 900 ? 3 : 2;

    return GridView.count(
      crossAxisCount: crossAxis,
      shrinkWrap: true,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      physics: const NeverScrollableScrollPhysics(),
      children: buttons
          .map((b) => _navCard(context, b['title'], b['icon'], b['route']))
          .toList(),
    );
  }

  Widget _animatedGameBanner(String game) {
    final bannerData = {
      'BGMI': {
        'subtitle': 'Battle Royale • 4v4 / Solo • Tournaments',
        'start': Colors.cyanAccent,
        'end': Colors.tealAccent
      },
      'Valorant': {
        'subtitle': 'Tactical FPS • Agents • Ranked',
        'start': Colors.redAccent,
        'end': Colors.deepOrangeAccent
      }
    };

    final Map<String, Object> d = bannerData[game] ??
        {
          'subtitle': 'Multigame • Tournaments • Stats',
          'start': Colors.indigoAccent,
          'end': Colors.blueAccent
        };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            d['start'] as Color,
            d['end'] as Color,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            game == 'Valorant' ? Icons.shield : Icons.sports_esports,
            color: Colors.black,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  d['subtitle'] as String,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/game-select'),
            icon: const Icon(Icons.swap_horiz, color: Colors.black),
          )
        ],
      ),
    );
  }


  Widget _playerCard(String email, String game, int xp, int level) {
    final double progress = ((xp % 1000) / 1000).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF071025),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.black,
            child: Text(email[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('Level $level',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 10),
                    Text(game,
                        style: const TextStyle(
                            color: Colors.cyanAccent, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _carouselCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [Color(0xFF061827), Color(0xFF071b2b)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item['title']!,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(item['subtitle']!, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      floatingActionButton: FutureBuilder<bool>(
        future: _isAdmin(),
        builder: (c, snap) {
          if (!snap.hasData || !snap.data!) return const SizedBox.shrink();
          return FloatingActionButton(
            backgroundColor: Colors.cyanAccent,
            child: const Icon(Icons.admin_panel_settings, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/admin'),
          );
        },
      ),

      bottomNavigationBar: _FloatingBottomNav(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                // HEADER
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, ${user?.email?.split('@')[0] ?? "Player"} 👑',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/game-select'),
                            icon: const Icon(Icons.swap_horiz,
                                color: Colors.cyanAccent)),
                        IconButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/profile'),
                            icon: const Icon(Icons.person,
                                color: Colors.cyanAccent)),
                        IconButton(
                            onPressed: () => _signOut(context),
                            icon: const Icon(Icons.logout,
                                color: Colors.cyanAccent)),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 16),

                //
                // FIRESTORE USER STREAM
                //
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final u = snap.data!.data() as Map<String, dynamic>? ?? {};

                    final String email = u['email'] ?? user.email ?? "Gamer";
                    final String game = u['selectedGame'] ?? "BGMI";
                    final int xp = (u['xp'] is int) ? u['xp'] : 0;
                    final int level = (u['level'] is int) ? u['level'] : 1;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _animatedGameBanner(game)),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 260,
                                child:
                                    _playerCard(email, game, xp, level)),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 140,
                          child: PageView.builder(
                            controller: _carouselController,
                            itemCount: _carouselItems.length,
                            itemBuilder: (c, i) =>
                                _carouselCard(_carouselItems[i]),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildGameGrid(context, game),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ------------------------------ */
/*  Hover Card Animation Widget   */
/* ------------------------------ */

class _HoverPulseCard extends StatefulWidget {
  final Widget child;
  const _HoverPulseCard({required this.child});

  @override
  State<_HoverPulseCard> createState() => _HoverPulseCardState();
}

class _HoverPulseCardState extends State<_HoverPulseCard>
    with SingleTickerProviderStateMixin {
  bool hover = false;
  late final AnimationController ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> scale =
      Tween<double>(begin: 1.0, end: 1.03).animate(ctrl);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => hover = true);
        ctrl.forward();
      },
      onExit: (_) {
        setState(() => hover = false);
        ctrl.reverse();
      },
      child: ScaleTransition(
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1220),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.cyanAccent.withOpacity(hover ? 0.35 : 0.15)),
            boxShadow: hover
                ? [
                    BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.12),
                        blurRadius: 10)
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/* ------------------------------ */
/*           Pulse Icon           */
/* ------------------------------ */

class _PulseIcon extends StatefulWidget {
  final IconData icon;
  const _PulseIcon({required this.icon});

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
        ..repeat(reverse: true);
  late final Animation<double> anim =
      Tween<double>(begin: 1.0, end: 1.1).animate(ctrl);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: anim,
      child: Icon(widget.icon, size: 36, color: Colors.cyanAccent),
    );
  }
}

/* ------------------------------ */
/*    Floating Bottom Nav Bar     */
/* ------------------------------ */

class _FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingBottomNav(
      {required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF071327),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.06)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBtn(
                icon: Icons.home,
                label: "Home",
                idx: 0,
                current: currentIndex,
                onTap: onTap),
            _NavBtn(
                icon: Icons.videogame_asset,
                label: "Games",
                idx: 1,
                current: currentIndex,
                onTap: onTap),
            _NavBtn(
                icon: Icons.star,
                label: "Highlights",
                idx: 2,
                current: currentIndex,
                onTap: onTap),
            _NavBtn(
                icon: Icons.person,
                label: "Profile",
                idx: 3,
                current: currentIndex,
                onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final int idx;
  final int current;
  final ValueChanged<int> onTap;

  const _NavBtn(
      {required this.icon,
      required this.label,
      required this.idx,
      required this.current,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = idx == current;
    return InkWell(
      onTap: () => onTap(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: active
            ? BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(20))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? Colors.cyanAccent : Colors.white54),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.cyanAccent : Colors.white54,
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
