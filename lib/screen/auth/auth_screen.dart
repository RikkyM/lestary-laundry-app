import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/auth/login_screen.dart';
import 'package:lestary_laundry_apps/screen/main_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;

            if (user == null) {
              return const LoginScreen();
            }

            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get(),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
                    String role = roleSnapshot.data!['role'];

                    switch (role) {
                      case 'admin':
                        return const AdminScreen();
                      case 'user':
                        return const UserScreen();
                      default:
                        return const LoginScreen();
                    }
                  }

                  return const LoginScreen();
                });
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
