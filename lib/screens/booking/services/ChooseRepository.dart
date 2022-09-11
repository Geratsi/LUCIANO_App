
import 'package:flutter/material.dart';

import '../../../Config.dart';
import '../../../Styles.dart';

class ChooseRepository extends StatelessWidget {
  const ChooseRepository({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Config.textColor,
        borderRadius: BorderRadius.circular(Config.smallBorderRadius),
      ),
      padding: const EdgeInsets.all(Config.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: Styles.textWhiteBoldStyle,),
        ],
      ),
    );
  }
}
