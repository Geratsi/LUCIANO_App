import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';

class DecreaseWallet extends StatelessWidget {
  const DecreaseWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.activityBackColor,

      appBar: AppBar(
        title: const Text('Расход'),
        centerTitle: true,
      ),

      body: Container(
        padding: const EdgeInsets.all(Config.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const <Widget>[
                Text('Нет операций', style: TextStyle(color: Colors.black38),),
              ],
            )
          ],
        ),
      ),
    );
  }
}