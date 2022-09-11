
import 'package:flutter/material.dart';

import '../Config.dart';

class ShortDivider extends StatelessWidget {
  const ShortDivider({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Config.padding),
      child: Container(
        height: 1,
        color: Config.textTitleColor,
        width: MediaQuery.of(context).size.width * .3,
      ),
    );
  }
}
