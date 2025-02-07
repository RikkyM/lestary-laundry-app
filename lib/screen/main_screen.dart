import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/auth/login_screen.dart';
import 'package:lestary_laundry_apps/services/auth_service.dart';

final AuthService _authService = AuthService();

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('admin'),
            ElevatedButton(
                onPressed: () {
                  _authService.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text('Log Out'))
          ],
        ),
      ),
    );
  }
}


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('user'),
            ElevatedButton(
                onPressed: () {
                  _authService.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text('Log Out'))
          ],
        ),
      ),
    );
  }
}