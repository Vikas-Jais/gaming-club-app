import 'package:flutter/material.dart';

class ClansScreen extends StatelessWidget {
  const ClansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Clans 👥"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 👑 Top Clan
            _clanCard(
              name: "Shadow Assassins",
              members: "28 Members",
              power: "Clan Power: 9800",
              rank: "#1",
              isTop: true,
            ),

            _clanCard(
              name: "Night Warriors",
              members: "21 Members",
              power: "Clan Power: 8700",
              rank: "#2",
            ),

            _clanCard(
              name: "Phoenix Squad",
              members: "18 Members",
              power: "Clan Power: 7900",
              rank: "#3",
            ),

            const SizedBox(height: 30),

            // ➕ Create Clan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text(
                  "Create Clan",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _clanCard({
    required String name,
    required String members,
    required String power,
    required String rank,
    bool isTop = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isTop
            ? const LinearGradient(
                colors: [Color(0xFF00F5FF), Color(0xFF00B4D8)],
              )
            : null,
        color: isTop ? null : const Color(0xFF020617),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.15),
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
              Text(
                name,
                style: TextStyle(
                  color: isTop ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                members,
                style: TextStyle(
                  color: isTop ? Colors.black87 : Colors.white70,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                power,
                style: TextStyle(
                  color: isTop ? Colors.black87 : Colors.cyanAccent,
                ),
              ),
            ],
          ),
          Text(
            rank,
            style: TextStyle(
              color: isTop ? Colors.black : Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
