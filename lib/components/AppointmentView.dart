
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'TouchableOpacityEffect.dart';
import '../Config.dart';
import '../Styles.dart';
import '../entity/Booking.dart';
import '../utilities/DateTimeFormat.dart';
import '../screens/booking/BookingScreen.dart';
import '../bloc/services_control/services_control_bloc.dart';
import '../bloc/final_salary_booking/final_salary_bloc.dart';
import '../bloc/bookings_schedule/bookings_schedule_bloc.dart';

Color getBookingColor(Booking booking) {
  switch (booking.statusId) {
    case 10004:
      return Config.successColor.withOpacity(.7);
    case 10001:
    case 10006:
    case 10005:
      return Config.primaryColor;
    default:
      return Config.errorColor.withOpacity(.8);
  }
}

class AppointmentView extends StatelessWidget {
  const AppointmentView({
    Key? key,
    required this.view,
    required this.booking,
  }) : super(key: key);

  final Booking booking;
  final CalendarView view;

  @override
  Widget build(BuildContext context) {
    final bool isMonthView = view == CalendarView.month;
    final List<String> mainInfo =  booking.subject.split(Config.groupSeparator);
    final DateTimeFormat formatter = DateTimeFormat(
      Localizations.localeOf(context).languageCode,
    );
    final BookingsScheduleBloc bookingsScheduleBloc = context.read<BookingsScheduleBloc>();

    return TouchableOpacityEffect(
      onPressed: () {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return MultiBlocProvider(
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
              );
              
              // } else {
              //   return const SizedBox();
              //   return AppointmentEditorScreen(
              //     events: appointmentDataSource,
              //     selectedDate: booking.startTime,
              //     targetElement: CalendarElement.appointment,
              //     selectedBooking: booking,
              //   );
              // }
            },
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: getBookingColor(booking),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Config.smallBorderRadius),
            bottomRight: Radius.circular(Config.smallBorderRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: Config.padding / 3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Config.smallBorderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: booking.color,
                // borderRadius: BorderRadius.circular(Config.activityBorderRadius),
              ),
              child: Row(
                children: <Widget>[
                  isMonthView ? Padding(
                    padding: const EdgeInsets.all(Config.padding / 3),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Config.textColorOnPrimary)),
                      ),
                      padding: const EdgeInsets.only(right: Config.padding / 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          booking.isAllDay ? const SizedBox() : Text(
                            formatter.getDateTimeString(booking.startTime, 'HH:mm'),
                            style: Styles.textWhiteStyle,
                          ),

                          booking.isAllDay ? const Text(
                            'All Day',
                            style: Styles.textWhiteStyle,
                            // textAlign: TextAlign.center,
                          ) : const SizedBox(),

                          booking.isAllDay ? const SizedBox() : Text(
                            formatter.getDateTimeString(booking.endTime, 'HH:mm'),
                            style: Styles.textWhiteStyle,
                          ),
                        ],
                      ),
                    ),
                  ) : const SizedBox(),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMonthView ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: Config.padding / 4,),
                          child: Text(
                            mainInfo[0],
                            style: Styles.textWhiteBoldStyle,
                          ),
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: Config.padding / 4,),
                          // user fio
                          child: Text(
                            mainInfo[1],
                            style: Styles.textWhiteHeight_1Style
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
