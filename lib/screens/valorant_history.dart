import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/valorant_api.dart';


class ValorantHistoryScreen extends StatefulWidget {
  const ValorantHistoryScreen({super.key});

  @override
  State<ValorantHistoryScreen> createState() => _ValorantHistoryScreenState();
}

class _ValorantHistoryScreenState extends State<ValorantHistoryScreen> {
  bool loading = true;
  List<dynamic>? matches;
  String name = '';
  String tag = '';
  String region = 'ap';

  @override
  void initState() {
    super.initState();
    _loadAndFetch();
  }

  Future<void> _loadAndFetch() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['name'] != null && args['tag'] != null) {
      name = args['name'];
      tag = args['tag'];
      region = args['region'] ?? region;
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = doc.data() ?? {};
        name = (data['valorantName'] ?? '').toString();
        tag = (data['valorantTag'] ?? '').toString();
        region = (data['valorantRegion'] ?? region).toString();
      }
    }

    if (name.isEmpty || tag.isEmpty) {
      setState(() {
        loading = false;
        matches = null;
      });
      return;
    }

    final res = await ValorantApi.getMatchHistory(region, name, tag);
    setState(() {
      matches = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Match History")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : (matches == null || matches!.isEmpty)
                ? Center(child: Text(name.isEmpty ? "No Riot ID connected" : "No matches found", style: const TextStyle(color: Colors.white70)))
                : ListView.builder(
                    itemCount: matches!.length,
                    itemBuilder: (context, i) {
                      final m = matches![i] as Map<String, dynamic>;
                      final meta = m['metadata'] as Map<String, dynamic>? ?? {};
                      final players = m['players'] as Map<String, dynamic>? ?? {};
                      // We will show basic metadata (map/mode/matchid)
                      final map = meta['map'] ?? 'Unknown';
                      final mode = meta['mode'] ?? 'Mode';
                      final matchId = meta['matchid'] ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1220),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Map: $map", style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 6),
                            Text("Mode: $mode", style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text("Match ID: $matchId", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
