
import 'package:equatable/equatable.dart';

import '../Config.dart';

class Product extends Equatable {
  final int id;
  final String code;
  final int quantity;
  final String label;
  final double price;
  final String? sGod;

  late int count;
  late String priceInString;

  Product({
    required this.id, required this.label, required this.code, required this.sGod,
    required this.price, required this.quantity, required this.count,
  }) {
    priceInString = price.toString().replaceAll(Config.findTrailingZeros, '');
  }

  factory Product.fromJson(Map<String, dynamic> json, String code) {
    return Product(
      id: json['Id'], label: json['ProductName'], price: json['Price'],
      quantity: json['Quant'].toInt(), code: code, sGod: json['Sgod'], count: 1,
    );
  }

  @override
  List<Object?> get props => [id, label];
}
