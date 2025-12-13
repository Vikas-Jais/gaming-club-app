import 'package:flutter/material.dart';
import '../api/valorant_api.dart';

class ValorantLeaderboardScreen extends StatelessWidget {
  const ValorantLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = [
      {"name": "AceMaster", "rank": "Radiant"},
      {"name": "Shadow", "rank": "Immortal"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Valorant Leaderboard 🥇"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final p = players[index];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (p["name"] ?? "").toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (p["rank"] ?? "").toString(),
                  style: const TextStyle(color: Colors.cyanAccent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
