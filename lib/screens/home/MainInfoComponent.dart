
import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/screens/home/wallet/WalletScreen.dart';
import 'package:luciano/Styles.dart';

class MainInfoComponent extends StatelessWidget {
  const MainInfoComponent({Key? key}) : super(key: key);

  final double dividerWidth = 1;

  @override
  Widget build(BuildContext context) {
    final Divider divider = Divider(
      height: dividerWidth,
      color: Config.activityHintColor,
      thickness: dividerWidth,
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
                },

                child: Column(
                  children: const <Widget>[
                    Text('Баланс', style: Styles.titlePrimaryStyle,),

                    SizedBox(height: Config.padding / 2,),

                    Text('1000.00', style: Styles.titlePrimaryStyle,),
                  ],
                ),
              ),
            ],
          ),

          flex: 9,
        ),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: dividerWidth, color: Config.activityHintColor),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 3,
                      horizontal: Config.padding / 2),
                  child: Text('Кошелек', style: Styles.textTitleColorStyle,),
                ),

                divider,

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('Deposit account', style: Styles.textStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('200.00', style: Styles.textStyle,),
                ),

                divider,

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('Bonus account', style: Styles.textStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('800.00', style: Styles.textStyle,),
                ),

                divider,

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('Membership', style: Styles.textStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('-200.00', style: Styles.textStyle,),
                ),

                divider,

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('Deposit as discount', style: Styles.textStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('-', style: Styles.textStyle,),
                ),

                divider,

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 3,
                      horizontal: Config.padding / 2),
                  child: Text('Ваучеры', style: Styles.textTitleColorStyle,),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('50% Happy hour', style: Styles.textStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('UGDDAS', style: Styles.textStyle,),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Config.padding / 4,
                      horizontal: Config.padding / 2),
                  child: Text('-', style: Styles.textStyle,),
                ),
              ],
            ),
          ),

          flex: 10,
        ),
      ],
    );
  }
}

