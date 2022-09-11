import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luciano/components/MainOutlinedButton.dart';
import 'package:luciano/components/ios/ios_date_picker.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';
import 'package:luciano/utilities/DateTimeFormat.dart';
import 'package:luciano/utilities/ValueListener.dart';

class DateAndTimePicker extends StatefulWidget {
  const DateAndTimePicker({
    Key? key,
    required this.isAllDay,
    required this.endDateController,
    required this.startDateController,
    required this.formatter,
  }) : super(key: key);

  final bool isAllDay;
  final ValueListener endDateController;
  final ValueListener startDateController;
  final DateTimeFormat formatter;

  @override
  _DateAndTimePickerState createState() => _DateAndTimePickerState();
}

class _DateAndTimePickerState extends State<DateAndTimePicker> {
  late DateTime _selectedEndDate;
  late DateTime _selectedStartDate;
  late DateTimeFormat _formatter;

  @override
  void initState() {
    super.initState();

    _selectedStartDate = widget.startDateController.getValue;
    _selectedEndDate = widget.endDateController.getValue;
    _formatter = widget.formatter;
  }

  void _selectDate() async {
    DateTime _now = DateTime.now().toLocal();

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => IOSDatePicker(
          initialDateTime: widget.startDateController.getValue,
          minimumDateTime: DateTime(_now.year),
          maximumDateTime: DateTime(_now.year + 1, _now.month, _now.day), // future
          onChange: (pickedDate) {
            if (pickedDate != null) {
              setState(() {_selectedStartDate = pickedDate;});
              widget.startDateController.setValue = pickedDate;
            }
          },
        ),
      );

    } else if (Platform.isAndroid) {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime(_now.year),
        lastDate: DateTime(_now.year + 1, _now.month, _now.day),
      );

      if (pickedDate != null && pickedDate != _selectedStartDate) {
        setState(() {_selectedStartDate = pickedDate;});
        widget.startDateController.setValue = pickedDate;
      }
    }
  }

  void _selectTime(BuildContext context, ValueListener controller, DateTime value, bool isStart) async {
    DateTime _now = DateTime.now().toLocal();

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => IOSDatePicker(
          initialDateTime: controller.getValue,
          minimumDateTime: DateTime(1930),
          maximumDateTime: DateTime(_now.year - 18, _now.month, _now.day),
          onChange: (pickedDate) {
            if (pickedDate != null) {
              controller.setValue = DateTime(
                value.year, value.month, value.day,
                pickedDate.hour, pickedDate.minute,
              );
              setState(() {
                if (isStart) {
                  _selectedStartDate = controller.getValue;
                } else {
                  _selectedEndDate = controller.getValue;
                }
              });
              controller.setValue = pickedDate;
            }
          },
        ),
      );

    } else if (Platform.isAndroid) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: value.hour,
            minute: value.minute,
        ),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
      );

      if (pickedTime != null) {
        controller.setValue = DateTime(
          value.year, value.month, value.day,
          pickedTime.hour, pickedTime.minute,
        );
        setState(() {
          if (isStart) {
            _selectedStartDate = controller.getValue;
          } else {
            _selectedEndDate = controller.getValue;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final String _languageCode = Localizations.localeOf(context).languageCode;

    return Column(
        children: <Widget>[
          //start
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Начало', style: Styles.textTitleColorStyle,),

              Row(
                children: <Widget>[
                  MainOutlinedButton(
                    label: _formatter.getDateTimeString(_selectedStartDate, 'EEE, dd MMM y'),
                    onPressed: _selectDate,
                    backgroundColor: Config.activityHintColor,
                    padding: const EdgeInsets.symmetric(vertical: Config.padding / 3,
                        horizontal: Config.padding / 2),
                    labelStyle: Styles.textTitleColorStyle,
                  ),

                  widget.isAllDay
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: Config.padding / 3),
                        child: MainOutlinedButton(
                          label: _formatter.getDateTimeString(_selectedStartDate, 'HH:mm'),
                          onPressed: () {
                            _selectTime(
                              context,
                              widget.startDateController,
                              _selectedStartDate,
                              true,
                            );
                          },
                          backgroundColor: Config.activityHintColor,
                          padding: const EdgeInsets.symmetric(vertical: Config.padding / 3,
                              horizontal: Config.padding / 2),
                          labelStyle: Styles.textTitleColorStyle,
                        ),
                      ),
                ],
              ),
            ],
          ),

          const SizedBox(height: Config.padding / 2,),

          //end
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Конец', style: Styles.textTitleColorStyle,),

              Row(
                children: <Widget>[
                  MainOutlinedButton(
                    label: _formatter.getDateTimeString(_selectedEndDate, 'EEE, dd MMM y'),
                    onPressed: _selectDate,
                    backgroundColor: Config.activityHintColor,
                    padding: const EdgeInsets.symmetric(vertical: Config.padding / 3,
                        horizontal: Config.padding / 2),
                    labelStyle: Styles.textTitleColorStyle,
                  ),

                  widget.isAllDay
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: Config.padding / 3),
                        child: MainOutlinedButton(
                          label: _formatter.getDateTimeString(_selectedEndDate, 'HH:mm'),
                          onPressed: () {
                            _selectTime(
                              context,
                              widget.endDateController,
                              _selectedEndDate,
                              true,
                            );
                          },
                          backgroundColor: Config.activityHintColor,
                          padding: const EdgeInsets.symmetric(vertical: Config.padding / 3,
                              horizontal: Config.padding / 2),
                          labelStyle: Styles.textTitleColorStyle,
                        ),
                      ),
                ],
              ),
            ],
          ),
        ]
    );
  }
}

