import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'routes.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const FutureGamingApp());
}



class FutureGamingApp extends StatelessWidget {
  const FutureGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FutureGaming',
      theme: ThemeData.dark(),
      routes: AppRoutes.routes,
      initialRoute: '/login',
    );

  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🎮 FutureGaming - IET DAVV"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          menuButton(context, "🏆 Tournaments"),
          menuButton(context, "📊 Leaderboard"),
          menuButton(context, "🔥 Free Games"),
          menuButton(context, "👨‍💻 Admin Panel"),
        ],
      ),
    );
  }

  Widget menuButton(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          minimumSize: const Size(double.infinity, 60),
        ),
        onPressed: () {},
        child: Text(title, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
