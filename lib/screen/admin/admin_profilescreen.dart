import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/auth/login_screen.dart';
import 'package:lestary_laundry_apps/services/auth_service.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  String name = '';
  String email = '';

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    getCurrentAdmin();
  }

  void getCurrentAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        name = userData['name'] ?? 'Admin';
        email = user.email ?? 'Tidak ada email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Profile
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xff5CB799),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Informasi Admin
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.person, color: Color(0xff5CB799)),
                        title: const Text(
                          'Nama Lengkap',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(name),
                      ),
                      const Divider(),
                      ListTile(
                        leading:
                            const Icon(Icons.email, color: Color(0xff5CB799)),
                        title: const Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(email),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Logout
              ElevatedButton(
                onPressed: () {
                  _authService.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
