
part of 'bookings_schedule_bloc.dart';

abstract class BookingsScheduleEvent extends Equatable {
  const BookingsScheduleEvent();

  @override
  List<Object?> get props => [];
}

class BookingsScheduleInitializeEvent extends BookingsScheduleEvent {}

class BookingsScheduleUpdateEvent extends BookingsScheduleEvent {
  const BookingsScheduleUpdateEvent();
}
