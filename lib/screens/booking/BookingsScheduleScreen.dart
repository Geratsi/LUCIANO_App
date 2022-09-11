
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'components/BookingScheduleAvatar.dart';
import 'components/ScheduleComponent.dart';
import 'components/AnimatedRefreshIconButton.dart';
import '../../Config.dart';
import '../../Styles.dart';
import '../../entity/Person.dart';
import '../../entity/Booking.dart';
import '../../components/AgendaView.dart';
import '../../components/ModalProgress.dart';
import '../../utilities/DateTimeFormat.dart';
import '../../components/CalendarHeader.dart';
import '../../components/ErrorComponent.dart';
import '../../entity/AppointmentDataSource.dart';
import '../../bloc/bookings_schedule/bookings_schedule_bloc.dart';

class BookingsScheduleScreen extends StatefulWidget {
  const BookingsScheduleScreen({
    Key? key,
    required this.personInfo,
    required this.navigateToProfile,
    required this.appointmentDataSource,
  }) : super(key: key);

  final Person personInfo;
  final Function navigateToProfile;
  final AppointmentDataSource appointmentDataSource;

  @override
  _BookingsScheduleScreenState createState() => _BookingsScheduleScreenState();
}

class _BookingsScheduleScreenState extends State<BookingsScheduleScreen>
    with TickerProviderStateMixin {
  final Widget _dayLabel = const Padding(
    padding: EdgeInsets.symmetric(horizontal: 7),
    child: Text('День', key: ValueKey(1), style: Styles.titleStyle,),
  );
  final Widget _monthLabel = const Text(
    'Месяц', key: ValueKey(2), style: Styles.titleStyle,
  );
  final UniqueKey _calendarKey = UniqueKey();
  final List<Booking> _bookingsChunk = [];
  final CalendarController _controller = CalendarController();

  late Widget _buttonLabel;
  late DateTimeFormat _formatter;
  late AppointmentDataSource _appointmentDataSource;

  @override
  void initState() {
    super.initState();

    _buttonLabel = _monthLabel;
    _appointmentDataSource = widget.appointmentDataSource;
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {});
    });
  }

  void _onCellTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month && calendarTapDetails.targetElement != CalendarElement.appointment) {
      _bookingsChunk.clear();
      _bookingsChunk.addAll(calendarTapDetails.appointments!.cast<Booking>());
      setState(() {});
    }

    // else {
    //   Navigator.push<Widget>(
    //     context,
    //     MaterialPageRoute<Widget>(
    //       builder: (BuildContext context) => AppointmentEditorScreen(
    //         events: _appointmentDataSource,
    //         selectedDate: calendarTapDetails.date!,
    //         targetElement: calendarTapDetails.targetElement,
    //         selectedBooking: null,
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ErrorComponent errorComponent = ErrorComponent(context: context);
    _formatter = DateTimeFormat(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Брони'),
        flexibleSpace: Config.flexibleGradientSpace,
        leading: BookingsScheduleAvatar(
          imageBytes: widget.personInfo.imageBytes,
          navigateToProfile: widget.navigateToProfile,
        ),

        actions: [
          const AnimatedRefreshIconButton(),

          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),

      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: _controller.view == CalendarView.month ? 20 : 0,
            ),
            child: Column(
              children: <Widget>[
                Expanded(child: ScheduleComponent(
                  key: _calendarKey,
                  controller: _controller,
                  onCellTapped: _onCellTapped,
                  onViewChanged: _onViewChanged,
                  appointmentDataSource: _appointmentDataSource,
                )),

                _controller.view == CalendarView.month
                  ? Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Config.activityHintColor.withOpacity(.5),
                        height: double.infinity,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: Config.animDuration),
                          child: AgendaView(
                            key: ValueKey(Random().nextInt(100)),
                            formatter: _formatter,
                            bookingsChunk: _bookingsChunk,
                            appointmentDataSource: _appointmentDataSource,
                          ),
                          transitionBuilder: (Widget child, Animation<double> animation) =>
                              FadeTransition(opacity: animation, child: child,),
                        ),
                      ),
                    )
                  : Config.emptyWidget,
              ],
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              color: Config.activityBackColor,
              border: Border(bottom: BorderSide(color: Config.activityHintColor)),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: Config.animDuration),
              child: CalendarHeader(
                key: ValueKey(Random().nextInt(100)),
                formatter: _formatter,
                calendarController: _controller,
                allowedViews: const <CalendarView>[CalendarView.day, CalendarView.month],
              ),
            ),
          ),

          BlocBuilder<BookingsScheduleBloc, BookingsScheduleState>(
            builder: (context, state) {
              if (state is BookingsScheduleLoadingState) {
                _bookingsChunk.clear();
                return const FullGlassScreen();
              } else if (state is BookingsScheduleErrorState) {
                errorComponent.show(state.error);
              }

              return Config.emptyWidget;
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Config.primaryLightColor.withOpacity(.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Config.activityBorderRadius),
        ),
        onPressed: () {
          if (_controller.view == CalendarView.month) {
            _buttonLabel = _monthLabel;
            _controller.view = CalendarView.day;
          } else {
            _buttonLabel = _dayLabel;
            _controller.view = CalendarView.month;
          }
        },
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: Config.animDuration),
          child: _buttonLabel,
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(scale: animation, child: child,),
        ),
      ),
    );
  }
}
