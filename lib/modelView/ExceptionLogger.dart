
import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../Api.dart';
import '../Config.dart';
import '../Storage.dart';

class ExceptionLogger {

  static Future<void> sendException({
    required String address, required String request,
    required String exceptionTrace, String? profileId,
  }) async {
    String? ip;
    final List<NetworkInterface> interface = await NetworkInterface.list();
    if (interface.isNotEmpty) {
      final NetworkInterface networkInterface = interface[0];
      log(
        'ExceptionLogger.sendException: connection name {${networkInterface.name}}',
        name: Config.appName,
      );
      final List<InternetAddress> addresses = networkInterface.addresses;
      if (addresses.isNotEmpty) {
        ip = addresses[0].address;
        log(
          'ExceptionLogger.sendException: address type {${addresses[0].type}}',
          name: Config.appName,
        );
      }
    }

    final String? id = profileId ?? await Storage.get(Config.employeeId);

    try {
      final Map<dynamic, dynamic> responseInMap = await Api.sendException(
        id: id != null ? int.parse(id) : 0 , ip: ip, exceptionTrace: exceptionTrace,
        request: request, address: address,
      );

      if (responseInMap['ErrorCode'] != null) {
        log(
          'ExceptionLogger.sendException: server error {${responseInMap['Data']}} '
            'with code {${responseInMap['ErrorCode']}}',
          name: Config.appName,
        );
      }
    } on DioError catch(error) {
      log(
        'ExceptionLogger.sendException: dio error type {${error.type}} '
          '/error {${error.error}}',
        name: Config.appName,
      );
    } catch (error) {
      log('ExceptionLogger.sendException: {$error}', name: Config.appName,);
    }
  }
}