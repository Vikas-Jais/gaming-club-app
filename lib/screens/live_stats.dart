import 'package:flutter/material.dart';

class LiveStatsScreen extends StatelessWidget {
  const LiveStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Live Game Stats 📊"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔴 LIVE Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.redAccent, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Text(
                "LIVE NOW 🔴",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ⚡ Stats Row
            Row(
              children: const [
                _StatBox(title: "Kills", value: "14"),
                SizedBox(width: 12),
                _StatBox(title: "Deaths", value: "4"),
                SizedBox(width: 12),
                _StatBox(title: "Assists", value: "9"),
              ],
            ),

            const SizedBox(height: 30),

            // 🎯 Performance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F5FF), Color(0xFF00B4D8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.35),
                    blurRadius: 14,
                  )
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    "🎯 Performance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _PerfRow("K/D Ratio", "3.5"),
                  _PerfRow("Accuracy", "78%"),
                  _PerfRow("Headshots", "6"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📡 Live Activity Feed
            SizedBox(
              height: 320,
              child: ListView(
                children: const [
                  _LiveFeed(text: "🔥 You eliminated Enemy_01"),
                  _LiveFeed(text: "🏆 Captured Zone A"),
                  _LiveFeed(text: "⚡ Double Kill"),
                  _LiveFeed(text: "🎯 Assist on Enemy_07"),
                  _LiveFeed(text: "💥 UAV Activated"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ⚡ Small Stat Box
class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF020617),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.15),
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 🎯 Performance Row
class _PerfRow extends StatelessWidget {
  final String title;
  final String value;

  const _PerfRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          Text(value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}

// 📡 Live Feed Item
class _LiveFeed extends StatelessWidget {
  final String text;

  const _LiveFeed({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.08),
            blurRadius: 6,
          )
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
