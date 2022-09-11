import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IOSDatePicker extends StatelessWidget {
  const IOSDatePicker({
    Key? key,
    required this.initialDateTime,
    required this.minimumDateTime,
    required this.maximumDateTime,
    required this.onChange,
  }) : super(key: key);

  final DateTime initialDateTime;
  final DateTime minimumDateTime;
  final DateTime maximumDateTime;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    final double windowHeight = MediaQuery.of(context).size.height;

    return Container(
      height: windowHeight * 0.5,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: windowHeight * 0.4,
            child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              minimumDate: minimumDateTime,
              maximumDate: maximumDateTime,
              onDateTimeChanged: (pickedDate) {
                onChange(pickedDate);
              },
              mode: CupertinoDatePickerMode.date,
            ),
          ),

          SizedBox(
            height: windowHeight * 0.1,
            child: CupertinoButton(
                child: const Text('Ok', style: TextStyle(fontSize: 20),),
                onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}

