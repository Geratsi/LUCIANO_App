
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:luciano/entity/Booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';
import 'package:luciano/entity/CalendarViews.dart';
import 'package:luciano/utilities/DateTimeFormat.dart';
import 'package:luciano/components/AppointmentView.dart';
import 'package:luciano/entity/AppointmentDataSource.dart';
import 'package:luciano/components/FloatingActionBubble.dart';
import 'package:luciano/components/CalendarHeader.dart';
import 'package:luciano/components/AgendaView.dart';

class MainScheduleScreen extends StatefulWidget {
  const MainScheduleScreen({Key? key,}) : super(key: key);

  @override
  _MainScheduleScreenState createState() => _MainScheduleScreenState();
}

class _MainScheduleScreenState extends State<MainScheduleScreen> with SingleTickerProviderStateMixin {
  late DateTimeFormat _formatter;
  // late List<DateTime> _visibleDates;
  late Animation<double> _animation;
  late CalendarController _controller;
  late AnimationController _animationController;
  late AppointmentDataSource _appointmentDataSource;

  List<Booking>? _bookingsChunk;
  // CalendarTapDetails? _calendarTapDetails;
  Widget _floatingButton = const Text('Вид', style: Styles.titleStyle,);

  @override
  void initState() {
    super.initState();

    _controller = CalendarController();
    _controller.view = CalendarView.day;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: Config.animDuration),
    );
    _appointmentDataSource = AppointmentDataSource(
      source: <Booking>[],
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
      _animationController.dispose();
    }

    super.dispose();
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    // _visibleDates = visibleDatesChangedDetails.visibleDates;

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {});
    });
  }

  Widget scheduleViewBuilder(BuildContext buildContext, ScheduleViewMonthHeaderDetails details,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _formatter.getDateTimeString(details.date, 'yMMMM'),
          style: Styles.titleStyle,
        ),
      ],
    );
  }

  void _onCellTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month && calendarTapDetails.targetElement != CalendarElement.appointment) {
      setState(() {
        _bookingsChunk = calendarTapDetails.appointments!.cast<Booking>();
        // _calendarTapDetails = calendarTapDetails;
      });
    }
  }

  SfCalendar _getSfCalendar() {
    return SfCalendar(
      firstDayOfWeek: 1,
      onTap: _onCellTapped,
      controller: _controller,
      onViewChanged: _onViewChanged,
      dataSource: _appointmentDataSource,
      appointmentTimeTextFormat: 'HH:mm',
      allowedViews: CalendarViews.allowedViews,
      cellBorderColor: Config.activityHintColor,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      headerHeight: _controller.view == CalendarView.month ? 40 : 0,
      viewHeaderHeight: _controller.view == CalendarView.month ? 20 : 56,
      selectionDecoration: BoxDecoration(
        border: Border.all(width: 2, color: _controller.view == CalendarView.day
            ? Colors.transparent : Config.primaryColor),
      ),
      monthViewSettings: const MonthViewSettings(
        showTrailingAndLeadingDates: false,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(hours: 1), timeFormat: 'HH:mm',
      ),
      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) =>
          AppointmentView(
            view: _controller.view!,
            booking: details.appointments.first,
          ),
      loadMoreWidgetBuilder: (BuildContext context, LoadMoreCallback loadMoreAppointments) {
        return FutureBuilder<void>(
          future: loadMoreAppointments(),
          builder: (context, snapshot) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator.adaptive(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _formatter = DateTimeFormat(Localizations.localeOf(context).languageCode);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: _controller.view == CalendarView.month ? 20 : 0),
            child: Column(
              children: <Widget>[
                Expanded(child: _getSfCalendar(),),

                _controller.view == CalendarView.month
                    ? Expanded(
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Config.activityHintColor,
                      child: _bookingsChunk != null
                          ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: Config.padding / 2),
                        child: AgendaView(
                          formatter: _formatter,
                          bookingsChunk: _bookingsChunk!,
                          appointmentDataSource: _appointmentDataSource,
                          // refreshAppointmentDataSource: () {},
                        ),
                      ) : const SizedBox()
                  ),
                )
                    : const SizedBox(),
              ],
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              color: Config.activityHintColor,
              border: Border(bottom: BorderSide(width: 1, color: Config.textTitleColor)),
            ),
            child: CalendarHeader(
              formatter: _formatter,
              calendarController: _controller,
              allowedViews: const <CalendarView>[CalendarView.day, CalendarView.month],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionBubble(
        animation: _animation,
        title: _floatingButton,
        onPress: () {
          if (_animationController.isCompleted) {
            setState(() {
              _floatingButton = const Text('Вид', style: Styles.titleStyle,);
            });
            _animationController.reverse();
          } else {
            setState(() {
              _floatingButton = const Icon(
                Icons.close,
                color: Config.textTitleColor,
                size: Config.iconSize,
              );
            });
            _animationController.forward();
          }
        },
        items: <BubbleMenuItem>[
          BubbleMenuItem(
            child: const Text('Календарь', style: Styles.titleStyle,),
            onPress: () {
              _controller.view = CalendarView.schedule;
              _animationController.reverse();
              setState(() {
                _floatingButton = const Text('Вид', style: Styles.titleStyle,);
              });
            },
          ),

          BubbleMenuItem(
            child: const Text('Месяц', style: Styles.titleStyle,),
            onPress: () {
              _controller.view = CalendarView.month;
              _animationController.reverse();
              setState(() {
                _floatingButton = const Text('Вид', style: Styles.titleStyle,);
              });
            },
          ),

          BubbleMenuItem(
            child: const Text('День', style: Styles.titleStyle,),
            onPress: () {
              _controller.view = CalendarView.day;
              _animationController.reverse();
              setState(() {
                _floatingButton = const Text('Вид', style: Styles.titleStyle,);
              });
            },
          ),
        ],
      ),
    );
  }
}
