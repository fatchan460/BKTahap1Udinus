import 'dart:convert';

class TransactionModel {
  final int? id;
  final int productId;
  final String productName;
  final int quantity;
  final int totalPrice;
  final String date;
  final String description;
  final String typetransaction;

  TransactionModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    required this.description,
    required this.typetransaction,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'date': date,
      'description': description,
      'typetransaction' : typetransaction,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      productName: map['productName'] as String,
      quantity: map['quantity'] as int,
      totalPrice: map['totalPrice'] as int,
      date: (map['date'] as String),
      description: map['description'] as String? ?? '',
      typetransaction: map['typetransaction'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
