
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Config.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset('assets/images/logo.svg', width: 80, height: 80,),

        const SizedBox(height: Config.padding / 2,),

        const Text(
          'Luciano',
          style: TextStyle(
            fontSize: 60, color: Config.textColorOnPrimary,
          ),
        ),
      ],
    );
  }
}
