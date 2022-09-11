
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'QuantityWidget.dart';
import 'ServiceExpansionChildComponent.dart';
import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Service.dart';
import '../../../entity/ProtocolProduct.dart';
import '../../../components/CustomDismissible.dart';
import '../../../components/MainExpansionTile.dart';
import '../../../bloc/final_salary_booking/final_salary_bloc.dart';
import '../../../bloc/dismissible_service/dismissible_service_bloc.dart';

class DismissibleService extends StatefulWidget {
  const DismissibleService({
    Key? key,
    required this.item,
    required this.updateParentServices,
  }) : super(key: key);

  final Service item;
  final Function updateParentServices;

  @override
  State<DismissibleService> createState() => _DismissibleServiceState();
}

class _DismissibleServiceState extends State<DismissibleService> {
  final TextEditingController serviceCountController = TextEditingController();
  final List<TextEditingController> _childrenControllers = [];

  late Service serviceItem;

  @override
  void initState() {
    super.initState();

    serviceItem = widget.item;
  }

  @override
  void dispose() {
    if (mounted) {
      serviceCountController.dispose();
      for (var element in _childrenControllers) {element.dispose();}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FinalSalaryBloc salaryBloc = context.read<FinalSalaryBloc>();

    return CustomDismissible(
      key: ValueKey<int>(serviceItem.id),
      onDismissed: (DismissDirection direction) {
        serviceItem.isSelected = false;
        salaryBloc.add(RemoveItem(service: serviceItem));
        widget.updateParentServices();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: Config.padding / 2),
        child: MainExpansionTile(
          title: Text(serviceItem.label, style: Styles.textStyle,),
          childrenHorizontalPadding: 0,
          childrenWidgets: serviceItem.protocol.map((costItem) {
            List<TextEditingController> childrenControllers = [];
            final List<ProtocolProductChild> children = costItem.children;
            final TextEditingController controller = TextEditingController();
            if (children.isNotEmpty) {
              childrenControllers = List<TextEditingController>.generate(
                children.length, (index) => TextEditingController(),
              );
              _childrenControllers.add(controller);
              _childrenControllers.addAll(childrenControllers);
            }
            return BlocBuilder<DismissibleServiceBloc, int>(
              builder: (context, state) {
                if (children.isNotEmpty) {
                  return MainExpansionTile(
                    mainPadding: Config.padding / 2,
                    borderColor: Config.textColorOnPrimary,
                    borderRadius: Config.activityBorderRadius / 2,
                    mainBackgroundColor: Config.textColorOnPrimary,
                    childrenBackgroundColor: Config.textColorOnPrimary,
                    title: RichText(
                      text: TextSpan(
                        text: costItem.name,
                        style: Styles.textSmallStyle,
                        children: <TextSpan>[
                          TextSpan(text: ' (${costItem.unit})', style: Styles.textSmallBoldStyle,),
                        ],
                      ),
                    ),
                    childrenWidgets: children.asMap()
                        .entries.map((entry) => ServiceExpansionChildComponent(
                      controller: childrenControllers[entry.key],
                      costItem: entry.value,
                    ),).toList(),
                  );
                } else {
                  return ServiceExpansionChildComponent(
                    costItem: costItem,
                    controller: controller,
                    horizontalPadding: Config.padding / 2,
                  );
                }
              },
            );
          },).toList(),
          quantityWidget: QuantityWidget(
            serviceItem: serviceItem,
            controller: serviceCountController,
          ),
          priceWidget: Padding(
            padding: const EdgeInsets.only(bottom: Config.padding / 2),
            child: BlocBuilder<DismissibleServiceBloc, int>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(serviceItem.count > 1 ? 'Стоимость услуг' : 'Стоимость услуги',
                      style: Styles.textTitleColorSmallStyle,),

                    Text('${serviceItem.getPriceInString()} ₽',
                      style: Styles.textTitleColorSmallStyle,),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      background: const _BackgroundWidget(),
    );
  }
}

class _BackgroundWidget extends StatelessWidget {
  const _BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, Config.padding / 2 + 1, 1, 1),
      child: Container(
        decoration: BoxDecoration(
          color: Config.errorColor,
          borderRadius: BorderRadius.circular(
            Config.activityBorderRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Config.padding),
              child: Icon(
                Icons.delete, size: Config.iconSize,
                color: Config.textColorOnPrimary,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Config.padding),
              child: Icon(
                Icons.delete, size: Config.iconSize,
                color: Config.textColorOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

