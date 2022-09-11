
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Booking.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource({required this.source}) {
    // if (isBooking) {
    //   _bookingsData = BookingsFromServer.getBookings();
    // } else {
    //   /// check this line
    //   // _appointmentsData = Api.getAppointments();
    // }
  }

  late DateTime _endDate;
  late DateTime _startDate;
  late Future<Iterable<Booking>> _bookingsData;

  List<Booking> source;

  @override
  List<Booking> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].endTime;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].subject;
  }

  @override
  Color getColor(int index) {
    return source[index].color;
  }

  void initializeAppointmentDataSource(List<Booking> meetings) {
    if (meetings.isNotEmpty) {
      source.addAll(meetings);

      notifyListeners(CalendarDataSourceAction.add, meetings);
    }
  }

  void refreshAppointmentDataSource(List<Booking> meetings) {
    source = [];

    if (meetings.isNotEmpty) {
      source.addAll(meetings);

      notifyListeners(CalendarDataSourceAction.reset, meetings);
    }
  }

  // Future<void> _addAppointments({bool clear = false}) async {
  //   List<Booking> meetings = <Booking>[];
  //   Iterable<Booking> bookingsData = await _bookingsData;
  //
  //   DateTime date = DateTime(_startDate.year, _startDate.month, _startDate.day);
  //   DateTime appEndDate = DateTime(
  //     _endDate.year, _endDate.month, _endDate.day, 23, 59, 59,
  //   );
  //
  //   while (date.isBefore(appEndDate)) {
  //
  //     if (bookingsData.isEmpty) {
  //       date = date.add(const Duration(days: 1));
  //       continue;
  //     }
  //
  //     for (final Booking booking in bookingsData) {
  //
  //       if (source.any((element) => element.profileId == booking.profileId
  //           && element.bookingId == booking.bookingId )) {
  //         continue;
  //       }
  //
  //       if (source.contains(booking)) {
  //         continue;
  //       }
  //
  //       meetings.add(booking);
  //     }
  //
  //     date = date.add(const Duration(days: 1));
  //   }
  //
  //   source.addAll(meetings);
  //
  //   if (clear) {
  //     notifyListeners(CalendarDataSourceAction.reset, meetings);
  //   } else {
  //     notifyListeners(CalendarDataSourceAction.add, meetings);
  //   }
  // }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    _endDate = endDate;
    _startDate = startDate;

    // await _addAppointments();
  }
}
