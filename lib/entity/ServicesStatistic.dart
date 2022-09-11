
import 'package:equatable/equatable.dart';

import 'Sale.dart';

class ServicesStatistic extends Equatable {
  final int count;
  final double salary;
  final Iterable<Sale>? groupedServices;

  const ServicesStatistic({
    required this.count, required this.salary, this.groupedServices,
  });

  factory ServicesStatistic.fromJson(Map<String, dynamic> json) {

    return ServicesStatistic(
      count: json['ServiceCount'],
      salary: json['ServicePrice'],
      groupedServices: json['DateList'].map((item) => {
        'date': DateTime.parse(item['Date']),
        'items': item['Items'].map((sale) => Sale(
          id: sale['Id'], name: sale['Name'], salary: sale['Price'],
          quantity: sale['Count'],
        )),
      }),);
  }

  @override
  List<Object?> get props => [count, salary];
}