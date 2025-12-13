import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class XPSystem {
  static Future<void> addXP(String game, int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await ref.get();

    Map<String, dynamic> data = snap.data() ?? {};

    // Create "games" key if missing
    data['games'] ??= {};

    // Create game-specific XP if missing
    data['games'][game] ??= {"xp": 0, "level": 1};

    int xp = data['games'][game]['xp'] ?? 0;
    int level = data['games'][game]['level'] ?? 1;

    // Add XP
    xp += amount;

    // LEVEL UP SYSTEM
    while (xp >= level * 100) {  
      xp -= level * 100;  
      level++;
    }

    // Update back to Firestore
    await ref.update({
      "games.$game": {"xp": xp, "level": level}
    });
  }

  static Future<Map<String, dynamic>> getGameStats(String game) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {"xp": 0, "level": 1};

    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await ref.get();
    final data = snap.data() ?? {};

    return data["games"]?[game] ?? {"xp": 0, "level": 1};
  }
}
