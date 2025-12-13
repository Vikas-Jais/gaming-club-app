import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Manage Users 👥"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            _UserTile(name: "Vikas Jaiswal", email: "vikas@gmail.com", role: "admin"),
            _UserTile(name: "Player One", email: "player1@gmail.com", role: "user"),
            _UserTile(name: "Player Two", email: "player2@gmail.com", role: "user"),
            _UserTile(name: "ProGamer", email: "progamer@gmail.com", role: "user"),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final String name;
  final String email;
  final String role;

  const _UserTile({
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(email,
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          Text(
            role.toUpperCase(),
            style: TextStyle(
              color: role == "admin" ? Colors.redAccent : Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
