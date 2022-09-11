
import 'package:flutter/material.dart';

import 'package:luciano/Config.dart';

class FinesScreen extends StatelessWidget {
  const FinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Штрафы'),
        flexibleSpace: Config.flexibleGradientSpace,
      ),

      body: const Center(
        child: Text('Fines'),
      ),
    );
  }
}

