
import 'package:equatable/equatable.dart';

import 'ProtocolProduct.dart';
import '../Config.dart';

class Service extends Equatable {
  final int id;
  final int ownerId;
  final int repositoryId;
  final double price;
  final String label;
  final String inCode;
  final String repositoryName;

  int count;
  bool isSelected;
  List<ProtocolProduct> protocol;

  Service({
    required this.id, required this.label, this.isSelected=false,
    required this.inCode, required this.price, required this.protocol,
    required this.ownerId, required this.count, required this.repositoryId,
    required this.repositoryName,
  });

  factory Service.fromJson(Map<String, dynamic> json) {

    return Service(
      id: json['Id'], inCode: json['InCode'], ownerId: json['OwnerId'],
      label: json['ShortName'].isEmpty ? json['FullName'] : json['ShortName'],
      price: json['Price'], repositoryId: json['HierarchyId'],
      repositoryName: json['HierarchyName'],
      protocol: const [], count: 1,
    );
  }

  void refreshCount() {
    count = 1;
    if (protocol.isNotEmpty) {
      for (final ProtocolProduct item in protocol) {
        item.currentQuantity = item.initialQuantity;

        if (item.children.isNotEmpty) {
          for (var element in item.children) {
            element.currentQuantity = 0;
          }

          final ProtocolProductChild costChild = item.children.first;
          costChild.currentQuantity = costChild.initialQuantity;
        }
      }
    }
  }

  String getPriceInString() {
    return (price * count).toString().replaceAll(Config.findTrailingZeros, '');
  }

  @override
  List<Object?> get props => [id, label];
}
