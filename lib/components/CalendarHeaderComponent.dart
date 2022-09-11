
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'TouchableOpacityEffect.dart';
import '../Config.dart';
import '../Styles.dart';
import '../utilities/DateTimeFormat.dart';

class CalendarHeaderComponent extends StatefulWidget {
  const CalendarHeaderComponent({
    Key? key,
    required this.formatter,
    required this.controller,
    required this.dateNotifier,
  }) : super(key: key);

  final DateTimeFormat formatter;
  final CalendarController controller;
  final ValueNotifier<DateTime> dateNotifier;

  @override
  _CalendarHeaderComponentState createState() => _CalendarHeaderComponentState();
}

class _CalendarHeaderComponentState extends State<CalendarHeaderComponent> {
  late int _selectedDay;
  late DateTimeFormat _formatter;
  late CalendarController _controller;
  late List<DateTime> _currentWeekDays;
  late ValueNotifier<DateTime> _dateNotifier;

  void initialize() {
    _formatter = widget.formatter;
    _controller = widget.controller;
    _dateNotifier = widget.dateNotifier;
    _currentWeekDays = _getWeekDays(DateTime.now().toLocal());
  }

  @override
  void initState() {
    super.initState();

    initialize();
  }

  @override
  void didUpdateWidget(covariant CalendarHeaderComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    initialize();
  }

  List<DateTime> _getWeekDays(DateTime date) {
    final DateTime firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  List<Widget> _getWeekDaysWidgets(List<DateTime> weekDays) {
    return weekDays.map(
      (weekDay) => Column(
        children: <Widget>[
          Text(
            _formatter.getDateTimeString(weekDay, 'E').toUpperCase(),
            style: Styles.textTitleColorSmallStyle,
          ),

          TouchableOpacityEffect(
            child: Container(
              decoration: BoxDecoration(
                color: _selectedDay == weekDay.day ? Config.primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),

              child: SizedBox(
                width: 28,
                height: 28,
                child: Center(
                  child: Text(
                    weekDay.day.toString(),
                    style: Styles.textTitleColorSmallStyle,
                  ),
                ),
              ),
            ),
            onPressed: () {
              _controller.displayDate = weekDay;
              _dateNotifier.value = weekDay;
            },
          ),
        ],
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _dateNotifier,
      builder: (BuildContext context, DateTime viewDate, Widget? child) {
        _selectedDay = viewDate.day;
        final List<DateTime> weekDays = _getWeekDays(viewDate);
        if (_currentWeekDays[0].day != weekDays[0].day) {
          _currentWeekDays = weekDays;
        }

        return Column(
          children: <Widget>[
            const SizedBox(height: Config.padding / 4,),

            Text(
              _formatter.getDateTimeString(viewDate, 'yMMMM'),
              style: Styles.textTitleColorStyle,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(Config.padding * 3, Config.padding / 5,
                Config.padding, Config.padding / 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _getWeekDaysWidgets(weekDays),
              ),
            ),
          ],
        );
      },
    );
  }
}

