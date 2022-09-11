
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dismissible_service_event.dart';
part 'dismissible_service_state.dart';

class DismissibleServiceBloc extends Bloc<DismissibleServiceEvent, int> {
  late bool isDecrementActive;

  int count;

  DismissibleServiceBloc({required this.count}) : super(count) {
    isDecrementActive = count > 1;

    on<ChangeServiceCount>((event, emit) {
      count = event.newValue;
      isDecrementActive = count > 1;
      emit(event.newValue);
    });

    on<ServiceCountIncrement>((event, emit) {
      if (!isDecrementActive) {
        isDecrementActive = true;
      }

      count += 1;
      emit(state + 1);
    });

    on<ServiceCountDecrement>((event, emit) {
      isDecrementActive = state - 1 > 1;
      if (isDecrementActive) {
        count -= 1;
      }

      emit(state - 1);
    });
  }
}
