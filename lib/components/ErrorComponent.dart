
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utilities/Message.dart';

class ErrorComponent {
  late Message message;

  ErrorComponent({required BuildContext context,}) {
    message = Message(context: context);
  }

  void show(dynamic error) {
    if (error is Map) {
      message.showMessage(
        title: 'Ошибка',
        content: error['data'],
      );
    } else if (error is DioErrorType) {
      if (error == DioErrorType.sendTimeout) {
        message.showMessage(
          title: 'Ошибка подключения',
          content: 'Проверьте подключение к интернету и попробуйте снова',
        );
      } else if (error == DioErrorType.receiveTimeout) {
        message.showMessage(
          title: 'Время ожидания истекло',
          content: 'Время ожидания ответа от сервера истекло. '
              'Попробуйте повторить действия позже или обратитесь в поддержку',
        );
      } else {
        message.showMessage(
          title: 'Неизвестная ошибка',
          content: 'Проверьте подключение к интернету, перезапустите приложение '
              'и попробуйте снова. Если не получится, обратитесь в поддержку',
        );
      }
    } else {
      message.showMessage(
        title: 'Неизвестная ошибка',
        content: 'Проверьте подключение к интернету, перезапустите приложение '
            'и попробуйте снова. Если не получится, обратитесь в поддержку',
      );
    }
  }
}
