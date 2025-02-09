import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/user/order_details.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Please login to view your history."));
    }

    String truncateAddress(String address, int wordLimit) {
      List<String> words =
          address.split(' '); // Pisahkan alamat menjadi kata-kata
      if (words.length > wordLimit) {
        return '${words.sublist(0, wordLimit).join(' ')}...'; // Gabungkan 10 kata pertama dengan "..."
      }
      return address; // Jika kurang dari 10 kata, tampilkan utuh
    }


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          final orders = snapshot.data!.docs;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;

              final Timestamp? timestamp = order['timestamp'] as Timestamp?;
              final String formattedDate = timestamp != null
                  ? "${timestamp.toDate().day.toString().padLeft(2, '0')}-"
                      "${timestamp.toDate().month.toString().padLeft(2, '0')}-"
                      "${timestamp.toDate().year}"
                  : 'No Date';

              return Card(
                color: Colors.transparent,
                elevation: 0,
                child: ListTile(
                  title: Text("Status: ${order['status']}"),
                  subtitle: Text(
                    "Tanggal: $formattedDate\nAlamat: ${truncateAddress(order['address'], 10)}",
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailsScreen(orderData: order),
                      ),
                    );
                  },
                ),
              );

            },
          );

        },
      ),
    );
  }
}
