
import 'package:flutter/material.dart';

import '../../../Config.dart';
import '../../../components/CustomProgressIndicator.dart';

class WaitingComponent extends StatelessWidget {
  const WaitingComponent({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: Config.padding),
          child: SizedBox(
            height: height,
            child: const Center(child: SizedBox(
              width: 20,
              height: 20,
              child: CustomProgressIndicator(width: 3,),
            ),),
          ),
        ),
      ],
    );
  }
}
