part of 'checkbox_bloc.dart';

abstract class CheckboxState extends Equatable {
  const CheckboxState();
}

class CheckboxInitial extends CheckboxState {
  final bool isChecked;

  const CheckboxInitial({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}
