import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameSelectScreen extends StatefulWidget {
  const GameSelectScreen({super.key});

  @override
  State<GameSelectScreen> createState() => _GameSelectScreenState();
}

class _GameSelectScreenState extends State<GameSelectScreen> {
  int hovered = -1;

  final List<Map<String, dynamic>> games = [
    {
      "name": "BGMI",
      "type": "Battle Royale",
      "image": "assets/games/bgmi.jpg",
      "color": Colors.orangeAccent
    },
    {
      "name": "Valorant",
      "type": "Tactical Shooter",
      "image": "assets/games/valorant.jpg",
      "color": Colors.cyanAccent
    },
    {
      "name": "COD",
      "type": "FPS Combat",
      "image": "assets/games/cod.jpg",
      "color": Colors.redAccent
    },
    {
      "name": "Free Fire",
      "type": "Mobile Battle",
      "image": "assets/games/freefire.jpg",
      "color": Colors.amberAccent
    },
  ];

  // 🔥 THIS IS THE CRITICAL FIX
  Future<void> _selectGame(String game) async {
    SystemSound.play(SystemSoundType.click);

    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;

    final userDoc = await db.collection("users").doc(user.uid).get();

    // Save selected game
    await db.collection("users").doc(user.uid).set({
      "selectedGame": game,
    }, SetOptions(merge: true));

    final data = userDoc.data() ?? {};
    final profiles = data["profiles"] ?? {};

    // Check if profile already exists for this game
    if (profiles[game] != null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/profile-setup");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          const AnimatedBackground(),

          Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "SELECT PROTOCOL",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Choose your battleground",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 30),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: _PremiumCard(
                        data: games[index],
                        isHover: hovered == index,
                        onHover: (h) => setState(() => hovered = h ? index : -1),
                        onTap: () => _selectGame(games[index]["name"]),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

/* ---------------- PREMIUM TILT CARD ---------------- */

class _PremiumCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isHover;
  final Function(bool) onHover;
  final VoidCallback onTap;

  const _PremiumCard(
      {required this.data,
      required this.isHover,
      required this.onHover,
      required this.onTap});

  @override
  State<_PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<_PremiumCard> {
  double dx = 0, dy = 0;

  @override
  Widget build(BuildContext context) {
    final Color glow = widget.data["color"];

    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) {
        widget.onHover(false);
        setState(() {
          dx = 0;
          dy = 0;
        });
      },
      onHover: (e) {
        final size = context.size!;
        setState(() {
          dx = (e.localPosition.dx - size.width / 2) / 40;
          dy = (e.localPosition.dy - size.height / 2) / 40;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 300,
          height: 420,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateX(-dy * pi / 180)
            ..rotateY(dx * pi / 180)
            ..scale(widget.isHover ? 1.06 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: glow.withOpacity(widget.isHover ? 0.7 : 0.3),
                blurRadius: widget.isHover ? 35 : 18,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                    child:
                        Image.asset(widget.data["image"], fit: BoxFit.cover)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: glow,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(widget.data["type"],
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 26,
                  child: Text(
                    widget.data["name"],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: glow,
                      shadows: [
                        Shadow(color: glow.withOpacity(0.8), blurRadius: 20)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- BACKGROUND FX ---------------- */

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 20))
        ..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return CustomPaint(
          painter: _BGFX(_ctrl.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class _BGFX extends CustomPainter {
  final double t;
  _BGFX(this.t);

  @override
  void paint(Canvas c, Size s) {
    final paint = Paint()..color = Colors.cyanAccent.withOpacity(0.06);
    for (int i = 0; i < 40; i++) {
      final x = (s.width * (i / 40)) + sin(t * 5 + i) * 50;
      final y = (s.height * ((i * 17) % 40) / 40) + cos(t * 4 + i) * 50;
      c.drawCircle(Offset(x, y), 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BGFX old) => true;
}
