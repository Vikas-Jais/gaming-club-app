import 'package:flutter/material.dart';
import '../api/valorant_api.dart';

class ValorantSearchScreen extends StatefulWidget {
  const ValorantSearchScreen({super.key});

  @override
  State<ValorantSearchScreen> createState() => _ValorantSearchScreenState();
}

class _ValorantSearchScreenState extends State<ValorantSearchScreen> {

  final List<String> allPlayers = [
    "TenZ", "Asuna", "Forsaken", "ScreaM", "yay", "Leaf"
  ];

  List<String> results = [];

  void search(String query) {
    setState(() {
      results = allPlayers
          .where((p) => p.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Search Valorant Players 🔍"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search players…",
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: results.map((name) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.cyanAccent),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
