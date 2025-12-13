import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Player Profile 🎮"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.cyanAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🎮 Avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F5FF), Color(0xFF00B4D8)],
                ),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.cyanAccent, size: 60),
              ),
            ),

            const SizedBox(height: 20),

            // 🧑 Username
            Text(
              user?.email ?? "Pro Gamer",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🏆 Rank
            const Text(
              "Rank: Rookie  •  Level 1",
              style: TextStyle(color: Colors.cyanAccent),
            ),

            const SizedBox(height: 30),

            // 📊 Stats
            Row(
              children: [
                _buildStatCard("Matches", "24"),
                const SizedBox(width: 10),
                _buildStatCard("Wins", "9"),
                const SizedBox(width: 10),
                _buildStatCard("K/D", "1.3"),
              ],
            ),

            const SizedBox(height: 30),

            // 🎯 Achievements
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "🏆 Achievements",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("• First Blood", style: TextStyle(color: Colors.white70)),
                  Text("• Tournament Winner",
                      style: TextStyle(color: Colors.white70)),
                  Text("• MVP Award", style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF00F5FF), Color(0xFF00B4D8)],
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
