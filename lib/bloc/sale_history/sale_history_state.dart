
part of 'sale_history_bloc.dart';

abstract class SaleHistoryState extends Equatable {
  const SaleHistoryState();

  @override
  List<Object> get props => [];
}

class SaleHistoryInitialState extends SaleHistoryState {}

class SaleHistoryLoadedState extends SaleHistoryState {
  final ServicesStatistic servicesStatistic;

  const SaleHistoryLoadedState({required this.servicesStatistic});
}

class SaleHistoryLoadingState extends SaleHistoryState {}

class SaleHistoryErrorState extends SaleHistoryState {
  final dynamic error;

  const SaleHistoryErrorState({required this.error});
}
