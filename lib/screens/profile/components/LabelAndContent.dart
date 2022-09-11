
import 'package:flutter/material.dart';

import '../../../Config.dart';
import '../../../Styles.dart';

class LabelAndContent extends StatelessWidget {
  const LabelAndContent({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Styles.textTitleColorStyle,),

        const SizedBox(height: Config.padding / 2,),

        Container(
          decoration: BoxDecoration(
            color: Config.infoColor,
            borderRadius: BorderRadius.circular(Config.smallBorderRadius),
          ),
          padding: const EdgeInsets.all(Config.padding),
          child: Row(
            children: <Widget>[
              Text(content, style: Styles.titleBoldStyle,),
            ],
          ),
        ),

        const SizedBox(height: Config.padding,),
      ],
    );
  }
}
