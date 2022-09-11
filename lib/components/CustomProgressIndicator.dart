
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../Config.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    Key? key,
    this.value,
    this.color,
    this.width = 4.0,
    this.cupertinoRadius,
  }) : super(key: key);

  final Color? color;
  final double width;
  final double? value;
  final double? cupertinoRadius;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return CircularProgressIndicator(
        strokeWidth: width, value: value, color: color ??  Config.primaryColor,
      );
    }

    return CupertinoActivityIndicator(
      color: color ?? Config.primaryColor,
      radius: cupertinoRadius ?? Config.iconSize,
    );
  }
}
