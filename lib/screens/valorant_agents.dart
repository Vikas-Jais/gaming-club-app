import 'package:flutter/material.dart';
import '../api/valorant_api.dart';

class ValorantAgentsScreen extends StatefulWidget {
  const ValorantAgentsScreen({super.key});

  @override
  State<ValorantAgentsScreen> createState() => _ValorantAgentsScreenState();
}

class _ValorantAgentsScreenState extends State<ValorantAgentsScreen> {
  bool loading = true;
  List<dynamic>? agents;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await ValorantApi.getAgents();
    setState(() {
      agents = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Agents")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : (agents == null || agents!.isEmpty)
                ? const Center(child: Text("No agents data", style: TextStyle(color: Colors.white70)))
                : GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: agents!.map((a) {
                      final name = a['displayName'] ?? a['name'] ?? 'Agent';
                      final role = a['role']?['displayName'] ?? '';
                      final icon = a['displayIcon'] ?? '';
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF07101A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.08)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon != ''
                                ? Image.network(icon, height: 80, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.cyanAccent, size: 52))
                                : const Icon(Icons.shield, color: Colors.cyanAccent, size: 52),
                            const SizedBox(height: 8),
                            Text(name, style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(role, style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}
