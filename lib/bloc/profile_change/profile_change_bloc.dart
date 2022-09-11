
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_change_event.dart';

class ProfileChangeBloc extends Bloc<ProfileChangeEvent, int> {
  ProfileChangeBloc() : super(0) {
    on<ProfileChangeUpdateEvent>((event, emit) {
      emit(state + 1);
    });
  }
}
