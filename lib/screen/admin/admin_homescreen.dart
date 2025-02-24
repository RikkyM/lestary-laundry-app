import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/admin/order_screen.dart';

class AdminHomescreen extends StatefulWidget {
  const AdminHomescreen({super.key});

  @override
  State<AdminHomescreen> createState() => _AdminHomescreenState();
}

class _AdminHomescreenState extends State<AdminHomescreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String activeTab = "incoming"; // Tab aktif: "incoming" atau "completed"

  void updateOrderStatus(String orderId, String currentStatus) async {
    String nextStatus;

    // Tentukan status berikutnya berdasarkan status saat ini
    switch (currentStatus) {
      case "menunggu kurir":
        nextStatus = "laundry sudah di pick up oleh kurir";
        break;
      case "laundry sudah di pick up oleh kurir":
        nextStatus = "sedang dicuci";
        break;
      case "sedang dicuci":
        nextStatus = "dikirim";
        break;
      case "dikirim":
        nextStatus = "selesai";
        break;
      default:
        return;
    }

    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': nextStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status pesanan diperbarui ke "$nextStatus"')),
      );

      // Jika status berubah menjadi "sedang dicuci", arahkan ke OrderScreen
      if (nextStatus == "sedang dicuci") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrderScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status pesanan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => activeTab = "incoming"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: activeTab == "incoming"
                        ? const Color(0xffEF6A7F)
                        : Colors.transparent,
                  ),
                  child: Text(
                    "Incoming Delivery",
                    style: TextStyle(
                      color:
                          activeTab == "incoming" ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => setState(() => activeTab = "completed"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: activeTab == "completed"
                        ? const Color(0xffEF6A7F)
                        : Colors.transparent,
                  ),
                  child: Text(
                    "Completed Delivery",
                    style: TextStyle(
                      color: activeTab == "completed"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('orders')
                  .where('status',
                      isEqualTo:
                          activeTab == "incoming" ? "menunggu kurir" : "selesai")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Tidak ada pesanan."));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final order = doc.data() as Map<String, dynamic>;
                    final String orderId = doc.id;
                    final String status = order['status'] ?? "Unknown";
                    final String pickupAddress =
                        order['address'] ?? "No Address";
                    final String deliveryAddress =
                        order['address'] ?? "No Address";

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
                            Text(
                              "Pickup Address: $pickupAddress",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Delivery Address: $deliveryAddress",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Status: $status",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            // Hanya tampilkan tombol jika status bukan "selesai"
                            if (status != "selesai")
                              ElevatedButton(
                                onPressed: () =>
                                    updateOrderStatus(orderId, status),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  status == "menunggu kurir"
                                      ? "Start Pick Up"
                                      : status ==
                                              "laundry sudah di pick up oleh kurir"
                                          ? "Sedang Dicuci"
                                          : status == "sedang dicuci"
                                              ? "Dikirim"
                                              : "Selesai",
                                  style: const TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
