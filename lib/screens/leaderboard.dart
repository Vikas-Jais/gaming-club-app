import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Leaderboard 🥇"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🥇 Top Player Cards
            _topPlayer("1", "ShadowSlayer", "1250 XP"),
            _topPlayer("2", "NightHunter", "1120 XP"),
            _topPlayer("3", "BlazeX", "980 XP"),

            const SizedBox(height: 25),

            // 📋 Player List
            Expanded(
              child: ListView(
                children: [
                  _playerTile("4", "GhostRider", "920 XP"),
                  _playerTile("5", "DragonFury", "890 XP"),
                  _playerTile("6", "VenomStrike", "850 XP"),
                  _playerTile("7", "CyberWolf", "820 XP"),
                  _playerTile("8", "WarMachine", "790 XP"),
                  _playerTile("9", "InfernoKing", "760 XP"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topPlayer(String rank, String name, String xp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00F5FF), Color(0xFF00B4D8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.3),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "#$rank",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            xp,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _playerTile(String rank, String name, String xp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("#$rank", style: const TextStyle(color: Colors.white)),
          Text(
            name,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(xp, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
