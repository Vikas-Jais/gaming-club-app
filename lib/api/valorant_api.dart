import 'dart:convert';
import 'package:http/http.dart' as http;

class ValorantApi {
  static const String base = "https://api.henrikdev.xyz/valorant";

  // -----------------------------
  // GET ACCOUNT DETAILS
  // -----------------------------
  static Future<Map<String, dynamic>?> getAccount(String name, String tag) async {
    final url = Uri.parse("$base/v1/account/$name/$tag");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    }
    return null;
  }

  // -----------------------------
  // GET MMR / RANK
  // -----------------------------
  static Future<Map<String, dynamic>?> getMMR(String region, String name, String tag) async {
    final url = Uri.parse("$base/v2/mmr/$region/$name/$tag");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    }
    return null;
  }

  // -----------------------------
  // GET MATCH HISTORY
  // -----------------------------
  static Future<List<dynamic>?> getMatchHistory(String region, String name, String tag) async {
    final url = Uri.parse("$base/v3/matches/$region/$name/$tag");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    }
    return null;
  }

  // -----------------------------
  // GET CURRENT LIVE MATCH
  // -----------------------------
  static Future<Map<String, dynamic>?> getLiveMatch(String name, String tag) async {
    final url = Uri.parse("$base/v1/live-match/$name/$tag");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // -----------------------------
  // GET AGENTS LIST
  // -----------------------------
  static Future<List<dynamic>?> getAgents() async {
    final url = Uri.parse("$base/v1/agents");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    }
    return null;
  }
}
