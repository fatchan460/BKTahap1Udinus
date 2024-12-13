import 'dart:convert';
import 'dart:typed_data';

class ProductModel {
  final int? id;
  final String name;
  final int price;
  final int stock;
  final Uint8List? image;
  final String description;
  final String category;

  ProductModel(
      {this.id,
      required this.name,
      required this.price,
      required this.stock,
      this.image,
      required this.description,
      required this.category,});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'image': image,
      'description': description,
      'category' : category,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as int,
      stock: map['stock'] as int,
      image: map['image'] as Uint8List?,
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
