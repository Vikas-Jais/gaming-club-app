import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Future<void> selectGame(String game) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'selectedGame': game});

      Navigator.pushReplacementNamed(context, '/home');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Text(
                "Select Your Game 🎮",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              _gameTile(context, "BGMI"),
              _gameTile(context, "Valorant"),
              _gameTile(context, "League of Legends"),
              _gameTile(context, "Free Fire"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gameTile(BuildContext context, String name) {
    return GestureDetector(
      onTap: () async {
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'selectedGame': name});

        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.4)),
          color: const Color(0xFF020617),
        ),
        child: Row(
          children: [
            const Icon(Icons.sports_esports, color: Colors.cyanAccent),
            const SizedBox(width: 15),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
