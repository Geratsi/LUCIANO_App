
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../Api.dart';
import '../Config.dart';
import '../entity/Service.dart';
import '../entity/ProtocolProduct.dart';
import '../components/ErrorComponent.dart';

class ProtocolsFromServer {
  static Future<Iterable<Service>> setProtocols(
    Iterable<Service> selectedServices, BuildContext context,
  ) async {
    final List<Service> servicesWithoutProtocol = [];
    final ErrorComponent errorComponent = ErrorComponent(context: context);
    for (final Service service in selectedServices) {
      if (service.protocol.isEmpty) {
        servicesWithoutProtocol.add(service);
      }
    }

    try {
      if (servicesWithoutProtocol.isNotEmpty) {
        final List<dynamic> response = await Api.getProtocols(
          servicesWithoutProtocol.map((e) => e.id),
          servicesWithoutProtocol.first.ownerId,
        );

        for (var responseItem in response) {
          for (final Service item in selectedServices) {
            List<dynamic> protocol = responseItem['OwnerServiceProtocolSpec'];
            if (protocol.isNotEmpty && item.id == responseItem['Id']) {
              item.protocol = protocol.map(
                    (el) => ProtocolProduct.fromJson(el),
              ).toList();
            }
          }
        }
      }

    } on DioError catch (error) {
      log(
        'ProtocolsFromServer.setProtocols: dio error type {${error.type}} '
          '/error {${error.error}}',
        name: Config.appName,
      );
      errorComponent.show(error.type);
    } catch (error) {
      log('ProtocolsFromServer.setProtocols: {$error}', name: Config.appName,);
      errorComponent.show(null);
    }

    return selectedServices;
  }
}
