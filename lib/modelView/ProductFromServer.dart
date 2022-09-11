
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'ExceptionLogger.dart';
import '../Api.dart';
import '../Config.dart';
import '../entity/Product.dart';
import '../components/ErrorComponent.dart';

class ProductFromServer {
  static Future<Product?> getProduct({
    required int ownerId, required String code, required BuildContext context,
  }) async {
    final ErrorComponent errorComponent = ErrorComponent(context: context);
    try {
      final Map<dynamic, dynamic> responseInMap = await Api.getProduct(
        ownerId, code,
      );
      if (responseInMap['IsError']) {
        RequestOptions requestOptions = responseInMap['request'];
        ExceptionLogger.sendException(
          address: requestOptions.path,
          request: requestOptions.data.toString(),
          exceptionTrace: '{${responseInMap['ErrorText']}} '
              'in method ProductFromServer.getProduct',
        );
        log(
          'ProductFromServer.getProduct: server error '
            '{${responseInMap['ErrorText']}}',
          name: Config.appName,
        );
        errorComponent.message.showMessage(
            title: 'Ошибка',
            content: 'Произошла ошибка при загрузке данных. Перезайдите в приложение. '
                'Если не получится, обратитесь в поддержку');
      } else {
        final List<dynamic> data = responseInMap['Data'];
        if (data.isEmpty) {
          errorComponent.message.showMessage(
            title: 'Ошибка',
            content: 'Штрих-код в системе не найден. Попробуйте отканировать еще раз',
          );
        } else {
          Map<String, dynamic> item = data[0];
          final Product product = Product.fromJson(item, code);

          return product;
        }
      }
    } on DioError catch (error) {
      log(
        'ProductFromServer.getProduct: dio error type {${error.type}} '
          '/error {${error.error}}',
        name: Config.appName,
      );
      errorComponent.show(error.type);
    } catch (error) {
      log('ProductFromServer.getProduct: {$error}', name: Config.appName,);
      errorComponent.show(null);
    }

    return null;
  }
}