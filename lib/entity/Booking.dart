
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show IterableDiagnostics;

import '../Config.dart';

class Booking with Diagnosticable {

  final int ownerId;
  final int clientId;
  final int profileId;
  final int bookingId;
  final int tngClientId;
  final int saleManager;
  final int tngBookingId;
  final bool isAllDay;
  final Color color;
  final String title;
  final String client;
  final String subject;
  final String? roomName;
  final String? location;
  final String? endTimeZone;
  final Object? recurrenceId;
  final String? startTimeZone;
  final DateTime endTime;
  final DateTime startTime;
  final List<Object>? resourceIds;
  final List<DateTime>? recurrenceExceptionDates;

  int statusId;
  bool available;
  String statusName;
  Object? id;
  String? notes;
  String? recurrenceRule;

  AppointmentType _appointmentType = AppointmentType.normal;
  AppointmentType get appointmentType => _appointmentType;

  Booking({
    required this.title, required this.client, required this.profileId,
    required this.endTime, required this.startTime, required this.statusName,
    required this.bookingId, required this.saleManager, required this.statusId,
    required this.tngBookingId, required this.ownerId, required this.clientId,
    required this.tngClientId,
    this.id, this.notes, this.roomName,
    this.location, this.resourceIds, this.endTimeZone, this.recurrenceId,
    this.startTimeZone, this.recurrenceRule, this.recurrenceExceptionDates,
    this.color = Colors.lightBlue, this.subject = '', this.isAllDay = false,
    this.available = true,
  }) {
    if (statusId == 10001 || statusId == 10006 || statusId == 10005) {
      available = true;
    } else {
      available = false;
    }
    recurrenceRule = recurrenceId != null ? null : recurrenceRule;
    _appointmentType = _getAppointmentType();
    id = id ?? hashCode;
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      title: json['MedRecordName'], client: json['ClientFIO'],
      profileId: json['ClientTngId'], statusName: json['StatusName'],
      endTime: DateTime.parse(json['BookingDateFinishS']),
      startTime: DateTime.parse(json['BookingDateStartS']),
      bookingId: json['id'], saleManager: json['EmployeeTngId'],
      subject: '${json['ClientFIO']}${Config.groupSeparator}'
          '${json['MedRecordName']}', ownerId: json['OwnerId'],
      color: Config.appointmentColor, notes: json['Comment'],
      statusId: json['StatusId'], tngBookingId: json['TngId'],
      clientId: json['ClientId'], tngClientId: json['ClientTngId'],
      roomName: json['OfficeName'],
    );
  }

  /// Here we used isOccurrenceAppointment keyword to identify the
  /// occurrence appointment When we clone the pattern appointment for
  /// occurrence appointment we have append the string in the notes and here we
  /// identify based on the string and removed the appended string.
  AppointmentType _getAppointmentType() {
    if (recurrenceId != null) {
      return AppointmentType.changedOccurrence;
    } else if (recurrenceRule != null && recurrenceRule!.isNotEmpty) {
      if (notes != null && notes!.contains('isOccurrenceAppointment')) {
        notes = notes!.replaceAll('isOccurrenceAppointment', '');
        return AppointmentType.occurrence;
      }

      return AppointmentType.pattern;
    }
    return AppointmentType.normal;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final Booking otherStyle;
    if (other is Booking) {
      otherStyle = other;
    }
    return otherStyle.startTime == startTime &&
        otherStyle.endTime == endTime &&
        otherStyle.startTimeZone == startTimeZone &&
        otherStyle.endTimeZone == endTimeZone &&
        otherStyle.isAllDay == isAllDay &&
        otherStyle.notes == notes &&
        otherStyle.location == location &&
        otherStyle.resourceIds == resourceIds &&
        otherStyle.subject == subject &&
        otherStyle.color == color &&
        otherStyle.recurrenceExceptionDates == recurrenceExceptionDates &&
        otherStyle.recurrenceId == recurrenceId &&
        otherStyle.id == id &&
        otherStyle.appointmentType == appointmentType;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return hashValues(
      startTimeZone,
      endTimeZone,
      recurrenceRule,
      isAllDay,
      notes,
      location,
      hashList(resourceIds),
      recurrenceId,
      id,
      appointmentType,
      startTime,
      endTime,
      subject,
      color,
      hashList(recurrenceExceptionDates),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('startTimeZone', startTimeZone));
    properties.add(StringProperty('endTimeZone', endTimeZone));
    properties.add(StringProperty('recurrenceRule', recurrenceRule));
    properties.add(StringProperty('notes', notes));
    properties.add(StringProperty('location', location));
    properties.add(StringProperty('subject', subject));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Object>('recurrenceId', recurrenceId));
    properties.add(DiagnosticsProperty<Object>('id', id));
    properties
        .add(EnumProperty<AppointmentType>('appointmentType', appointmentType));
    properties.add(DiagnosticsProperty<DateTime>('startTime', startTime));
    properties.add(DiagnosticsProperty<DateTime>('endTime', endTime));
    properties.add(IterableDiagnostics<DateTime>(recurrenceExceptionDates)
        .toDiagnosticsNode(name: 'recurrenceExceptionDates'));
    properties.add(IterableDiagnostics<Object>(resourceIds)
        .toDiagnosticsNode(name: 'resourceIds'));
    properties.add(DiagnosticsProperty<bool>('isAllDay', isAllDay));
  }
}
