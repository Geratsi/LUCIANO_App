
part of 'sale_history_bloc.dart';

abstract class SaleHistoryEvent extends Equatable {
  const SaleHistoryEvent();

  @override
  List<Object?> get props => [];
}

class SaleHistoryGetEvent extends SaleHistoryEvent {
  final int id;
  final String from;
  final String till;

  const SaleHistoryGetEvent({
    required this.id, required this.from, required this.till
  });

  @override
  List<Object?> get props => [id, from, till];
}
