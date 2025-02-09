import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/components/card/order_card.dart';
import 'package:lestary_laundry_apps/components/card/service_card.dart';
import 'package:lestary_laundry_apps/screen/user/drycleaning_screen.dart';
import 'package:lestary_laundry_apps/screen/user/folding_screen.dart';
import 'package:lestary_laundry_apps/screen/user/ironing_screen.dart';
import 'package:lestary_laundry_apps/screen/user/wash_screen.dart';

class UserHomescreen extends StatefulWidget {
  const UserHomescreen({super.key});

  @override
  State<UserHomescreen> createState() => UserHomescreenState();
}

class UserHomescreenState extends State<UserHomescreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('orders')
                  .where('userId', isEqualTo: user?.uid) // Hanya user login
                  .where('status', isEqualTo: 'menunggu kurir')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("Tidak ada pesanan.");
                }

                return SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((doc) {
                      final order = doc.data() as Map<String, dynamic>;
                      final Timestamp? timestamp =
                          order['timestamp'] as Timestamp?;
                      final String formattedDate = timestamp != null
                          ? "${timestamp.toDate().day.toString().padLeft(2, '0')}-"
                              "${timestamp.toDate().month.toString().padLeft(2, '0')}-"
                              "${timestamp.toDate().year}"
                          : 'No Date';

                      final String status = order['status'] ?? "Unknown";

                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: OrderCard(
                          name: user?.email ?? "Unknown",
                          date: formattedDate,
                          color: const Color(0xff5EBC9C),
                          status: status,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Service Grid Section
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              children: [
                ServiceCard(
                    icon: Icons.local_laundry_service,
                    label: 'Wash',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WashScreen()));
                    }),
                ServiceCard(
                    icon: Icons.iron,
                    label: 'Ironing',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IroningScreen()));
                    }),
                ServiceCard(
                    icon: Icons.dry_cleaning,
                    label: 'Dry Cleaning',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DrycleaningScreen()));
                    }),
                ServiceCard(
                    icon: Icons.wash,
                    label: 'Laundry Folding',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FoldingScreen()));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
