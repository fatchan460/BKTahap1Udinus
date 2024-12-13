import 'package:flutter/material.dart';
import 'package:flutter_dblocal_sqflite/models/product_model.dart';
import 'package:flutter_dblocal_sqflite/pages/home_page.dart';
import '../config/db_helper.dart';
import '../models/transaction_model.dart';

class RiwayatPage extends StatefulWidget {
  final ProductModel product;
  const RiwayatPage({super.key, required this.product});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();

}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<TransactionModel>> _transactions;

  final _formkey = GlobalKey<FormState>();

  late final String _name;
  late final String _stock;
  late final int _idProduct;
  late final int _totalPrice;
  late final String _description;

  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _jumlahController.dispose();
    _tanggalController.dispose();
    _totalPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _stock = widget.product.stock.toString();
    _idProduct = widget.product.id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formkey, // Hubungkan dengan GlobalKey
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name : $_name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stock : $_stock',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tanggalController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jumlahController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah is required';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Enter a valid jumlah';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'TotalPrice is required';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Enter a valid total';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jumlahController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Enter a valid description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState?.validate() ?? false) {
                          final transaksi = TransactionModel(
                            productName: _name,
                            productId: _idProduct,
                            quantity: int.parse(_jumlahController.text),
                            date: _tanggalController.text,
                            totalPrice: int.parse(_totalPriceController.text),
                            description: _descriptionController.text,
                            typetransaction: "keluar",
                          );

                          final response =
                          await DbHelper().addTransaction(transaksi);

                          if (response > 0) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Transaksi added successfully'),
                              ),
                            );

                            _jumlahController.clear();
                            _tanggalController.clear();

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                                  return const HomePage();
                                }));
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Failed transaksi'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Keluar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState?.validate() ?? false) {
                          final transaksi = TransactionModel(
                            productId: _idProduct,
                            productName: _name,
                            quantity: int.parse(_jumlahController.text),
                            date: _tanggalController.text,
                            totalPrice: int.parse(_totalPriceController.text),
                            description: _descriptionController.text,
                            typetransaction: "masuk",
                          );

                          final response =
                          await DbHelper().addTransaction(transaksi);

                          if (response > 0) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Transaksi added successfully'),
                              ),
                            );

                            _jumlahController.clear();
                            _tanggalController.clear();

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                                  return const HomePage();
                                }));
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Failed transaksi'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Masuk'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
