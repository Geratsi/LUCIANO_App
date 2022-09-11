
import 'package:flutter/material.dart';

import '../Config.dart';
import '../Styles.dart';

class ErrorWindow extends StatelessWidget {
  const ErrorWindow({
    Key? key,
    required this.details,
  }) : super(key: key);

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          color: Config.activityHintColor,
          padding: const EdgeInsets.all(Config.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text('Что-то пошло не так', style: Styles.titleBoldStyle,),

              const SizedBox(height: Config.padding,),

              Expanded(child: SingleChildScrollView(
                child: Text(
                  details.exception.toString(),
                  style: Styles.titleStyle,
                ),
              )),

              const SizedBox(height: Config.padding,),

              const Text(
                'Сделайте скрин и сообщите об ошибке в поддержку',
                style: Styles.textTitleColorStyle,
              ),

              const SizedBox(height: Config.padding / 2,),

              const Text(
                'Перезапустите приложение',
                style: Styles.textTitleColorStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
