// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> saveValorantProfile({
    required String uid,
    required String name,
    required String tag,
    Map<String, dynamic>? mmr,
    Map<String, dynamic>? account,
  }) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    final payload = {
      'valorant': {
        'name': name,
        'tag': tag,
        'mmr': mmr ?? {},
        'account': account ?? {},
        'lastUpdated': FieldValue.serverTimestamp(),
      }
    };
    await doc.set(payload, SetOptions(merge: true));
  }
}
