
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Config.dart';
import '../../entity/Product.dart';
import '../../entity/Service.dart';

part 'final_salary_event.dart';
part 'final_salary_state.dart';

class FinalSalaryBloc extends Bloc<FinalSalaryEvent, int> {
  String finalSalary = '';
  double productsSalary = 0;
  double servicesSalary = 0;
  Iterable<Product> scannedProducts = [];
  Iterable<Service> selectedServices = [];

  FinalSalaryBloc() : super(0) {
    on<UpdateFinalSalary>((event, emit) {
      final Iterable<Product>? _scannedProducts = event.scannedProducts;
      final Iterable<Service>? _selectedServices = event.selectedServices;

      if (_selectedServices != null) {
        selectedServices = [];
        selectedServices = _selectedServices;
        servicesSalary = _getServicesSalary();
      }

      if (_scannedProducts != null) {
        scannedProducts = [];
        scannedProducts = _scannedProducts;
        productsSalary = _getProductsSalary();
      }

      _updateState(emit);
    });

    on<RemoveItem>((event, emit) {
      final Product? _product = event.product;
      final Service? _serviceItem = event.service;
      if (_product != null) {
        scannedProducts = scannedProducts.where(
          (element) => element.id != _product.id,
        );
        productsSalary = _getProductsSalary();
      }
      if (_serviceItem != null)  {
        selectedServices = selectedServices.where(
          (element) => element.id != _serviceItem.id,
        );
        servicesSalary = _getServicesSalary();
      }

      _updateState(emit);
    });

    on<UpdateItemCount>((event, emit) {
      final Product? _product = event.product;
      final Service? _serviceItem = event.service;
      if (_product != null) {
        for (final Product __product in scannedProducts) {
          if (__product.id == _product.id) {
            __product.count = _product.count;
          }
        }
        productsSalary = _getProductsSalary();
      }
      if (_serviceItem != null)  {
        for (final Service __serviceItem in selectedServices) {
          if (__serviceItem.id == _serviceItem.id) {
            __serviceItem.count = _serviceItem.count;
          }
        }
        servicesSalary = _getServicesSalary();
      }

      _updateState(emit);
    });

    on<ClearSalary>((event, emit) {
      finalSalary = '';
      productsSalary = 0;
      servicesSalary = 0;
      scannedProducts = [];
      selectedServices = [];
      emit(0);
    });
  }

  void _updateState(Emitter emit) {
    finalSalary = _getFinalSalary();

    if (finalSalary.isEmpty || finalSalary == '0') {
      emit(0);
    } else {
      emit(state + 1);
    }
  }

  double _getServicesSalary() {
    double servicesSalary = 0;

    if (selectedServices.isNotEmpty) {
      for (final Service item in selectedServices) {
        servicesSalary += item.count * item.price;
      }
    }

    return servicesSalary;
  }

  double _getProductsSalary() {
    double productsSalary = 0;

    if (scannedProducts.isNotEmpty) {
      for (final Product item in scannedProducts) {
        productsSalary += item.count * item.price;
      }
    }

    return productsSalary;
  }

  String _getFinalSalary() {
    final double finalSalary = productsSalary + servicesSalary;
    if (finalSalary.round() == 0) {
      return '';
    } else {
      return finalSalary.toString().replaceAll(Config.findTrailingZeros, '');
    }
  }
}
