part of 'text_input_bloc.dart';

@immutable
abstract class TextInputState {}

class TextInputInitial extends TextInputState {
  final bool isVisible;
  final Color newColor;
  final String errorText;

  TextInputInitial({
    required this.isVisible, required this.errorText, required this.newColor,
  });
}

class TextInputError extends TextInputState {
  final String errorText;

  TextInputError({required this.errorText});
}
