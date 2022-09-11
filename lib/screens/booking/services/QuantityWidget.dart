import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Service.dart';
import '../../../entity/ProtocolProduct.dart';
import '../../../components/MainTextInput.dart';
import '../../../components/DecrementWidget.dart';
import '../../../components/IncrementWidget.dart';
import '../../../bloc/final_salary_booking/final_salary_bloc.dart';
import '../../../bloc/dismissible_service/dismissible_service_bloc.dart';

class QuantityWidget extends StatelessWidget {
  const QuantityWidget({
    Key? key,
    required this.serviceItem,
    required this.controller,
  }) : super(key: key);

  final Service serviceItem;
  final TextEditingController controller;

  void _onChanged({
    required String newValue, required DismissibleServiceBloc serviceBloc,
    required FinalSalaryBloc salaryBloc,
  }) {
    try {
      if (newValue.isEmpty) {
        controller.text = '1';
        serviceItem.count = 1;
        _changeCostCount(
          count: 1, serviceBloc: serviceBloc,
          event: ChangeServiceCount(newValue: 1),
        );

        salaryBloc.add(UpdateItemCount(service: serviceItem));
      } else {
        final int newQuantity = int.parse(newValue);
        if (newQuantity > 0) {
          serviceItem.count = newQuantity;

          _changeCostCount(
            count: newQuantity, serviceBloc: serviceBloc,
            event: ChangeServiceCount(newValue: newQuantity),
          );

          salaryBloc.add(UpdateItemCount(service: serviceItem));
        }
      }
    } catch (error) {
      log('QuantityWidget._onChanged: $error');
    }
  }

  void _changeCostCount({
    required int count, required DismissibleServiceBloc serviceBloc,
    required DismissibleServiceEvent event,
  }) {
    for (ProtocolProduct element in serviceItem.protocol) {
      element.currentQuantity = element.initialQuantity * count;

      if (element.children.isNotEmpty) {
        final ProtocolProductChild costChild = element.children.first;
        costChild.currentQuantity = costChild.initialQuantity * count;
      }
    }

    serviceBloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    controller.text = '${serviceItem.count}';

    final FinalSalaryBloc salaryBloc = context.read<FinalSalaryBloc>();
    final DismissibleServiceBloc serviceBloc = context.read<
        DismissibleServiceBloc>();

    return Row(
      children: <Widget>[
        Expanded(
          child: Wrap(
            children: const <Widget>[
              Text(
                'Количество предоставленных услуг',
                style: Styles.textTitleColorSmallStyle,
              ),
            ],
          ),
        ),

        const SizedBox(width: Config.padding / 4,),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<DismissibleServiceBloc, int>(
              builder: (context, state) {
                return DecrementWidget(
                  controller: controller,
                  callback: (int newValue) {
                    serviceItem.count = newValue;

                    _changeCostCount(
                      count: newValue, serviceBloc: serviceBloc,
                      event: ServiceCountDecrement(),
                    );

                    salaryBloc.add(UpdateItemCount(service: serviceItem));
                  },
                  isInteger: true,
                  isActive: serviceBloc.isDecrementActive,
                );
              },
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: MainTextInput(
                    hasTrailing: false,
                    textAlign: TextAlign.center,
                    controller: controller,
                    textInputType: TextInputType.number,
                    padding: const EdgeInsets.all(Config.padding / 5),
                    onChanged: (String newValue) {
                      _onChanged(
                        newValue: newValue, serviceBloc: serviceBloc,
                        salaryBloc: salaryBloc,
                      );
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),

            IncrementWidget(
              controller: controller,
              callback: (int newValue) {
                serviceItem.count = newValue;

                _changeCostCount(
                  count: newValue, serviceBloc: serviceBloc,
                  event: ServiceCountIncrement(),
                );

                salaryBloc.add(UpdateItemCount(service: serviceItem));
              },
              isInteger: true,
            ),
          ],
        ),
      ],
    );
  }
}
