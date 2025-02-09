import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/firebase_options.dart';
import 'package:lestary_laundry_apps/screen/auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LaundryApps());
}

class LaundryApps extends StatelessWidget {
  const LaundryApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        )
      ),
      home: const AuthScreen(),
    );
  }
}