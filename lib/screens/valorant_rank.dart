import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/valorant_api.dart';


class ValorantRankScreen extends StatefulWidget {
  const ValorantRankScreen({super.key});

  @override
  State<ValorantRankScreen> createState() => _ValorantRankScreenState();
}

class _ValorantRankScreenState extends State<ValorantRankScreen> {
  bool loading = true;
  Map<String, dynamic>? mmr;
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
        mmr = null;
      });
      return;
    }

    final res = await ValorantApi.getMMR(region, name, tag);
    setState(() {
      mmr = res;
      loading = false;
    });
  }

  Widget _badge(String? tier) {
    tier = (tier ?? 'Unknown').toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Text(
        tier,
        style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Valorant Rank")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : (mmr == null)
                ? Center(child: Text(name.isEmpty ? "No Riot ID connected" : "Unable to load rank", style: const TextStyle(color: Colors.white70)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$name#$tag", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _badge(mmr?['currenttierpatched']?.toString()),
                      const SizedBox(height: 16),
                      _rowItem("Elo", mmr?['elo']?.toString() ?? 'N/A'),
                      _rowItem("Current Season Rank", mmr?['currentseason']?.toString() ?? '-'),
                      _rowItem("Wins", mmr?['wins']?.toString() ?? '-'),
                      const SizedBox(height: 18),
                      const Text("Season Progress", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (mmr?['mmr_change_to_last'] != null) ? 0.5 : 0.0,
                        backgroundColor: Colors.white10,
                        color: Colors.cyanAccent,
                        minHeight: 8,
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
