
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:luciano/Config.dart';

class BookingItem {

  late String title;
  late String client;
  late int profileId;
  late String status;
  late int bookingId;
  late String comment;
  late int saleManager;
  late DateTime endTime;
  late DateTime startTime;
  late Appointment appointment;

  BookingItem({
    required this.title, required this.client, required this.profileId,
    required this.endTime, required this.startTime, required this.status,
    required this.comment, required this.bookingId, required this.saleManager,
  }) {
    appointment = Appointment(
      subject: '$client${Config.groupSeparator}$title', notes: comment,
      color: Config.activityHintColor, startTime: startTime, endTime: endTime,
      id: bookingId,
    );
  }
}
