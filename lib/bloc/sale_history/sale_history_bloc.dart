
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Config.dart';
import '../../entity/ServicesStatistic.dart';
import '../../modelView/ExceptionLogger.dart';
import '../../repository/sale_history_repository.dart';

part 'sale_history_event.dart';
part 'sale_history_state.dart';

class SaleHistoryBloc extends Bloc<SaleHistoryEvent, SaleHistoryState> {
  final SaleHistoryRepository saleHistoryRepository;

  SaleHistoryBloc({
    required this.saleHistoryRepository
  }) : super(SaleHistoryInitialState()) {
    on<SaleHistoryGetEvent>((event, emit) async {
      emit(SaleHistoryLoadingState());

      try {
        final Map<dynamic, dynamic> responseInMap = await saleHistoryRepository
            .getSaleHistory(event.id, event.from, event.till);
        if (responseInMap['ErrorCode'] == null) {
          final Map<String, dynamic>? data = responseInMap['Data'];

          ServicesStatistic servicesStatistic = const ServicesStatistic(
            count: 0, salary: 0, groupedServices: null,
          );
          if (data != null) {
            servicesStatistic = ServicesStatistic.fromJson(data);
          }

          emit(SaleHistoryLoadedState(servicesStatistic: servicesStatistic));
        } else {
          RequestOptions requestOptions = responseInMap['request'];
          ExceptionLogger.sendException(
            address: requestOptions.path,
            request: requestOptions.data.toString(),
            exceptionTrace: '{${responseInMap['Data']}} '
                'with code {${responseInMap['ErrorCode']}} '
                'in method SaleHistoryBloc.SaleHistoryGetEvent',
          );
          log(
            'SaleHistoryBloc.SaleHistoryGetEvent: server error '
                '{${responseInMap['Data']}} with code {${responseInMap['ErrorCode']}}',
            name: Config.appName,
          );
          emit(const SaleHistoryErrorState(error: {
            'type': 'ServerError',
            'data': 'Произошла ошибка при загрузке данных. '
                'Перезайдите в приложение или обратитесь в подержку',
          }));
        }
      } catch (error) {
        log('SaleHistoryBloc.SaleHistoryGetEvent: {$error}', name: Config.appName);
        emit(SaleHistoryErrorState(error: error));
      }
    });
  }
}
