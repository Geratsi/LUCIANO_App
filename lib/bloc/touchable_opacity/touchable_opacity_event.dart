part of 'touchable_opacity_bloc.dart';

abstract class TouchableOpacityEvent extends Equatable {
  const TouchableOpacityEvent();

  @override
  List<Object?> get props => [];
}

class TouchableOpacityChangeState extends TouchableOpacityEvent {
  final double opacity;

  const TouchableOpacityChangeState({required this.opacity});

  @override
  List<Object?> get props => [opacity];
}
