import 'package:flutter/material.dart';
import '../api/valorant_api.dart';

class ValorantMatchesScreen extends StatefulWidget {
  const ValorantMatchesScreen({super.key});

  @override
  State<ValorantMatchesScreen> createState() => _ValorantMatchesScreenState();
}

class _ValorantMatchesScreenState extends State<ValorantMatchesScreen> {
  bool loading = true;
  String error = "";
  List<dynamic> matches = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  // ==========================
  // UNIVERSAL SAFE PARSER
  // ==========================
  List<dynamic> extractList(dynamic res) {
    if (res == null) return [];

    // CASE 1 → Direct List
    if (res is List) return res;

    // CASE 2 → Map with any list inside
    if (res is Map) {
      for (final value in res.values) {
        if (value is List) {
          return value;
        }
      }
    }

    // CASE 3 → Single map → wrap in list
    if (res is Map) return [res];

    // Fallback
    return [];
  }

  Future<void> fetchMatches() async {
    try {
      final res = await ValorantApi.getMatchHistory("ap", "dummy", "0000");

      setState(() {
        matches = extractList(res);
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Match History"),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
              : matches.isEmpty
                  ? const Center(
                      child: Text(
                        "No matches found.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final raw = matches[index];

                        // If not map → print directly
                        if (raw is! Map) {
                          return _rawCard(raw);
                        }

                        final m = raw;

                        final mapName = m["map"] ??
                            m["metadata"]?["map"] ??
                            "Unknown";

                        final mode = m["mode"] ??
                            m["metadata"]?["mode"] ??
                            "Unknown";

                        final red = m["teams"]?["red"]?["rounds_won"]?.toString() ?? "-";
                        final blue = m["teams"]?["blue"]?["rounds_won"]?.toString() ?? "-";

                        final score = "$red - $blue";

                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121826),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mapName,
                                style: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Mode: $mode",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Score: $score",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _rawCard(dynamic raw) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121826),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
      ),
      child: Text(
        raw.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
