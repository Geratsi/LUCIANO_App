
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../Config.dart';
import '../../../components/AppointmentView.dart';
import '../../../entity/AppointmentDataSource.dart';

class ScheduleComponent extends StatelessWidget {
  const ScheduleComponent({
    Key? key,
    required this.controller,
    required this.onCellTapped,
    required this.onViewChanged,
    required this.appointmentDataSource,
  }) : super(key: key);

  final CalendarController controller;
  final AppointmentDataSource appointmentDataSource;
  final Function(CalendarTapDetails) onCellTapped;
  final Function(ViewChangedDetails) onViewChanged;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      firstDayOfWeek: 1,
      onTap: onCellTapped,
      controller: controller,
      dataSource: appointmentDataSource,
      allowedViews: const [CalendarView.day, CalendarView.month],
      headerHeight: controller.view == CalendarView.month ? 40 : 0,
      onViewChanged: onViewChanged,
      cellBorderColor: Config.activityHintColor,
      viewHeaderHeight: controller.view == CalendarView.month ? 20 : 56,
      showCurrentTimeIndicator: true,
      appointmentTimeTextFormat: 'HH:mm',
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(minutes: 30), timeFormat: 'HH:mm',
      ),
      selectionDecoration: BoxDecoration(
        border: Border.all(width: 1, color: controller.view == CalendarView.day
            ? Colors.transparent : Config.primaryColor),
      ),
      monthViewSettings: const MonthViewSettings(
        showTrailingAndLeadingDates: false,
        appointmentDisplayCount: 100,
        monthCellStyle: MonthCellStyle(
          todayBackgroundColor: Config.activityHintColor,
        ),
      ),
      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
        return AppointmentView(
          view: controller.view!,
          booking: details.appointments.first,
        );
      },
      // loadMoreWidgetBuilder: (BuildContext context, LoadMoreCallback loadMoreAppointments) {
      //   return FutureBuilder<void>(
      //     future: loadMoreAppointments(),
      //     builder: (context, snapshot) {
      //       if (snapshot.error != null) {
      //         return DialogComponent(
      //           title: Text('Ошибка', style: Styles.titleStyle,),
      //           actions: [
      //             DialogAction(label: 'Ок', callback: () {
      //               Navigator.of(context).pop();
      //             }),
      //           ],
      //         );
      //       }
      //
      //       return const FullGlassScreen();
      //     },
      //   );
      // },
    );
  }
}
