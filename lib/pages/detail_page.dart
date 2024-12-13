import 'package:flutter/material.dart';
import 'package:flutter_dblocal_sqflite/models/transaction_model.dart';
import '../models/product_model.dart';

class DetailPage extends StatelessWidget {
  final ProductModel product;
  final Future<List<TransactionModel>> transaksi;

  const DetailPage({super.key, required this.product, required this.transaksi});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child: product.image != null
                    ? Image.memory(
                  product.image!,
                  fit: BoxFit.cover,
                )
                    : const Icon(
                  Icons.camera_alt,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Name: ${product.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Price: ${product.price}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Stock: ${product.stock}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Description: ${product.description}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Category: ${product.category}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            FutureBuilder<List<TransactionModel>>(
              future: transaksi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Tidak ada riwayat transaksi.');
                }

                final transaksiList = snapshot.data!;

                return Column(
                  children: transaksiList.map((transaction) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                          title: Text('Tanggal: ${transaction.date}'),
                          subtitle: Text('Jumlah: ${transaction.quantity} \nJenis: ${transaction.typetransaction}')
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}
