
import 'package:flutter/material.dart';

import 'TouchableOpacityEffect.dart';
import '../Config.dart';
import '../screens/booking/components/CustomIcon.dart';

class DecrementWidget extends StatelessWidget {
  const DecrementWidget({
    Key? key,
    required this.controller,
    required this.callback,
    this.isActive = true,
    this.isInteger = false,
  }) : super(key: key);

  final bool isActive;
  final bool isInteger;
  final Function(int) callback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacityEffect(
      onPressed: () {
        if (isInteger) {
          int count = int.parse(controller.text);
          if (count > 1) {
            controller.text = '${count - 1}';
            callback(count - 1);
          }
        } else {
          if (controller.text.contains(',')) {
            controller.text.replaceAll(',', '.');
          }
          double count = double.parse(controller.text);
          if (count >= 1.0) {
            controller.text = (count - 1.0).toString()
                .replaceAll(Config.findTrailingZeros, '');
          }
        }
      },
      child: Padding(
        child: CustomIcon(icon: Icons.remove_circle, isActive: isActive,),
        padding: const EdgeInsets.only(
          right: Config.padding / 4, left: Config.padding / 6,
        ),
      ),
    );
  }
}