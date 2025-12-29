import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
