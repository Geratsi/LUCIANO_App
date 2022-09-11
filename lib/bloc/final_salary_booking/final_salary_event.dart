part of 'final_salary_bloc.dart';

@immutable
abstract class FinalSalaryEvent {}

class UpdateFinalSalary extends FinalSalaryEvent {
  final Iterable<Product>? scannedProducts;
  final Iterable<Service>? selectedServices;

  UpdateFinalSalary({this.scannedProducts, this.selectedServices});
}

class RemoveItem extends FinalSalaryEvent {
  final Product? product;
  final Service? service;

  RemoveItem({this.product, this.service});
}

class UpdateItemCount extends FinalSalaryEvent {
  final Product? product;
  final Service? service;

  UpdateItemCount({this.product, this.service});
}

class ClearSalary extends FinalSalaryEvent {}
