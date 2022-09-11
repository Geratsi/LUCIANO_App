
import 'package:luciano/Config.dart';
import 'package:flutter/material.dart';

class ModalBottomMessage extends SnackBar {
  final String message;
  final Color? bgColor;
  final Color? messageColor;

  ModalBottomMessage({
    Key? key,
    required this.message,
    this.bgColor,
    this.messageColor,
  }) : super(
      key: key,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Config.smallBorderRadius),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(Config.padding / 2),
              child: Text(
                message,
                style: TextStyle(fontSize: Config.textLargeSize,
                    color: messageColor ?? Config.textTitleColor),
              ),
            ),
          ),
        ],
      )
  );
}
