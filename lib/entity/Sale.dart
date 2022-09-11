
import 'package:equatable/equatable.dart';

class Sale extends Equatable {
  final int id;
  final String name;
  final int quantity;
  final double salary;

  const Sale({
    required this.id, required this.name, required this.salary,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [id, name];
}
