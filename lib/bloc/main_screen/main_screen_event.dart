part of 'main_screen_bloc.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();
  
  @override
  List<Object?> get props => [];
}

class MainScreenChangeScreen extends MainScreenEvent {
  final int index;
  
  const MainScreenChangeScreen({required this.index});
  
  @override
  List<Object?> get props => [index];
}
