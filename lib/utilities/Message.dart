
import 'package:flutter/material.dart';

import '../Styles.dart';
import '../entity/DialogAction.dart';
import '../components/DialogComponent.dart';

class Message {

  late BuildContext context;
  late bool barrierDismissible;
  late DialogAction? cancelAction;
  late DialogAction? acceptAction;

  Message({
    required this.context, this.cancelAction, this.acceptAction,
    this.barrierDismissible = true,
  });

  void showMessage({
    required String title, required String content, Function? callback,
  }) {
    List<DialogAction> actions = [];
    if (cancelAction != null) {
      actions.add(cancelAction!);
    }
    if (acceptAction != null) {
      actions.add(acceptAction!);
    } else {
      actions.add(
        DialogAction(label: 'Ок', callback: () {
          Navigator.of(context).pop();
          if (callback != null) {
            callback();
          }
        }),
      );
    }

    showDialog(
      barrierColor: Colors.transparent,
      context: context, builder: (context) => DialogComponent(
        title: Text(title, style: Styles.titleStyle, textAlign: TextAlign.center,),
        content: Text(
          content, style: Styles.textTitleColorStyle,
          textAlign: TextAlign.center,
        ),
        actions: actions,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
