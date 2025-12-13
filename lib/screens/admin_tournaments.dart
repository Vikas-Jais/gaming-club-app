import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTournamentsScreen extends StatefulWidget {
  const AdminTournamentsScreen({super.key});

  @override
  State<AdminTournamentsScreen> createState() => _AdminTournamentsScreenState();
}

class _AdminTournamentsScreenState extends State<AdminTournamentsScreen> {
  final titleController = TextEditingController();
  final maxTeamsController = TextEditingController();
  final prizeController = TextEditingController();

  String selectedGame = "BGMI"; // default selected game

  Future<void> createTournament() async {
    if (titleController.text.trim().isEmpty ||
        maxTeamsController.text.trim().isEmpty ||
        prizeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('tournaments').add({
      'title': titleController.text.trim(),
      'game': selectedGame,
      'maxTeams': int.tryParse(maxTeamsController.text.trim()) ?? 0,
      'teamsJoined': 0,
      'prize': prizeController.text.trim(),
      'status': "Upcoming",
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Tournament for $selectedGame Created!")),
    );

    titleController.clear();
    maxTeamsController.clear();
    prizeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin • Create Tournament 🎮"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ⭐ Game Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: selectedGame,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: "BGMI",
                      child: Text("BGMI"),
                    ),
                    DropdownMenuItem(
                      value: "Valorant",
                      child: Text("Valorant"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedGame = val!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              _inputField(titleController, "Tournament Title"),
              const SizedBox(height: 20),

              _inputField(maxTeamsController, "Max Teams (e.g., 50)", number: true),
              const SizedBox(height: 20),

              _inputField(prizeController, "Prize Pool (₹)", number: true),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: createTournament,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Tournament",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Divider(color: Colors.white24),

              const SizedBox(height: 10),
              const Text(
                "Existing Tournaments",
                style: TextStyle(color: Colors.cyanAccent, fontSize: 18),
              ),
              const SizedBox(height: 15),

              // Live List from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tournaments')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(color: Colors.cyanAccent);
                  }

                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${data['title']} (${data['game']})",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('tournaments')
                                    .doc(doc.id)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label,
      {bool number = false}) {
    return TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.cyanAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
