
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';

class ModalCenterMessage extends StatelessWidget {
  const ModalCenterMessage({Key? key, required this.component}) : super(key: key);

  final Widget component;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Config.activityBorderRadius),
              color: Config.activityBackColor,
            ),
            padding: const EdgeInsets.all(Config.padding / 4),
            child: component,
          ),
        ],
      )
    );
  }
}