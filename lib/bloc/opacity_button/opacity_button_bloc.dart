
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'opacity_button_event.dart';
part 'opacity_button_state.dart';

class OpacityButtonBloc extends Bloc<OpacityButtonEvent, bool> {
  bool isDisabled;
  OpacityButtonBloc({required this.isDisabled}) : super(isDisabled) {
    on<OpacityButtonChangeState>((event, emit) {
      isDisabled = event.isDisabled;
      emit(event.isDisabled);
    });
  }
}
