import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/valorant_api.dart';


class ValorantLiveScreen extends StatefulWidget {
  const ValorantLiveScreen({super.key});

  @override
  State<ValorantLiveScreen> createState() => _ValorantLiveScreenState();
}

class _ValorantLiveScreenState extends State<ValorantLiveScreen> {
  bool loading = false;
  Map<String, dynamic>? live;
  String name = '';
  String tag = '';
  String region = 'ap';

  Future<void> _loadAndFetch() async {
    setState(() => loading = true);

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      name = args['name'] ?? '';
      tag = args['tag'] ?? '';
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
        live = null;
      });
      return;
    }

    live = await ValorantApi.getLiveMatch(name, tag);

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAndFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Live Match")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : live == null
                ? Center(
                    child: Text(
                      name.isEmpty ? "No Riot ID connected" : "No live match found",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : _buildLiveView(live!),
      ),
    );
  }

  Widget _buildLiveView(Map<String, dynamic> data) {
    final meta = data['data']?['metadata'] ?? {};
    final players = data['data']?['players']?['all_players'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Map: ${meta['map'] ?? 'Unknown'}", style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Text("Match ID: ${meta['matchid'] ?? ''}", style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 18),
        const Text("Players:", style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, i) {
              final p = players[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1220),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                ),
                child: Text(
                  "${p['name']} — ${p['character']} (${p['team']})",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
