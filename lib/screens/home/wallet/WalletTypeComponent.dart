
import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/screens/home/wallet/IncreaseWallet.dart';
import 'package:luciano/screens/home/wallet/DecreaseWallet.dart';
import 'package:luciano/Styles.dart';

class WalletTypeComponent extends StatelessWidget {
  const WalletTypeComponent({Key? key, required this.title, required this.total}) : super(key: key);

  final String title;
  final String total;
  final double dividerWidth = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Config.padding, Config.padding, Config.padding, Config.padding * 2,),
      child: Row(
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Text(title, style: Styles.textTitleColorStyle,),
                  ),

                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const Text('Баланс', style: Styles.textStyle,),

                        const SizedBox(height: Config.padding / 2,),

                        Text(total, style: Styles.textTitleColorStyle,),
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
                    left: BorderSide(width: dividerWidth, color: Config.textColor),
                  ),
                ),

                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const IncreaseWallet(),
                                ),
                              );
                            },

                            child: Row(
                              children: const <Widget>[
                                Text('Приход: ', style: Styles.textPrimaryStyle,),
                                Text('200', style: Styles.textTitleColorStyle,),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),

                    Divider(thickness: dividerWidth, color: Config.textColor,),

                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DecreaseWallet(),
                                  ),
                                );
                              },

                              child: Row(
                                children: const <Widget>[
                                  Text('Расход: ', style: Styles.textPrimaryStyle,),
                                  Text('150', style: Styles.textTitleColorStyle,),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),

              flex: 10,
            ),
          ],
        ),
    );
  }
}