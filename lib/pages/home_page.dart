import 'package:flutter/material.dart';
import 'package:flutter_dblocal_sqflite/pages/edit_page.dart';
import 'package:flutter_dblocal_sqflite/pages/detail_page.dart';

import '../config/db_helper.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _products = DbHelper().getProducts();
  }

  Future<List<TransactionModel>> fetchTransactionsForProduct(int? productId) async {
    if (productId == null) {
      throw Exception('Invalid product ID: $productId');
    }

    try {
      final transactions = await DbHelper().getTransactions(productId);
      return transactions;
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Inventory System'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Product found'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                mainAxisExtent: 270,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: products[index].image != null
                              ? Image.memory(
                            products[index].image!,
                            fit: BoxFit.cover,
                          )
                              : const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(products[index].name),
                        Text('Price: ${products[index].price}'),
                        Text('Stock: ${products[index].stock}'),
                        Text('Description: ${products[index].description}'),
                        const SizedBox(height: 10),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return EditPage(product: products[index]);
                                      }));
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return DetailPage(
                                      product: products[index],
                                      transaksi: fetchTransactionsForProduct(products[index].id),
                                    );
                                  }));
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.info,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final response = await DbHelper().delete(products[index]);

                                  if (response == 1) {
                                    setState(() {
                                      _products = DbHelper().getProducts();
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                            'Berhasil menghapus product ${products[index].name}'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Gagal menghapus product ${products[index].name}'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
