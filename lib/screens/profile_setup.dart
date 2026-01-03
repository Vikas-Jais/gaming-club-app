import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: "us-central1");

class ProfileSetupScreen extends StatefulWidget {
  final String game; // bgmi, valorant, cod, freefire

  const ProfileSetupScreen({super.key, required this.game});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _ignCtrl = TextEditingController();
  final _idCtrl = TextEditingController();

  bool loading = false;
  String? error;

  String get gameKey => widget.game.toLowerCase();

  String get gameName {
    switch (gameKey) {
      case "bgmi":
        return "BGMI";
      case "valorant":
        return "Valorant";
      case "cod":
        return "Call of Duty";
      case "freefire":
        return "Free Fire";
      default:
        return widget.game.toUpperCase();
    }
  }

  // 🔥 Riot Verification
  Future<Map<String, dynamic>> _verifyValorant(String riotId) async {
    final parts = riotId.split("#");
    if (parts.length != 2) {
      throw Exception("INVALID_FORMAT");
    }

    final callable = functions.httpsCallable("verifyValorant");

    final res = await callable.call({
      "gameName": parts[0], // AgentX124
      "tagLine": parts[1],  // Luffy
      "region": "asia",    // ✅ THIS IS THE FIX (India / SEA routing)
    });

    // Debug log
    print("VALORANT RESPONSE => ${res.data}");

    final data = Map<String, dynamic>.from(res.data);

    if (data["success"] != true) {
      throw Exception("RIOT_NOT_FOUND");
    }

    return data;
  }

  Future<void> _submit() async {
    final ign = _ignCtrl.text.trim();
    final pid = _idCtrl.text.trim();

    if (ign.isEmpty || pid.isEmpty) {
      setState(() => error = "All fields are required");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final db = FirebaseFirestore.instance;

      // 🔥 REAL VALORANT API FLOW
      if (gameKey == "valorant") {
        if (!pid.contains("#")) {
          setState(() {
            error = "Format must be like AgentX124#Luffy";
            loading = false;
          });
          return;
        }

        final riotData = await _verifyValorant(pid);

        final puuid = riotData["puuid"];

        await db.collection("users").doc(user.uid).set({
          "profiles": {
            "valorant": {
              "ign": ign,
              "riotId": pid,
              "puuid": puuid,
              "verified": true,
              "region": riotData["region"],
              "createdAt": FieldValue.serverTimestamp(),
            }
          }
        }, SetOptions(merge: true));

        await db.collection("valorant_players").doc(puuid).set({
          "uid": user.uid,
          "riotId": pid,
          "lastSync": FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacementNamed(context, "/home");
        return;
      }

      // 🧩 Other games (BGMI / COD / FF)
      final playerRef = db.collection("players").doc(pid);
      final userRef = db.collection("users").doc(user.uid);

      await db.runTransaction((tx) async {
        final snap = await tx.get(playerRef);
        if (snap.exists) throw Exception("PLAYER_ID_EXISTS");

        tx.set(playerRef, {
          "uid": user.uid,
          "game": gameKey,
          "createdAt": FieldValue.serverTimestamp(),
        });

        tx.set(userRef, {
          "profiles": {
            gameKey: {
              "ign": ign,
              "playerId": pid,
              "rank": "Unranked",
              "xp": 0,
              "level": 1,
              "badge": "Rookie",
              "verified": false,
              "createdAt": FieldValue.serverTimestamp(),
            }
          }
        }, SetOptions(merge: true));
      });

      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      final msg = e.toString();

      if (msg.contains("INVALID_FORMAT")) {
        error = "Format must be like AgentX124#Luffy";
      } else if (msg.contains("RIOT_NOT_FOUND")) {
        error = "Valorant account not found";
      } else if (msg.contains("PLAYER_ID_EXISTS")) {
        error = "Player ID already taken";
      } else {
        error = "Verification failed. Try again.";
      }

      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 460,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF071327),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.15),
                  blurRadius: 30,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$gameName Profile",
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create your player identity",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),

                _input("In-Game Name", _ignCtrl),
                const SizedBox(height: 20),
                _input("Riot ID (AgentX124#Luffy)", _idCtrl),

                if (error != null) ...[
                  const SizedBox(height: 16),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            "CREATE PROFILE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF020617),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
