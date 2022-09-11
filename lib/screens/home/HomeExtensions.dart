
import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';

class HomeExtensions extends StatelessWidget {
  const HomeExtensions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: const <Widget>[
            Text('Бронирования', style: Styles.titleStyle,),

            SizedBox(height: Config.padding,),

            Text('Пока нет бронирований', style: Styles.textStyle,),

            SizedBox(height: Config.padding,),

            Text('Контракт', style: Styles.titleStyle,),

            SizedBox(height: Config.padding,),

            Text('Пока контрактов нет', style: Styles.textStyle,),
          ],
        )
      ],
    );
  }
}

