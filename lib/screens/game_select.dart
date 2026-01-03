import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🔊 Native click sound
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_setup.dart';

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

  void _playClick() {
    SystemSound.play(SystemSoundType.click);
  }

  // 🔥 FIXED FLOW
  Future<void> _selectGame(String game) async {
    SystemSound.play(SystemSoundType.click);

    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Save selected game
    await userRef.set({
      "selectedGame": game.toLowerCase(),
    }, SetOptions(merge: true));

    // Check if profile already exists
    final doc = await userRef.get();
    final profiles = doc.data()?["profiles"] ?? {};

    if (profiles[game.toLowerCase()] == null) {
      // No profile → go to setup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(game: game.toLowerCase()),
        ),
      );
    } else {
      // Profile exists → go home
      Navigator.pushReplacementNamed(context, "/home");
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
              const Text(
                "Choose your battleground",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 40),

              /// Horizontal Netflix row
              Expanded(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      return RotatedBox(
                        quarterTurns: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: _card(games[index], index),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(Map<String, dynamic> g, int index) {
    final bool isHover = hovered == index;
    final Color glow = g["color"];

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = index),
      onExit: (_) => setState(() => hovered = -1),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _playClick();
          _selectGame(g["name"]);
        },
        child: AnimatedScale(
          scale: isHover ? 1.12 : 1,
          duration: const Duration(milliseconds: 250),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 300,
            height: 420,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: glow.withOpacity(isHover ? 0.9 : 0.35),
                  blurRadius: isHover ? 50 : 25,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      g["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: glow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        g["type"],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 28,
                    child: Text(
                      g["name"],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: glow,
                        shadows: [
                          Shadow(
                            color: glow.withOpacity(0.9),
                            blurRadius: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _BGFX extends CustomPainter {
  final double t;
  _BGFX(this.t);

  @override
  void paint(Canvas c, Size s) {
    final Paint glow = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.08),
          Colors.purpleAccent.withOpacity(0.05),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));

    c.drawRect(Rect.fromLTWH(0, 0, s.width, s.height), glow);

    final Paint particle = Paint()..color = Colors.cyanAccent.withOpacity(0.08);

    for (int i = 0; i < 40; i++) {
      final x = (s.width * (i / 40)) + sin(t * 6 + i) * 40;
      final y = (s.height * ((i * 19) % 40) / 40) + cos(t * 4 + i) * 40;
      c.drawCircle(Offset(x, y), 6, particle);
    }
  }

  @override
  bool shouldRepaint(covariant _BGFX old) => true;
}
