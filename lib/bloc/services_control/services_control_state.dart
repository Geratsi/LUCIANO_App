
part of 'services_control_bloc.dart';

@immutable
abstract class ServicesControlState extends Equatable {
  const ServicesControlState();

  @override
  List<Object> get props => [];
}

class ServicesControlInitial extends ServicesControlState {}

class ServiceControlLoaded extends ServicesControlState {
  final List<Service> loadedServices;

  const ServiceControlLoaded({required this.loadedServices});

  @override
  List<Object> get props => [loadedServices];
}

class ServiceControlLoadingError extends ServicesControlState {
  final dynamic error;

  const ServiceControlLoadingError({required this.error});
}
