import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin Panel 👨‍💻"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _adminCard(
              title: "Users",
              subtitle: "Manage all players",
              icon: Icons.people,
              onTap: () {
                Navigator.pushNamed(context, '/admin-users');
              },
            ),

            const SizedBox(height: 15),

            _adminCard(
              title: "Tournaments",
              subtitle: "Create / Edit tournaments",
              icon: Icons.emoji_events,
              onTap: () {
                Navigator.pushNamed(context, '/admin-tournaments');
              },
            ),

            const SizedBox(height: 15),

            _adminCard(
                title: "News",
                subtitle: "Post app announcements",
                icon: Icons.newspaper,
                onTap: () {
                    Navigator.pushNamed(context, '/admin-news'); // ✅ THIS LINE IS REQUIRED
                },
            ),

            const SizedBox(height: 15),

            _adminCard(
              title: "App Settings",
              subtitle: "Control app features",
              icon: Icons.settings,
              onTap: () {
                Navigator.pushNamed(context, '/admin-settings');
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _adminCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF020617),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.15),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.cyanAccent, size: 30),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
