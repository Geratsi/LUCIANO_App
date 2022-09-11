
import 'package:intl/intl.dart';
import 'package:luciano/Styles.dart';
import 'package:luciano/Config.dart';
import 'package:flutter/material.dart';
import 'package:luciano/utilities/DateTimeFormat.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:luciano/components/TouchableOpacityEffect.dart';

class CalendarHeader extends StatefulWidget{
  const CalendarHeader({
    Key? key,
    required this.formatter,
    required this.allowedViews,
    required this.calendarController,
  }) : super(key: key);

  final DateTimeFormat formatter;
  final List<CalendarView> allowedViews;
  final CalendarController calendarController;

  @override
  _CalendarHeaderState createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  late DateTimeFormat _formatter;
  late CalendarController _calendarController;

  @override
  void initState() {
    _formatter = widget.formatter;
    _calendarController = widget.calendarController;

    super.initState();
  }

  String _getHeaderName() {
    final DateTime _validDate = _calendarController.displayDate ?? DateTime.now().toLocal();

    switch (_calendarController.view) {
      case CalendarView.day:
        return _formatter.getDateTimeString(_validDate, 'MMMMEEEEd');
      case CalendarView.week:
        return _formatter.getDateTimeString(_validDate, 'yMMMM');
      case CalendarView.month:
        return _formatter.getDateTimeString(_validDate, 'yMMMM');
      case CalendarView.schedule:
        return DateFormat('y').format(_validDate);
      default:
        return _formatter.getDateTimeString(_validDate, 'MMMMEEEEd');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _calendarController.view == CalendarView.schedule ? const SizedBox() :
          TouchableOpacityEffect(
            child: const Icon(Icons.chevron_left, size: Config.iconSize, color: Config.textTitleColor,),
            onPressed: () {
              _calendarController.backward!();
            },
          ),

          Text(_getHeaderName(), style: Styles.titleBoldStyle,),

          _calendarController.view == CalendarView.schedule ? const SizedBox() :
          TouchableOpacityEffect(
            child: const Icon(Icons.chevron_right, size: Config.iconSize, color: Config.textTitleColor,),
            onPressed: () {
              _calendarController.forward!();
            },
          ),
        ],
      ),
    );
  }
}
