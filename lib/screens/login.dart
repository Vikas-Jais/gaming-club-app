// lib/screens/login.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  late final AnimationController _fxController;
  late final Animation<double> _heroFloat;

  @override
  void initState() {
    super.initState();
    _fxController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);

    _heroFloat = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _fxController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fxController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // ---------------- EMAIL LOGIN ----------------
  Future<void> _signInWithEmail() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, '/game-select');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  // ---------------- SIGN UP ----------------
  Future<void> _signUpWithEmail() async {
    setState(() => loading = true);
    try {
      final cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'email': emailController.text.trim(),
        'name': nameController.text.trim(),
        'role': 'user',
        'xp': 0,
        'level': 1,
        'selectedGame': 'BGMI',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacementNamed(context, '/game-select');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  // ---------------- FORGOT PASSWORD ----------------
  Future<void> _sendPasswordReset() async {
    if (emailController.text.trim().isEmpty) {
      _showError("Enter email for reset");
      return;
    }
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Reset email sent")));
  }

  // ---------------- GOOGLE LOGIN ----------------
  Future<void> _signInWithGoogle() async {
    try {
      final gUser = await GoogleSignIn().signIn();
      if (gUser == null) return;

      final gAuth = await gUser.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(cred);

      final udoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid);

      if (!(await udoc.get()).exists) {
        await udoc.set({
          'email': userCred.user!.email,
          'name': userCred.user!.displayName ?? '',
          'role': 'user',
          'xp': 0,
          'level': 1,
          'selectedGame': 'BGMI',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Navigator.pushReplacementNamed(context, '/game-select');
    } catch (_) {
      _showError("Google Login Failed");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: Stack(
        children: [
          Positioned.fill(
              child: IgnorePointer(
                  child: CustomPaint(painter: _ParticlePainter()))),

          // ✅ HERO FIXED (FULL HEIGHT — NOT CUT ANYMORE)
          AnimatedBuilder(
            animation: _heroFloat,
            builder: (_, __) {
              return Positioned(
                bottom: -20 + _heroFloat.value,
                left: w * 0.04,
                child: Image.asset(
                  "assets/images/hero.png",
                  height: h * 0.92, // ✅ FULL SCREEN PROPORTION
                  fit: BoxFit.contain,
                ),
              );
            },
          ),

          // GLOW BEHIND PANEL
          Positioned(
            top: h * 0.2,
            right: w * 0.18,
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ✅ LOGIN PANEL
          Align(
            alignment: const Alignment(0.55, 0),
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _buildGlassPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassPanel() {
    return Container(
      key: ValueKey(isLogin),
      width: 480,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1624).withOpacity(0.76),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.18),
            blurRadius: 40,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.sports_esports, size: 56, color: Colors.cyanAccent),
        const SizedBox(height: 10),
        Text(
          isLogin ? "Welcome Back 🎮" : "Create Account 🔥",
          style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        if (!isLogin) _inputField(Icons.person, nameController, "Full name"),
        if (!isLogin) const SizedBox(height: 12),

        _inputField(Icons.email, emailController, "Email"),
        const SizedBox(height: 12),
        _inputField(Icons.lock, passwordController, "Password",
            obscure: true),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _sendPasswordReset,
              child: const Text("Forgot Password?",
                  style: TextStyle(color: Colors.cyanAccent)),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin ? "Create new account" : "Already have account?",
                style: const TextStyle(color: Colors.cyanAccent),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isLogin ? _signInWithEmail : _signUpWithEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(isLogin ? "Login" : "Sign Up",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),

        const SizedBox(height: 18),

        GestureDetector(
          onTap: _signInWithGoogle,
          child: Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('assets/images/google_logo.png', height: 20),
              const SizedBox(width: 12),
              const Text("Continue with Google",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _inputField(
      IconData icon, TextEditingController c, String hint,
      {bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A121E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: c,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.cyanAccent),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

// ---------------- PARTICLES ----------------
class _ParticlePainter extends CustomPainter {
  final Random _rand = Random();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (int i = 0; i < 40; i++) {
      final dx = _rand.nextDouble() * size.width;
      final dy = _rand.nextDouble() * size.height;
      canvas.drawCircle(
          Offset(dx, dy), _rand.nextDouble() * 3 + 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
