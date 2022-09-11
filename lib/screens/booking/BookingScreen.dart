
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/ServicesScreen.dart';
import 'products/ScanProductsScreen.dart';
import 'components/FinalSalaryComponent.dart';
import 'components/BookingInfoComponent.dart';
import 'products/ScannedProductsComponent.dart';
import 'services/SelectedServicesComponent.dart';
import '../../Config.dart';
import '../../Styles.dart';
import '../../entity/Booking.dart';
import '../../entity/Product.dart';
import '../../entity/Service.dart';
import '../../utilities/Message.dart';
import '../../entity/ProtocolProduct.dart';
import '../../modelView/FinishBooking.dart';
import '../../components/ModalProgress.dart';
import '../../components/MainOpacityButton.dart';
import '../../components/CommentsDialogComponent.dart';
import '../../bloc/final_salary_booking/final_salary_bloc.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    Key? key,
    required this.selectedBooking,
    required this.refreshAppointmentDataSource,
  }) : super(key: key);

  final Booking selectedBooking;
  final Function refreshAppointmentDataSource;

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late Message _message;
  late Booking _selectedBooking;
  late ModalProgress _progress;

  String? _comments;
  List<Service> _allServices = [];
  List<Product?> _scannedProducts = [];

  @override
  void initState() {
    super.initState();

    _progress = ModalProgress.of(context);
    _selectedBooking = widget.selectedBooking;
  }

  Future<void> _save(FinalSalaryBloc salaryBloc) async {
    showDialog(context: context, builder: (_) => CommentsDialogComponent(
      sendFunc: (String comments) {
        if (comments.trim().isNotEmpty) {
          _comments = comments;
        }
        _makeRequest(salaryBloc);
      },
    ));
  }

  Future<void> _makeRequest(FinalSalaryBloc salaryBloc) async {
    final List<Service> selectedServices = _allServices.where(
      (element) => element.isSelected,
    ).toList();

    final List<Map<String, dynamic>> products = [];
    final List<Map<String, dynamic>> services = [];
    for (final Service service in selectedServices) {
      final Map<String, dynamic> serviceData = {
        'Quant': service.count,
        'InCode': service.inCode,
        'ServiceId': service.id,
      };

      final List<Map<String, dynamic>> protocolProducts = [];
      for (final ProtocolProduct protocolProduct in service.protocol) {
        if (protocolProduct.children.isNotEmpty) {
          for (final ProtocolProductChild element in protocolProduct.children) {
            protocolProducts.add({
              'Id': element.id, 'Quant': element.currentQuantity,
            });
          }
        } else {
          protocolProducts.add({
            'Id': protocolProduct.id, 'Quant': protocolProduct.currentQuantity,
          });
        }
      }

      serviceData['Products'] = protocolProducts;
      services.add(serviceData);
    }

    // final List<Map<String, dynamic>> services = selectedServices.map(
    //   (service) {
    //     final Iterable pr = service.protocol.map((protocol) => {
    //       'Id': protocol.id, 'Quant': protocol.currentQuantity,
    //     });
    //     log('__quantity__ -- ${pr.length}');
    //     return {
    //       'InCode': service.inCode,
    //       'ServiceId': service.id,
    //       'Products': service.protocol.map(
    //         (protocol) => {
    //           'Id': protocol.id, 'Quant': protocol.currentQuantity,
    //         },
    //       ).toList(),
    //     };
    //   }
    // ).toList();

    if (_scannedProducts.isNotEmpty) {
      for (Product? product in _scannedProducts) {
        if (product != null) {
          products.add({
            'Id': product.id,
            'Sgod': product.sGod,
            'Price': product.price,
            'Quant': product.count,
            'ProductName': product.label,
          });
        }
      }
    }

    final bool isSuccess = await FinishBooking.bookingClose(
      profileId: _selectedBooking.profileId, clientId: _selectedBooking.clientId,
      bookingId: _selectedBooking.bookingId, bookingTngId: _selectedBooking.tngBookingId,
      tngClientId: _selectedBooking.tngClientId, ownerId: _selectedBooking.ownerId,
      employeeTngId: _selectedBooking.saleManager, services: services,
      context: context, comments: _comments, products: products,
      modalProgress: _progress,
    );

    if (isSuccess) {
      _selectedBooking.statusId = 10004;
      _selectedBooking.available = false;
      _selectedBooking.statusName = 'Выполнена';
      for (var element in _allServices) {element.isSelected = false;}
      salaryBloc.add(ClearSalary());
      setState(() {});

      _message.showMessage(
        title: 'Успешно', content: 'Заказ наряд успешно создан!',
      );

      widget.refreshAppointmentDataSource();
    }
  }

  void _updateParentData({
    required List<Service> selected, required List<Service> all,
    required FinalSalaryBloc salaryBloc,
  }) {
    if (_allServices.isEmpty) {
      _allServices = all;
    }

    for (var service in _allServices) {
      service.isSelected = false;
      for (var selectedService in selected) {
        if (service.id == selectedService.id) {
          service.isSelected = selectedService.isSelected;
          service.count = selectedService.count;
          break;
        }
      }
    }

    salaryBloc.add(UpdateFinalSalary(
      selectedServices: _allServices.where((element) => element.isSelected),
    ));

    setState(() {});
  }

  void _updateScannedProducts(List<Product?> scanned, FinalSalaryBloc salaryBloc,) {
    for (final Product? newProduct in scanned) {
      if (newProduct != null) {
        if (_scannedProducts.contains(newProduct)) {
          final Product product = _scannedProducts[_scannedProducts.indexOf(newProduct)]!;
          product.count += newProduct.count;
          if (product.quantity - product.count < 0) {
            product.count = product.quantity;
          }
        } else {
          _scannedProducts.add(newProduct);
        }
      }
    }

    final List<Product> products = [];
    for (final Product? product in _scannedProducts) {
      if (product != null) {
        products.add(product);
      }
    }

    salaryBloc.add(UpdateFinalSalary(scannedProducts: products));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _message = Message(context: context);
    // final String _languageCode = Localizations.localeOf(context);

    final FinalSalaryBloc salaryBloc = context.read<FinalSalaryBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронь'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Config.padding),
          child: Column(
            children: <Widget>[
              BookingInfoComponent(booking: _selectedBooking),

              const SizedBox(height: Config.padding,),

              MainOpacityButton(
                isDisabled: !_selectedBooking.available,
                label: 'Выбрать услуги',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ServicesScreen(
                      allServices: _allServices,
                      updateParentData: (List<Service> selected, List<Service> all) {
                        _updateParentData(
                          selected: selected, all: all, salaryBloc: salaryBloc,
                        );
                      },
                      updateServices: (List<Service> items) {
                        if (_allServices.isEmpty) {
                          _allServices = items;
                        }
                      },
                    ),
                  ));
                },
                labelStyle: Styles.titleStyle,
                backgroundColor: Config.activityHintColor,
              ),

              SelectedServicesComponent(
                allServices: _allServices,
                updateParentServices: (List<Service> updatedServices) {
                  setState(() {
                    _allServices = updatedServices;
                  });
                },
              ),

              Visibility(
                visible: _allServices.where(
                  (element) => element.isSelected,
                ).isNotEmpty,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: Config.padding / 2,),

                    MainOpacityButton(
                      label: 'Добавить товары',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ScanProductsScreen(
                            addScannedProducts: (scanned) {
                              _updateScannedProducts(scanned, salaryBloc);
                            },
                            ownerId: _selectedBooking.ownerId,
                          ),
                        ));
                      },
                      labelStyle: Styles.titleStyle,
                      backgroundColor: Config.activityHintColor,
                    ),

                    ScannedProductsComponent(
                      listKey: GlobalKey<AnimatedListState>(),
                      animated: false, scannedProducts: _scannedProducts,
                      updateScannedProducts: (List<Product?> data) {
                        _scannedProducts = data;
                      },
                    ),
                  ],
                )
              ),

              const SizedBox(height: Config.padding / 2,),

              BlocBuilder<FinalSalaryBloc, int>(
                builder: (context, state) {
                  return state == 0
                      ? const SizedBox.shrink()
                      : const FinalSalaryComponent();
                },
              ),

              MainOpacityButton(
                isDisabled: !_selectedBooking.available || _allServices.where(
                  (element) => element.isSelected,
                ).isEmpty,
                label: 'Завершить',
                onPressed: () {
                  _save(salaryBloc);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
