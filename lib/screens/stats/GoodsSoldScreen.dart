
import 'package:flutter/material.dart';

import '../../Config.dart';

class GoodsSoldScreen extends StatelessWidget {
  const GoodsSoldScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Проданные товары'),
        flexibleSpace: Config.flexibleGradientSpace,
      ),

      body: const Center(
        child: Text('Goods sold'),
      ),
    );
  }
}

