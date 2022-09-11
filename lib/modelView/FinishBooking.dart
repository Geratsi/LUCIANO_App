
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luciano/components/ModalProgress.dart';

import 'ExceptionLogger.dart';
import '../Api.dart';
import '../Config.dart';
import '../Storage.dart';
import '../components/ErrorComponent.dart';

class FinishBooking {

  static Future<bool> bookingClose({
    required int profileId, required int bookingId, required int bookingTngId,
    required int clientId, required int tngClientId, required int ownerId,
    required int employeeTngId, required List<Map<String, dynamic>> services,
    required BuildContext context, required String? comments,
    required List<Map<String, dynamic>> products, required ModalProgress modalProgress,
  }) async {
    modalProgress.show();
    final ErrorComponent errorComponent = ErrorComponent(context: context);
    try {
      final String? employeeId = await Storage.get(Config.employeeId);
      if (employeeId == null) {
        throw Exception('Read field from Storage: ${Config.employeeId} is null');
      }

      Map<dynamic, dynamic> responseInMap = await Api.bookingClose(
        profileId: profileId, bookingId: bookingId, bookingTngId: bookingTngId,
        clientId: clientId, tngClientId: tngClientId, ownerId: ownerId,
        employeeTngId: employeeTngId, employeeId: int.parse(employeeId),
        comments: comments, services: services, products: products,
      );

      if (responseInMap['ErrorCode'] == null) {
        modalProgress.hide();
        return true;
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
          'FinishBooking.bookingClose: server error {${responseInMap['Data']}} '
            'with code {${responseInMap['ErrorCode']}}',
          name: Config.appName,
        );
        modalProgress.hide();
        errorComponent.message.showMessage(
          title: 'Ошибка',
          content: 'Произошла ошибка при завершении брони. Перезайдите в приложение. '
              'Если не получится, обратитесь в поддержку',
        );
      }

    } on DioError catch (error) {
      log(
        'FinishBooking.bookingClose: dio error type {${error.type}} '
          '/error {${error.error}}',
        name: Config.appName,
      );
      modalProgress.hide();
      errorComponent.show(error.type);
    } catch (error) {
      log('FinishBooking.bookingClose: {$error}', name: Config.appName,);
      modalProgress.hide();
      errorComponent.show(null);
    }

    return false;
  }
}
