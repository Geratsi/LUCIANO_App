
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../entity/Service.dart';

part 'services_control_event.dart';
part 'services_control_state.dart';

class ServicesControlBloc extends Bloc<ServicesControlEvent, ServicesControlState> {
  List<Service> allServices = [];

  ServicesControlBloc() : super(ServicesControlInitial()) {
    on<LoadServiceCounter>((event, emit) async {
      // final Map<String, dynamic> data = await ServicesFromServer.getServices();
      // if (data['error'] == null) {
      //   allServices = data['data'];
      //   emit(ServiceControlLoaded(loadedServices: data['data']));
      // } else {
      //   emit(ServiceControlLoadingError(error: data['error']));
      // }
    });

    on<ReloadServiceCounter>((event, emit) async {
      // final Map<String, dynamic> data = await ServicesFromServer.getServices();
      // if (data['error'] == null) {
      //   allServices = data['data'];
      //   emit(ServiceControlLoaded(loadedServices: data['data']));
      // } else {
      //   emit(ServiceControlLoadingError(error: data['error']));
      // }
    });

    on<ChangeServiceState>((event, emit) {
      if (state is ServiceControlLoaded) {
        final state = this.state as ServiceControlLoaded;
        event.service.isSelected = !event.service.isSelected;
        emit(ServiceControlLoaded(loadedServices: List.from(state.loadedServices)));
      }
    });
  }
}
