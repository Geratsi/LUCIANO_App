part of 'services_control_bloc.dart';

@immutable
abstract class ServicesControlEvent extends Equatable {
  const ServicesControlEvent();

  @override
  List<Object?> get props => [];
}

class LoadServiceCounter extends ServicesControlEvent {}

class ChangeServiceState extends ServicesControlEvent {
  final Service service;

  const ChangeServiceState({required this.service});

  @override
  List<Object?> get props => [service];
}

class ReloadServiceCounter extends ServicesControlEvent {}
