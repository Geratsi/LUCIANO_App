
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Config.dart';
import '../../Storage.dart';
import '../../entity/Booking.dart';
import '../../modelView/ExceptionLogger.dart';
import '../../entity/AppointmentDataSource.dart';
import '../../repository/bookings_repository.dart';

part 'bookings_schedule_event.dart';
part 'bookings_schedule_state.dart';

class BookingsScheduleBloc extends Bloc<BookingsScheduleEvent, BookingsScheduleState> {
  final BookingsRepository bookingsRepository;
  final AppointmentDataSource appointmentDataSource;

  BookingsScheduleBloc({
    required this.bookingsRepository,
    required this.appointmentDataSource,
  }) : super(BookingsScheduleInitialState()) {
    on<BookingsScheduleInitializeEvent>((event, emit) async {
      final List<Booking>? bookings = await _getData(emit);
      if (bookings != null) {
        appointmentDataSource.initializeAppointmentDataSource(bookings);
      }

      await Future.delayed(const Duration(milliseconds: Config.progressDuration));

      emit(BookingsScheduleLoadedState());
    });

    on<BookingsScheduleUpdateEvent>((event, emit) async {
      final List<Booking>? bookings = await _getData(emit);
      if (bookings != null) {
        appointmentDataSource.refreshAppointmentDataSource(bookings);
      }

      await Future.delayed(const Duration(milliseconds: Config.progressDuration));

      emit(BookingsScheduleLoadedState());
    });

  }

  Future<List<Booking>?> _getData(Emitter emit) async {
    emit(BookingsScheduleLoadingState());

    final String? token = await EncryptedStorage.get(Config.userKey);

    if (token != null) {
      try {
        final Map<dynamic, dynamic> responseInMap = await bookingsRepository
            .getBookings(token);
        if (responseInMap['ErrorCode'] == null) {
          final List<Booking> bookings = [];

          for (var record in responseInMap['Data']) {
            bookings.add(Booking.fromJson(record));
          }

          return bookings;
        } else {
          RequestOptions requestOptions = responseInMap['request'];
          ExceptionLogger.sendException(
            address: requestOptions.path,
            request: requestOptions.data.toString(),
            exceptionTrace: '{${responseInMap['Data']}} '
                'with code {${responseInMap['ErrorCode']}} '
                'in method BookingsScheduleBloc.BookingsScheduleInitializeEvent',
          );
          log(
            'BookingsScheduleBloc.BookingsScheduleInitializeEvent: server error '
                '{${responseInMap['ErrorCode']}}',
            name: Config.appName,
          );
          emit(const BookingsScheduleErrorState(error: {
            'type': 'ServerError',
            'data': 'Произошла ошибка при загрузке данных. '
                'Перезайдите в приложение. Если не получится, '
                'обратитесь в поддержку'
          }));
        }
      } catch (error) {
        log(
          'BookingsScheduleBloc.BookingsScheduleInitializeEvent: {$error}',
          name: Config.appName,
        );
        emit(BookingsScheduleErrorState(error: error));
      }
    } else {
      log(
        'BookingsScheduleBloc.BookingsScheduleInitializeEvent: token is null',
        name: Config.appName,
      );
      emit(const BookingsScheduleErrorState(error: {
        'type': 'EmptyToken', 'data': 'Связующий токен не найден'
      }));
    }

    return null;
  }
}
