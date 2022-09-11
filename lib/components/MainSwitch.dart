
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';

class MainSwitch extends StatelessWidget {
  const MainSwitch({
    Key? key,
    required this.value,
    required this.onPressed,
    this.child,
    this.padding,
    this.decoration,
  }) : super(key: key);

  final bool value;
  final Widget? child;
  final Function onPressed;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration ?? const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Config.textTitleColor),
        ),
        color: Config.activityHintColor
      ),
      child: SwitchListTile.adaptive(
        dense: true,
        value: value,
        contentPadding: padding ?? const EdgeInsets.fromLTRB(
          Config.padding, Config.padding / 2, Config.padding / 2, Config.padding / 2,
        ),
        title: child ?? const Text(''),
        onChanged: (value) {onPressed(value);},
      ),
    );
  }
}

