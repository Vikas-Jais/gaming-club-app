import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNewsScreen extends StatefulWidget {
  const AdminNewsScreen({super.key});

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  final newsController = TextEditingController();
  String? editingId;

  Future<void> postNews() async {
    final text = newsController.text.trim();

    if (text.isEmpty) return;

    if (editingId == null) {
      // Add new post
      await FirebaseFirestore.instance.collection('news').add({
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ News Posted")),
      );
    } else {
      // Update existing post
      await FirebaseFirestore.instance
          .collection('news')
          .doc(editingId)
          .update({
        'text': text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ News Updated")),
      );

      editingId = null;
    }

    newsController.clear();
  }

  void editNews(String id, String currentText) {
    setState(() {
      editingId = id;
      newsController.text = currentText;
    });
  }

  Future<void> deleteNews(String id) async {
    await FirebaseFirestore.instance.collection('news').doc(id).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑️ News Deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin News 📰"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✍️ Text Field
            TextField(
              controller: newsController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter announcement...",
                hintStyle: const TextStyle(color: Colors.cyanAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔘 Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: postNews,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                ),
                child: Text(
                  editingId == null ? "Post News" : "Update News",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 📰 News List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('news')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No news yet 👀",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final id = doc.id;
                      final text = doc['text'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF020617),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      editNews(id, text),
                                  icon: const Icon(Icons.edit,
                                      color: Colors.amber),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      deleteNews(id),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
