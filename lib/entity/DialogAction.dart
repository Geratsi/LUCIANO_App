
import 'package:flutter/material.dart';

class DialogAction {
  late String label;
  late Function() callback;
  late TextStyle? labelStyle;
  late Color? backgroundColor;

  DialogAction({
    required this.label, required this.callback, this.labelStyle,
    this.backgroundColor,
  });
}