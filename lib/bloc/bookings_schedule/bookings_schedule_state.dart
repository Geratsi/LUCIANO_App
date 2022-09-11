
part of 'bookings_schedule_bloc.dart';

abstract class BookingsScheduleState extends Equatable {
  const BookingsScheduleState();

  @override
  List<Object> get props => [];
}

class BookingsScheduleInitialState extends BookingsScheduleState {}

class BookingsScheduleLoadedState extends BookingsScheduleState {}

class BookingsScheduleLoadingState extends BookingsScheduleState {}

class BookingsScheduleErrorState extends BookingsScheduleState {
  final dynamic error;

  const BookingsScheduleErrorState({required this.error});
}