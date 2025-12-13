import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/valorant_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ValorantConnectScreen extends StatefulWidget {
  const ValorantConnectScreen({super.key});

  @override
  State<ValorantConnectScreen> createState() => _ValorantConnectScreenState();
}

class _ValorantConnectScreenState extends State<ValorantConnectScreen> {
  final nameController = TextEditingController();
  final tagController = TextEditingController();
  String region = "ap";

  bool loading = false;

  Future<void> saveValorantID() async {
    setState(() => loading = true);

    final name = nameController.text.trim();
    final tag = tagController.text.trim();

    // Verify account exists
    final account = await ValorantApi.getAccount(name, tag);

    if (account == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Riot ID ❌")),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "valorantName": name,
      "valorantTag": tag,
      "valorantRegion": region,
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Riot ID connected ✔")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Connect Riot ID"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input(nameController, "Riot Name (e.g. Tenz)"),
            _input(tagController, "Tag (e.g. 777)"),

            DropdownButton<String>(
              dropdownColor: Colors.black,
              value: region,
              items: const [
                DropdownMenuItem(value: "ap", child: Text("Asia Pacific", style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: "na", child: Text("North America", style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: "eu", child: Text("Europe", style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: "asia", child: Text("Asia", style: TextStyle(color: Colors.white))),
              ],
              onChanged: (v) => setState(() => region = v!),
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                    onPressed: saveValorantID,
                    child: const Text("Connect", style: TextStyle(color: Colors.black)),
                  )
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent),
          ),
        ),
      ),
    );
  }
}
