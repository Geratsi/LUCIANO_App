
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';

class MainContentWithLabel extends StatelessWidget {
  const MainContentWithLabel({
    Key? key,
    required this.label,
    required this.contentWidget,
  }) : super(key: key);

  final String label;
  final Widget contentWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Config.padding,),
          child: Text(
            label,
            style: const TextStyle(fontSize: Config.textLargeSize,
              color: Config.textTitleColor,),
          ),
        ),

        contentWidget,
      ],
    );
  }
}


