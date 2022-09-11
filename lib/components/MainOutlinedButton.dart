
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';

class MainOutlinedButton extends StatelessWidget {
  const MainOutlinedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.padding,
    this.labelStyle,
    this.backgroundColor,
  }) : super(key: key);

  final String label;
  final Function onPressed;
  final EdgeInsets? padding;
  final TextStyle? labelStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {onPressed();},
      child: Row(
        children: <Widget>[
          Text(label, style: labelStyle ?? Styles.titlePrimaryStyle,),
        ],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor ?? Config.activityBackColor,
        padding: padding ?? const EdgeInsets.all(Config.padding / 1.1,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Config.activityBorderRadius),
        ),
        side: const BorderSide(width: 1, color: Config.textColor),
      ),
    );
  }
}

