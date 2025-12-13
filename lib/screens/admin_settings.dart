import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin Settings ⚙️"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [

            _SettingTile(title: "Enable Tournaments"),
            _SettingTile(title: "Enable Live Matches"),
            _SettingTile(title: "Maintenance Mode"),
            _SettingTile(title: "Allow User Registration"),

          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;

  const _SettingTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Switch(
            value: true,
            onChanged: (value) {},
            activeColor: Colors.cyanAccent,
          )
        ],
      ),
    );
  }
}
