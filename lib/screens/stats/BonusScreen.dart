
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';

class BonusScreen extends StatelessWidget {
  const BonusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Премия'),
        flexibleSpace: Config.flexibleGradientSpace,
      ),

      body: const Center(
        child: Text('Bonus'),
      ),
    );
  }
}
