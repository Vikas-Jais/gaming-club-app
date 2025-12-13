import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF020617),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final game = snapshot.data!['selectedGame'] ?? "BGMI";
        final gameKey = _mapGameToKey(game);

        return Scaffold(
          backgroundColor: const Color(0xFF020617),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("$game Tournaments 🎮"),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tournaments')
                .doc(gameKey)
                .collection('items')
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snap.data!.docs;

              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No tournaments available",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: docs.map((d) {
                  final t = d.data() as Map<String, dynamic>;

                  return _tournamentCard(
                    t['name'],
                    t['prize'] ?? "N/A",
                    t['date'] ?? "Soon",
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  String _mapGameToKey(String game) {
    switch (game) {
      case "BGMI":
        return "bgmi";
      case "Valorant":
        return "valorant";
      default:
        return "bgmi";
    }
  }

  Widget _tournamentCard(String title, String prize, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text("Prize: $prize", style: const TextStyle(color: Colors.cyanAccent)),
          Text("Date: $date", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
            ),
            child: const Text("Join", style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}
