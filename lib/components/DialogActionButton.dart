
import 'package:flutter/material.dart';

import 'TouchableOpacityEffect.dart';
import '../Styles.dart';
import '../Config.dart';
import '../entity/DialogAction.dart';

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({
    Key? key,
    required this.action,
    this.padding = true,
  }) : super(key: key);

  final bool padding;
  final DialogAction action;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacityEffect(
      onPressed: action.callback,
      child: Container(
        decoration: BoxDecoration(
          color: action.backgroundColor ?? Config.primaryLightColor,
          border: Border.all(color: Config.activityHintColor),
          borderRadius: BorderRadius.circular(Config.activityBorderRadius),
        ),
        padding: EdgeInsets.fromLTRB(
          padding ? Config.padding * 1.3 : Config.padding / 3,
          Config.padding / 3,
          padding ? Config.padding * 1.3 : Config.padding / 3,
          Config.padding / 3,
        ),
        child: Text(
          action.label, style: action.labelStyle ?? Styles.textTitleColorBoldStyle,
        ),
      ),
    );
  }
}
