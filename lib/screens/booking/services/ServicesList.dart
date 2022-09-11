
import 'package:flutter/material.dart';

import 'ServiceComponent.dart';
import '../../../Config.dart';
import '../../../entity/Service.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({
    Key? key,
    required this.onPressed,
    required this.servicesList,
  }) : super(key: key);

  final List<Service> servicesList;
  final Function(Service) onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: Config.padding,),

          ...servicesList.map((service) => ServiceComponent(
            item: service,
            onPressed: () {
              service.refreshCount();

              onPressed(service);
            },
          )),

          const SizedBox(height: Config.padding * 3,),
        ],
    );
  }
}
