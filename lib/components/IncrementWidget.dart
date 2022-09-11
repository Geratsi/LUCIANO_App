
import 'package:flutter/material.dart';

import 'TouchableOpacityEffect.dart';
import '../Config.dart';
import '../screens/booking/components/CustomIcon.dart';

class IncrementWidget extends StatelessWidget {
  const IncrementWidget({
    Key? key,
    required this.controller,
    required this.callback,
    this.isInteger = false,
  }) : super(key: key);

  final bool isInteger;
  final Function(int) callback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacityEffect(
      onPressed: () {
        if (isInteger) {
          final int count = int.parse(controller.text);
          controller.text = '${count + 1}';
          callback(count + 1);
        } else {
          if (controller.text.contains(',')) {
            controller.text.replaceAll(',', '.');
          }

          controller.text = (double.parse(controller.text) + 1.0).toString()
              .replaceAll(Config.findTrailingZeros, '');
        }
      },
      child: const Padding(
        padding: EdgeInsets.only(left: Config.padding / 4),
        child: CustomIcon(icon: Icons.add_circle, isActive: true,),
      ),
    );
  }
}
