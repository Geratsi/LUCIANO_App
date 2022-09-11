
import 'package:flutter/material.dart';

class RecurrenceSettingsScreen extends StatefulWidget {
  const RecurrenceSettingsScreen({Key? key}) : super(key: key);

  @override
  _RecurrenceSettingsScreenState createState() => _RecurrenceSettingsScreenState();
}

class _RecurrenceSettingsScreenState extends State<RecurrenceSettingsScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка повтора'),
        centerTitle: true,
      ),

      body: const Center(
        child: Text('Custom recurrence'),
      ),
    );
  }
}

