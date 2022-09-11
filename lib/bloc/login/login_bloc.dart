
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';

import '../../Config.dart';
import '../../Storage.dart';
import '../../entity/Person.dart';
import '../../modelView/ExceptionLogger.dart';
import '../../repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitialState()) {
    on<LoginUpdateScreenState>((event, emit) {
      emit(LoginInitialState());
    });

    on<LoginAuthorize>((event, emit) async {
      emit(LoginLoadingState());

      final String name = event.name;
      final String pass = event.pass;
      final bool isSaveData = event.isSaveData;
      if (pass.trim().isEmpty || name.trim().isEmpty) {
        log(
          'LoginBloc.LoginAuthorize event: {login or password is empty}',
          name: Config.appName,
        );
        emit(LoginErrorState(error: const {
          'type': 'EmptyField', 'data': 'Пустое поле логина или пароля'
        }));
      } else {
        try {
          final Map<dynamic, dynamic> responseInMap = await loginRepository
              .getPerson(name, pass);

          if (responseInMap['ErrorCode'] == null) {
            final Map<String, dynamic> data = responseInMap['Data'];
            /// save user data
            if (isSaveData) {
              Storage.set(Config.username, name);
              EncryptedStorage.set(Config.password, pass);
            } else {
              Storage.clear();
              EncryptedStorage.clear();
            }
            Storage.set(Config.isSaveData, '$isSaveData');
            EncryptedStorage.set(Config.userKey, data['UserId']);
            Storage.set(Config.employeeId, '${data['personInfo']['id']}');
            emit(LoginLoadedState(person: Person.fromJson(data)));
          } else {
            RequestOptions requestOptions = responseInMap['request'];
            ExceptionLogger.sendException(
              address: requestOptions.path,
              request: requestOptions.data.toString(),
              exceptionTrace: '{${responseInMap['Data']}} '
                  'with code {${responseInMap['ErrorCode']}} '
                  'in LoginBloc.LoginAuthorize event',
            );
            log('LoginBloc.LoginAuthorize event: server error '
                '{${responseInMap['Data']}} '
                'with code {${responseInMap['ErrorCode']}}',
              name: Config.appName,
            );
            emit(LoginErrorState(error: {
              'type': 'ServerError', 'data': responseInMap['Data'],
            }));
          }
        } catch (error) {
          log('LoginBloc.LoginAuthorize event: {$error}', name: Config.appName);
          emit(LoginErrorState(error: error));
        }
      }
    });
  }
}
