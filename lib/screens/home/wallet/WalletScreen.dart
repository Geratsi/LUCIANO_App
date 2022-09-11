
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/screens/home/wallet/WalletTypeComponent.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  final double swiperHeight = 260;

  static const List<WalletTypeComponent> data = <WalletTypeComponent>[
    WalletTypeComponent(title: 'Deposit', total: '200.00'),
    WalletTypeComponent(title: 'Bonus', total: '800.00'),
    WalletTypeComponent(title: 'Membership', total: '-200.00'),
    WalletTypeComponent(title: 'Discount', total: '-'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кошелек'),
      ),

      body: Column(
        children: <Widget>[
          Container(
            color: Config.activityHintColor,
            height: swiperHeight,
            child: Swiper(
              pagination: const SwiperPagination(),
              itemBuilder: (BuildContext context, int index) {
                return data[index];
              },
              itemCount: data.length,
              layout: SwiperLayout.DEFAULT,
            ),
          ),
        ],
      ),
    );
  }
}
