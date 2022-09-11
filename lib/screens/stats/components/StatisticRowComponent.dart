
import 'package:flutter/material.dart';

import '../../../Config.dart';
import '../../../Styles.dart';

class StatisticRowComponent extends StatelessWidget {
  const StatisticRowComponent({
    Key? key,
    required this.label,
    required this.value,
    this.add,
    this.labelStyle,
    this.valueStyle,
    this.valueWidget,
  }) : super(key: key);

  final String? add;
  final String label;
  final String value;
  final Widget? valueWidget;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Config.padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle ?? Styles.titleStyle,),

          valueWidget != null
              ? valueWidget!
              : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: valueStyle ?? Styles.titleBoldStyle,),

              add != null ? Text(add!, style: Styles.textStyle,) : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
