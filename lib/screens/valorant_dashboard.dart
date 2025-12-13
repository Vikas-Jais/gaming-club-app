import 'package:flutter/material.dart';

class ValorantDashboardScreen extends StatelessWidget {
  const ValorantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Valorant")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _tile(context, "Rank", Icons.emoji_events, '/valorant-rank'),
            _tile(context, "Match History", Icons.history, '/valorant-history'),
            _tile(context, "Live Match", Icons.live_tv, '/valorant-live'),
            _tile(context, "Agents", Icons.person, '/valorant-agents'),
            _tile(context, "Connect Riot ID", Icons.link, '/valorant-connect'),
            _tile(context, "Leaderboard", Icons.leaderboard, '/valorant-leaderboard'),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext c, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(c, route),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.cyanAccent, size: 36),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
