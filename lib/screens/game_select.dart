import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameSelectScreen extends StatefulWidget {
  const GameSelectScreen({super.key});

  @override
  State<GameSelectScreen> createState() => _GameSelectScreenState();
}

class _GameSelectScreenState extends State<GameSelectScreen> {
  final ScrollController _controller = ScrollController();

  final double cardWidth = 360;
  final double spacing = 30;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screen = MediaQuery.of(context).size.width;
      final start = (cardWidth + spacing) * 0 - screen / 2 + cardWidth / 2;
      _controller.jumpTo(max(0, start));
    });
  }

  double _getScale(int index) {
    if (!_controller.hasClients) return 1;

    double center =
        _controller.offset + MediaQuery.of(context).size.width / 2;

    double cardCenter =
        index * (cardWidth + spacing) + cardWidth / 2;

    double distance = (center - cardCenter).abs();
    double scale = 1 - min(distance / 800, 0.35);
    return scale;
  }

  Future<void> _selectGame(String game) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'selectedGame': game});

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "SELECT PROTOCOL",
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text("Choose your battleground",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width / 2 - cardWidth / 2,
              ),
              itemCount: games.length,
              itemBuilder: (context, i) {
                final String name = games[i]["name"] as String;
                final String type = games[i]["type"] as String;
                final String image = games[i]["image"] as String;
                final Color glow = games[i]["color"] as Color;

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final scale = _getScale(i);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: MouseRegion(
                        onEnter: (_) => setState(() => hovered = i),
                        onExit: (_) => setState(() => hovered = -1),
                        child: GestureDetector(
                          onTap: () => _selectGame(name),
                          child: Transform.scale(
                            scale: hovered == i ? scale * 1.05 : scale,
                            child: Container(
                              width: cardWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: [
                                  BoxShadow(
                                    color: glow.withOpacity(scale),
                                    blurRadius: 50,
                                    spreadRadius: 4,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(image,
                                          fit: BoxFit.cover),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.85)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 20,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: glow,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(type,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Positioned(
                                      left: 24,
                                      bottom: 28,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                          color: glow,
                                          shadows: [
                                            Shadow(
                                                color: glow,
                                                blurRadius: 30)
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
