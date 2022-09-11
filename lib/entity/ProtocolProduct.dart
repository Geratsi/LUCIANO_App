
import 'package:equatable/equatable.dart';

import '../Config.dart';

class ProtocolProduct extends Equatable {

  final int id;
  final String name;
  final String unit;
  final bool needButtons;
  final double initialQuantity;
  final List<ProtocolProductChild> children = [];

  late double currentQuantity;

  ProtocolProduct({
    required this.name, required this.unit, required this.initialQuantity,
    required this.id, required this.needButtons, required this.currentQuantity,
  });

  factory ProtocolProduct.fromJson(Map<String, dynamic> json, {bool needButtons = true}) {
    final ProtocolProduct serviceCost = ProtocolProduct(
      id: json['NomenProductId'], name: json['ProductName'],
      unit: json['OkeiName'], initialQuantity: json['Quant'],
      currentQuantity: json['Quant'], needButtons: needButtons,
    );

    final List<dynamic>? childProducts = json['ChildProducts'];
    if (childProducts != null) {
      if (childProducts.isNotEmpty) {
        final Map<String, dynamic> firstItem = childProducts.removeAt(0);
        serviceCost.children.add(ProtocolProductChild(
          id: firstItem['NomenProductId'], name: firstItem['ProductName'],
          unit: serviceCost.unit, initialQuantity: serviceCost.initialQuantity,
          needButtons: needButtons, currentQuantity: serviceCost.currentQuantity,
        ));
        for (var item in childProducts) {
          serviceCost.children.add(ProtocolProductChild(
            id: item['NomenProductId'], name: item['ProductName'],
            unit: serviceCost.unit, initialQuantity: serviceCost.initialQuantity,
            needButtons: needButtons, currentQuantity: 0.0,
          ));
        }
      }
    }

    return serviceCost;
  }

  String getCurrentQuantityString() {
    return currentQuantity.toString().replaceAll(Config.findTrailingZeros, '');
  }

  @override
  List<Object?> get props => [id, name];
}

class ProtocolProductChild extends ProtocolProduct {
  ProtocolProductChild({
    required String name, required String unit, required double initialQuantity,
    required bool needButtons, required double currentQuantity, required int id,
  }) : super(
    name: name, unit: unit, initialQuantity: initialQuantity, id: id,
    needButtons: needButtons, currentQuantity: currentQuantity,
  );
}