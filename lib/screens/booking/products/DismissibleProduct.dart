
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ProductComponent.dart';
import '../../../Config.dart';
import '../../../entity/Product.dart';
import '../../../components/CustomDismissible.dart';
import '../../../bloc/final_salary_booking/final_salary_bloc.dart';

class DismissibleProduct extends StatelessWidget {
  const DismissibleProduct({
    Key? key,
    required this.product,
    required this.onDismissed,
  }) : super(key: key);

  final Product product;
  final Function onDismissed;

  FinalSalaryBloc? _getBloc(BuildContext context) {
    try {
      final FinalSalaryBloc salaryBloc = context.read<FinalSalaryBloc>();
      return salaryBloc;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final FinalSalaryBloc? salaryBloc = _getBloc(context);

    return CustomDismissible(
      key: ValueKey<int>(product.id),
      onDismissed: (DismissDirection direction) {
        if (salaryBloc != null) {
          salaryBloc.add(RemoveItem(product: product));
        }

        onDismissed();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: Config.padding / 2),
        child: ProductComponent(item: product,),
      ),
      background: Padding(
        padding: const EdgeInsets.fromLTRB(1, Config.padding / 2 + 1, 1, 1),
        child: Container(
          decoration: BoxDecoration(
            color: Config.errorColor,
            borderRadius: BorderRadius.circular(Config.activityBorderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Config.padding),
                child: Icon(Icons.delete, size: Config.iconSize, color: Config.textColorOnPrimary,),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Config.padding),
                child: Icon(Icons.delete, size: Config.iconSize, color: Config.textColorOnPrimary,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
