
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Message.dart';
import '../entity/DialogAction.dart';

enum Device {
  camera,
}

class CheckPermission {

  CheckPermission({required this.context}) {
    _settingsMessage = Message(
      context: context,
      cancelAction: DialogAction(
        label: 'Отмена', callback: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
      acceptAction: DialogAction(
        label: 'Открыть настройки', callback: () {
          Navigator.of(context).pop();
          openAppSettings();
        },
      ),

    );
  }

  final BuildContext context;
  late Message _settingsMessage;

  Future<void> serviceIsEnabled({
    required BuildContext context, required Device device,
    required Function callback,
  }) async {
    switch (device) {
      case Device.camera:
        await _serviceCamera(context, callback);
        break;
    }
  }

  Future<void> _serviceCamera(BuildContext context, Function callback) async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      var response = await Permission.camera.request();
      if (response.isPermanentlyDenied) {
        _settingsMessage.showMessage(
          title: 'Ошибка разрешения',
          content: 'Предоставьте разрешение на использование камеры телефона',
        );
      }
    } else {
      callback();
    }
  }
}
