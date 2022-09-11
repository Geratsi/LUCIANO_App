
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'ExceptionLogger.dart';
import '../Api.dart';
import '../Config.dart';
import '../Storage.dart';
import '../entity/Service.dart';
import '../components/ErrorComponent.dart';

class ServicesFromServer {
  static Future<List<Service>> getServices(BuildContext context) async {
    final String? token = await EncryptedStorage.get(Config.userKey);
    final ErrorComponent errorComponent = ErrorComponent(context: context);

    if (token != null) {
      try {
        final Map<dynamic, dynamic> responseInMap = await Api.getServices(token);
        if (responseInMap['ErrorCode'] == null) {
          final List<Service> services = [];

          for (var service in responseInMap['Data']) {
            services.add(Service.fromJson(service));
          }

          return services;
        } else {
          RequestOptions requestOptions = responseInMap['request'];
          ExceptionLogger.sendException(
            address: requestOptions.path,
            request: requestOptions.data.toString(),
            exceptionTrace: '{${responseInMap['Data']}} '
                'with code {${responseInMap['ErrorCode']}} '
                'in method ServicesFromServer.getServices',
          );
          log(
            'ServicesFromServer.getServices: server error '
              '{${responseInMap['ErrorCode']}}',
            name: Config.appName,
          );
          errorComponent.message.showMessage(
            title: 'Ошибка',
            content: 'Произошла ошибка при загрузке данных. Перезайдите в приложение. '
                'Если не получится, обратитесь в поддержку',
          );
        }
      } on DioError catch (error) {
        log(
          'ServicesFromServer.getServices: dio error type {${error.type}} '
            '/error {${error.error}}',
          name: Config.appName,
        );
        errorComponent.show(error.type);
      } catch (error) {
        log('ServicesFromServer.getServices: {$error}', name: Config.appName,);
        errorComponent.show(null);
      }
    } else {
      errorComponent.show(null);
      log('ServicesFromServer.getServices: token is null', name: Config.appName,);
    }

    return [];
  }
}
