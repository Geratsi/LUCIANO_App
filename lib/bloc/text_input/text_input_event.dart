part of 'text_input_bloc.dart';

@immutable
abstract class TextInputEvent {}

class TextInputVisibleOrNot extends TextInputEvent {
  final bool isVisible;

  TextInputVisibleOrNot({required this.isVisible});
}

class TextInputListenerEvent extends TextInputEvent {}

class TextInputChangeCurrentState extends TextInputEvent {
  final Color newColor;
  final String? newErrorText;

  TextInputChangeCurrentState({
    required this.newColor, this.newErrorText
  });
}
