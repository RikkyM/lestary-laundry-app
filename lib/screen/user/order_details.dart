import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final items = orderData['items'] as Map<String, dynamic>;
    final String formattedDate = orderData['timestamp'] != null
        ? "${orderData['timestamp'].toDate().day.toString().padLeft(2, '0')}-"
            "${orderData['timestamp'].toDate().month.toString().padLeft(2, '0')}-"
            "${orderData['timestamp'].toDate().year}"
        : 'No Date';

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal: $formattedDate",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Status: ${orderData['status']}",
                style: const TextStyle(fontSize: 16)),
            Text("Alamat: ${orderData['address']}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Detail Item:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: items.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Text("${entry.value} pcs"),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
