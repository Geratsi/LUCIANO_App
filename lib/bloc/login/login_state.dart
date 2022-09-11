part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadedState extends LoginState {
  final Person person;

  LoginLoadedState({required this.person});
}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final dynamic error;

  LoginErrorState({required this.error});
}
