
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'text_input_event.dart';
part 'text_input_state.dart';

class TextInputBloc extends Bloc<TextInputEvent, TextInputState> {
  bool isVisible;
  Color currentColor;
  String errorText;

  TextInputBloc({
    required this.isVisible, required this.currentColor, required this.errorText,
  }) : super(TextInputInitial(
    isVisible: isVisible, newColor: currentColor, errorText: errorText,
  )) {
    on<TextInputVisibleOrNot>((event, emit) {
      isVisible = event.isVisible;
      emit(TextInputInitial(
        isVisible: isVisible, newColor: currentColor, errorText: errorText,
      ));
    });

    on<TextInputChangeCurrentState>((event, emit) {
      currentColor = event.newColor;

      if (event.newErrorText != null) {
        errorText = event.newErrorText!;
      }

      emit(TextInputInitial(
        isVisible: isVisible, errorText: errorText, newColor: currentColor,
      ));
    });
  }
}
