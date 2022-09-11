part of 'touchable_opacity_bloc.dart';

abstract class TouchableOpacityState extends Equatable {
  const TouchableOpacityState();
}

class TouchableOpacityInitial extends TouchableOpacityState {
  final double opacity;

  const TouchableOpacityInitial({required this.opacity});

  @override
  List<Object> get props => [];
}
