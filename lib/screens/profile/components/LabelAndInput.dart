
import 'package:flutter/material.dart';
import 'package:luciano/components/MainTextInput.dart';

import '../../../Config.dart';
import '../../../Styles.dart';

class LabelAndInput extends StatelessWidget {
  const LabelAndInput({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Styles.textTitleColorStyle,),

        const SizedBox(height: Config.padding / 2,),

        MainTextInput(
          controller: controller, defaultValidation: true, minLines: 1,
          maxLines: 20, borderRadius: Config.smallBorderRadius,
        ),

        const SizedBox(height: Config.padding,),
      ],
    );
  }
}
