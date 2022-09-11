
import 'package:flutter/material.dart';

import 'components/SaleExpansionChildComponent.dart';
import '../../Config.dart';
import '../../Styles.dart';
import '../../entity/Sale.dart';
import '../../utilities/DateTimeFormat.dart';
import '../../components/MainExpansionTile.dart';

class ServicesProvidedScreen extends StatelessWidget {
  const ServicesProvidedScreen({
    Key? key,
    required this.groupedServices,
  }) : super(key: key);

  final List<dynamic> groupedServices;

  @override
  Widget build(BuildContext context) {
    final DateTimeFormat formatter = DateTimeFormat(
      Localizations.localeOf(context).languageCode,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оказанные услуги'),
        flexibleSpace: Config.flexibleGradientSpace,
      ),

      body: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(Config.padding),
        itemCount: groupedServices.length,
        itemBuilder: (context, index) {
          double sum = 0;
          List<Widget> children = [];
          final Map<String, dynamic> item = groupedServices[index];
          for (Sale sale in item['items']) {
            sum += sale.quantity * sale.salary;
            children.add(SaleExpansionChildComponent(sale: sale));
          }

          return MainExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formatter.getDateTimeString(item['date'], 'dd MMMM y г.'),
                  style: Styles.textStyle,
                ),

                Padding(
                  padding: const EdgeInsets.only(right: Config.padding),
                  child: Text('${sum.round()} ₽', style: Styles.textTitleColorStyle,),
                ),
              ],
            ),
            childrenWidgets: children,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: Config.padding,),
      ),
    );
  }
}
