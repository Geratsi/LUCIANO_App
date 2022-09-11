
import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';

class CardComponent extends StatelessWidget {
  const CardComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.symmetric(vertical: Config.padding * 1.5,
          horizontal: Config.padding * 1.3,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(Config.activityBorderRadius),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('Platinum Guest', style: Styles.titleStyle,),

                SizedBox(height: Config.padding / 2,),

                Text('XXXX 4321', style: Styles.titleStyle),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text('Имя Фамилия', style: Styles.titleStyle),

                      SizedBox(height: Config.padding / 2,),

                      Text('Demo1 Tng1', style: Styles.titleStyle),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      Text('Срок действия', style: Styles.titleStyle),

                      SizedBox(height: Config.padding / 2,),

                      Text('-/-', style: Styles.titleStyle),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}

