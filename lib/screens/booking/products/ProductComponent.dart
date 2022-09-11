
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/CustomIcon.dart';
import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Product.dart';
import '../../../components/TouchableOpacityEffect.dart';
import '../../../bloc/final_salary_booking/final_salary_bloc.dart';

class ProductComponent extends StatefulWidget {
  const ProductComponent({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Product item;

  @override
  State<ProductComponent> createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  late Product _item;

  @override
  void initState() {
    super.initState();

    _item = widget.item;
  }

  @override
  void didUpdateWidget(covariant ProductComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    _item = widget.item;
  }

  Widget _buildRemoveIcon(FinalSalaryBloc? salaryBloc) {
    return TouchableOpacityEffect(
      onPressed: () {
        if (_item.count > 1) {
          if (salaryBloc != null) {
            salaryBloc.add(UpdateItemCount(product: _item));
          }
          setState(() {
            _item.count -= 1;
          });
        }
      },
      child: const CustomIcon(icon: Icons.remove_circle, isActive: true,),
    );
  }

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
    return Container(
      decoration: BoxDecoration(
        color: Config.infoColor,
        border: Border.all(color: Config.activityHintColor),
        borderRadius: BorderRadius.circular(Config.activityBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Config.padding),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(_item.label, style: Styles.textTitleColorStyle,),
                ),

                const SizedBox(width: Config.padding / 2,),

                Row(
                  children: <Widget>[
                    _buildRemoveIcon(_getBloc(context)),

                    const SizedBox(width: Config.padding / 2,),

                    Text('${_item.count}', style: Styles.textTitleColorStyle,)
                  ],
                ),
              ],
            ),

            const SizedBox(height: Config.padding / 2,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Цена: ${_item.priceInString} ${Config.currency}',
                  style: Styles.textStyle,
                ),

                Text(
                  'Еще доступно: ${_item.quantity - _item.count} шт.',
                  style: Styles.textStyle,
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
