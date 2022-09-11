
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_screen_event.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, int> {
  MainScreenBloc() : super(0) {
    on<MainScreenChangeScreen>((event, emit) {
      emit(event.index);
    });
  }
}
