import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> updateOrderStatus(String orderId, String newStatus) async {
      try {
        await _firestore
            .collection('orders')
            .doc(orderId)
            .update({'status': newStatus});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Status pesanan berhasil diubah ke $newStatus')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui status pesanan!')),
        );
      }
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tidak ada pesanan dalam proses."));
          }

          final filteredOrders = snapshot.data!.docs.where((doc) {
            final status = doc['status'] as String;
            return status != "menunggu kurir" && status != "selesai";
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text("Tidak ada pesanan dalam proses."));
          }

          return ListView(
            children: filteredOrders.map((doc) {
              final order = doc.data() as Map<String, dynamic>;
              final String orderId = doc.id;
              final String pickupAddress = order['address'] ?? "No Address";
              final String customerName =
                  order['customerName'] ?? "Unknown Customer";
              final String currentStatus = order['status'];

              // Menentukan status berikutnya
              String nextStatus = "";
              if (currentStatus == "laundry sudah di pick up oleh kurir") {
                nextStatus = "sedang dicuci";
              } else if (currentStatus == "sedang dicuci") {
                nextStatus = "dikirim";
              } else if (currentStatus == "dikirim") {
                nextStatus = "selesai";
              }

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#$orderId",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Customer: $customerName"),
                      Text("Pickup Address: $pickupAddress"),
                      Text("Status: $currentStatus"),
                      const SizedBox(height: 16),
                      if (currentStatus !=
                          "selesai") // Hanya tampilkan tombol jika belum selesai
                        ElevatedButton(
                          onPressed: () =>
                              updateOrderStatus(orderId, nextStatus),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text(
                            'Proses',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
