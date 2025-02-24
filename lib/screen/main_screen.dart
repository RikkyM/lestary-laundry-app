import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lestary_laundry_apps/screen/admin/admin_homescreen.dart';
import 'package:lestary_laundry_apps/screen/admin/admin_profilescreen.dart';
import 'package:lestary_laundry_apps/screen/admin/order_screen.dart';
import 'package:lestary_laundry_apps/screen/user/history_screen.dart';
import 'package:lestary_laundry_apps/screen/user/user_homescreen.dart';
import 'package:lestary_laundry_apps/screen/user/user_profilescreen.dart';

// Main Admin Screen
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  String name = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  static final List<Widget> _screens = [
    const AdminHomescreen(),
    const OrderScreen(),
    const AdminProfileScreen(),
  ];

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        name = userData['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [Text('Admin Dashboard')],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: const Color(0xff5EBC9C),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.receipt, text: 'Order'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        )),
      ),
    );
  }
}

// Main User Screen
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _selectedIndex = 0;
  String name = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  List<Widget> _appBarTitles(String userName) => [
        // Home Title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              userName,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const Text('History'),
        const Text('Profile'),
      ];

  static final List<Widget> _screens = [
    const UserHomescreen(),
    const HistoryScreen(),
    const UserProfileScreen(),
  ];

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        name = userData['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _appBarTitles(name)[_selectedIndex],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: const Color(0xff5EBC9C),
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              color: Colors.black,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.list_alt, text: 'History'),
                GButton(icon: Icons.person, text: 'Profile'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )),
        ));
  }
}
