
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'touchable_opacity_event.dart';
part 'touchable_opacity_state.dart';

class TouchableOpacityBloc extends Bloc<TouchableOpacityEvent, int> {
  late double opacity;

  TouchableOpacityBloc({required this.opacity}) : super(0) {
    on<TouchableOpacityChangeState>((event, emit) {
      opacity = event.opacity;
      emit(state + 1);
    });
  }
}
