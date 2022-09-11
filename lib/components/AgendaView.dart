
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'AppointmentView.dart';
import 'TouchableOpacityEffect.dart';
import '../Config.dart';
import '../entity/Booking.dart';
import '../utilities/DateTimeFormat.dart';
import '../entity/AppointmentDataSource.dart';
import '../screens/booking/BookingScreen.dart';
import '../bloc/services_control/services_control_bloc.dart';
import '../bloc/final_salary_booking/final_salary_bloc.dart';
import '../bloc/bookings_schedule/bookings_schedule_bloc.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({
    Key? key,
    required this.formatter,
    required this.bookingsChunk,
    required this.appointmentDataSource,
  }) : super(key: key);

  final List<Booking> bookingsChunk;
  final DateTimeFormat formatter;
  final AppointmentDataSource appointmentDataSource;

  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  // late DateTimeFormat _formatter;
  late List<Booking> _bookingsChunk;

  @override
  void initState() {
    super.initState();

    _bookingsChunk = widget.bookingsChunk;
  }

  @override
  void didUpdateWidget(covariant AgendaView oldWidget) {
    super.didUpdateWidget(oldWidget);

    _bookingsChunk = widget.bookingsChunk;
  }

  void _getBookingScreen(Booking booking, BookingsScheduleBloc bookingsScheduleBloc) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<FinalSalaryBloc>(create: (context) => FinalSalaryBloc()),
          BlocProvider<ServicesControlBloc>(
            create: (context) => ServicesControlBloc()..add(LoadServiceCounter()),
          ),
        ],
        child: BookingScreen(
          selectedBooking: booking,
          refreshAppointmentDataSource: () {
            bookingsScheduleBloc.add(const BookingsScheduleUpdateEvent());
          },
        ),
      ),
    ),);

    // } else {
    //   if (_calendarTapDetails != null) {
    //     Navigator.push(context, MaterialPageRoute(
    //       builder: (context) => AppointmentEditorScreen(
    //         events: widget.appointmentDataSource,
    //         selectedDate: _calendarTapDetails!.date!,
    //         targetElement: _calendarTapDetails!.targetElement,
    //         selectedBooking: appointment,
    //       ),
    //     ),);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final BookingsScheduleBloc bookingsScheduleBloc = context.read<BookingsScheduleBloc>();

    return BlocBuilder<BookingsScheduleBloc, BookingsScheduleState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ListView.separated(
            itemCount: _bookingsChunk.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => const SizedBox(height: Config.padding / 2,),
            padding: const EdgeInsets.fromLTRB(
              Config.padding, Config.padding / 2, Config.padding, Config.padding * 4.5,
            ),
            itemBuilder: (context, index) {
              final Booking booking = _bookingsChunk[index];
              // final List<String> mainInfo = booking.subject.split(Config.groupSeparator);

              return TouchableOpacityEffect(
                onPressed: () {
                  _getBookingScreen(booking, bookingsScheduleBloc);
                },
                child: AppointmentView(
                  view: CalendarView.month,
                  booking: booking,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
