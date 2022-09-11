
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'ExceptionLogger.dart';
import '../Api.dart';
import '../Config.dart';
import '../components/ModalProgress.dart';
import '../components/ErrorComponent.dart';

class EditProfile {
  static Future<bool> editImageAndNotes({
    required BuildContext context, required ModalProgress progress,
    required int ownerId, required int profileId,
    String? imageBase64, String? aboutMe,
  }) async {
    final ErrorComponent errorComponent = ErrorComponent(context: context);

    try {
      Map<dynamic, dynamic> responseInMap = await Api.editProfileInfo(
        ownerId: ownerId, profileId: profileId, image: imageBase64,
        aboutMe: aboutMe,
      );

      progress.hide();

      if (responseInMap['ErrorCode'] == null) {
        return true;
      } else {
        final RequestOptions requestOptions = responseInMap['request'];
        ExceptionLogger.sendException(
          address: requestOptions.path,
          request: requestOptions.data.toString(),
          exceptionTrace: '{${responseInMap['Data']}} '
              'with code {${responseInMap['ErrorCode']}} '
              'in method EditProfile.editImageAndNotes',
        );
        log(
          'EditProfile.editImageAndNotes: server error {${responseInMap['Data']}} '
            'with code {${responseInMap['ErrorCode']}}',
          name: Config.appName,
        );
        errorComponent.message.showMessage(
          title: 'Ошибка',
          content: 'Произошла ошибка при сохранении данных. Перезайдите в приложение. '
              'Если не получится, обратитесь в поддержку',
        );
      }
    } on DioError catch (error) {
      progress.hide();
      log(
        'EditProfile.editImageAndNotes: dio error type {${error.type}} '
          '/error {${error.error}}',
        name: Config.appName,
      );
      errorComponent.show(error.type);
    } catch (error) {
      progress.hide();
      log('EditProfile.editImageAndNotes: {$error}', name: Config.appName,);
      errorComponent.show(null);
    }

    return false;
  }
}
