
import 'package:flutter/material.dart';

import 'StatisticRowComponent.dart';
import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Sale.dart';

class SaleExpansionChildComponent extends StatelessWidget {
  const SaleExpansionChildComponent({
    Key? key,
    required this.sale,
  }) : super(key: key);

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Config.infoColor,
        borderRadius: BorderRadius.circular(Config.smallBorderRadius),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Config.padding / 2),
            child: Row(
              children: <Widget>[
                const Text('Процедура', style: Styles.textSmallStyle,),

                const SizedBox(width: Config.padding / 2,),

                Expanded(
                  child: Text(
                    sale.name, style: Styles.textTitleColorSmallStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          StatisticRowComponent(
            label: 'Стоимость за единицу',
            value: '${(sale.salary).round()} ₽',
            labelStyle: Styles.textSmallStyle,
            valueStyle: Styles.textTitleColorSmallStyle,
          ),

          StatisticRowComponent(
            label: 'Количество', value: '${sale.quantity}',
            labelStyle: Styles.textSmallStyle,
            valueStyle: Styles.textTitleColorSmallStyle,
          ),
        ],
      ),
    );
  }
}
