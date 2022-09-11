part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginAuthorize extends LoginEvent {
  final String name;
  final String pass;
  final bool isSaveData;

  LoginAuthorize({
    required this.name, required this.pass, required this.isSaveData,
  });
}

class LoginUpdateScreenState extends LoginEvent {}
