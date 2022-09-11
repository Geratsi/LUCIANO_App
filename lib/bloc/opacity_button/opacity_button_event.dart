part of 'opacity_button_bloc.dart';

abstract class OpacityButtonEvent extends Equatable {
  const OpacityButtonEvent();

  @override
  List<Object?> get props => [];
}

class OpacityButtonChangeState extends OpacityButtonEvent {
  final bool isDisabled;

  const OpacityButtonChangeState({required this.isDisabled});

  @override
  List<Object?> get props => [isDisabled];
}
