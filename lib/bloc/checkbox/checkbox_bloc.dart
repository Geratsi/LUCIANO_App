
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'checkbox_event.dart';
part 'checkbox_state.dart';

class CheckboxBloc extends Bloc<CheckboxEvent, CheckboxState> {
  bool isChecked;

  CheckboxBloc({required this.isChecked}) : super(
    CheckboxInitial(isChecked: isChecked,),
  ) {
    on<CheckboxChangeState>((event, emit) {
      isChecked = event.isChecked;
      emit(CheckboxInitial(isChecked: isChecked));
    });
  }
}
