import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WashScreen extends StatefulWidget {
  const WashScreen({super.key});

  @override
  State<WashScreen> createState() => _WashScreenState();
}

class _WashScreenState extends State<WashScreen> {
  final Map<String, int> items = {
    'T-Shirt': 0,
    'Jaket': 0,
    'Kemeja': 0,
    'Celana Pendek': 0,
    'Celana Panjang': 0,
    'Sepatu': 0,
  };

  final Map<String, int> itemPrices = {
    'T-Shirt': 7000,
    'Jaket': 15000,
    'Kemeja': 7000,
    'Celana Pendek': 6000,
    'Celana Panjang': 9000,
    'Sepatu': 10000,
  };

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  int get totalPrice {
    int total = 0;
    items.forEach((key, quantity) {
      total += quantity * (itemPrices[key] ?? 0);
    });
    return total;
  }

  void saveOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus login untuk memesan.')),
      );
      return;
    }

    if (items.values.every((quantity) => quantity == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal 1 item!')),
      );
      return;
    }

    if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan alamat yang valid!')),
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor handphone yang valid!')),
      );
      return;
    }

    final order = {
      'items': items,
      'prices': itemPrices,
      'totalPrice': totalPrice,
      'address': addressController.text.trim(),
      'phone': phoneController.text.trim(),
      'userId': user.uid,
      'status': 'menunggu kurir',
      'layanan': 'cuci',
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('orders').add(order);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan pesanan, coba lagi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Mencegah overflow karena keyboard
      appBar: AppBar(
        title: const Text('Wash'),
      ),
      body: SingleChildScrollView(
        // Membuat tampilan bisa discroll
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih pakaian yang akan di cuci:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Agar tidak bentrok dengan scroll utama
              children: items.entries.map((entry) {
                return Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.local_laundry_service),
                    title: Text(entry.key),
                    subtitle: Text('Harga: Rp${itemPrices[entry.key]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (items[entry.key]! > 0) {
                                items[entry.key] = items[entry.key]! - 1;
                              }
                            });
                          },
                        ),
                        Text(
                          '${entry.value}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              items[entry.key] = items[entry.key]! + 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Total Harga:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp$totalPrice',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Masukkan alamat penjemputan dan pengiriman:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const Text(
              'Masukkan nomor handphone:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor handphone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16), // Tambahkan sedikit jarak
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: saveOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff5CB799),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Simpan Pesanan',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
