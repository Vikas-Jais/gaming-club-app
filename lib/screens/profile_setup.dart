import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String get gameName {
    switch (widget.game) {
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

  Future<bool> _playerIdExists(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection("players").doc(id).get();
    return doc.exists;
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
      if (await _playerIdExists(pid)) {
        setState(() {
          loading = false;
          error = "Player ID already taken";
        });
        return;
      }

      final user = FirebaseAuth.instance.currentUser!;
      final userRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid);

      // Create profile for this game
      await userRef.set({
        "profiles": {
          widget.game: {
            "ign": ign,
            "playerId": pid,
            "rank": "Unranked",
            "xp": 0,
            "level": 1,
            "badge": "Rookie",
            "createdAt": FieldValue.serverTimestamp(),
          }
        }
      }, SetOptions(merge: true));

      // Global unique registry
      await FirebaseFirestore.instance
          .collection("players")
          .doc(pid)
          .set({"uid": user.uid, "game": widget.game});

      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      setState(() {
        loading = false;
        error = "Something went wrong";
      });
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
                _input("Player ID (Unique)", _idCtrl),

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
                                letterSpacing: 2),
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
