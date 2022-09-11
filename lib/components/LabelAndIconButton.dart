
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';

class LabelAndIconButton extends StatelessWidget {
  const LabelAndIconButton({
    Key? key,
    required this.label,
    required this.handler,
    this.labelStyle,
    this.backgroundColor,
    this.contentPadding,
  }) : super(key: key);

  final String label;
  final Function handler;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        elevation: 5.0,
        shadowColor: Colors.black,
        backgroundColor: backgroundColor ?? Config.infoColor,
        padding: contentPadding ?? const EdgeInsets.fromLTRB(Config.padding,
          Config.padding / 1.1, Config.padding / 1.4, Config.padding / 1.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Config.activityBorderRadius),
        ),
      ),

      onPressed: () {
        handler();
      },

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: labelStyle ?? Styles.titleStyle,
          ),

          const Icon(
            Icons.arrow_forward_ios, size: Config.iconSize,
            color: Config.primaryColor,
          ),
        ],
      ),
    );
  }
}

