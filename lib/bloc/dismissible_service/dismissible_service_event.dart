part of 'dismissible_service_bloc.dart';

@immutable
abstract class DismissibleServiceEvent {}

class ChangeServiceCount extends DismissibleServiceEvent {
  final int newValue;

  ChangeServiceCount({required this.newValue});
}

class ServiceCountIncrement extends DismissibleServiceEvent {}

class ServiceCountDecrement extends DismissibleServiceEvent {}
