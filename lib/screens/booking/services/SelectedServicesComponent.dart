
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'DismissibleService.dart';
import '../../../Config.dart';
import '../../../entity/Service.dart';
import '../../../modelView/ProtocolsFromServer.dart';
import '../../../components/CustomProgressIndicator.dart';
import '../../../bloc/dismissible_service/dismissible_service_bloc.dart';

class SelectedServicesComponent extends StatelessWidget {
  const SelectedServicesComponent({
    Key? key,
    required this.allServices,
    required this.updateParentServices,
  }) : super(key: key);

  final List<Service> allServices;
  final Function(List<Service>) updateParentServices;

  @override
  Widget build(BuildContext context) {
    final Iterable<Service> selectedServices = allServices.where(
      (element) => element.isSelected,
    );

    if (selectedServices.isNotEmpty) {
      return FutureBuilder<Iterable<Service>>(
        future: ProtocolsFromServer.setProtocols(selectedServices, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Config.padding / 2,),
              child: Column(
                children: <Widget>[
                  ...snapshot.data!.map(
                    (item) => BlocProvider<DismissibleServiceBloc>(
                      create: (context) => DismissibleServiceBloc(count: item.count),
                      child: DismissibleService(
                        item: item, updateParentServices: () {
                          int selectedCount = 0;
                          for (final Service element in allServices) {
                            if (element.isSelected) {
                              selectedCount += 1;
                            }
                          }

                          if (selectedCount == 0) {
                            updateParentServices(allServices);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                  top: Config.padding, bottom: Config.padding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomProgressIndicator(),
                ],
              ),
            );
          }
        },
      );
    }

    return const SizedBox(height: Config.padding / 2,);
  }
}
