
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'BonusScreen.dart';
import 'FinesScreen.dart';
import 'GoodsSoldScreen.dart';
import 'ServicesProvidedScreen.dart';
import 'components/WaitingComponent.dart';
import 'components/StatisticRowComponent.dart';
import '../../Config.dart';
import '../../Styles.dart';
import '../../entity/Sale.dart';
import '../../entity/Person.dart';
import '../../entity/ServicesStatistic.dart';
import '../../utilities/DateTimeFormat.dart';
import '../../components/ErrorComponent.dart';
import '../../components/TouchableOpacityEffect.dart';
import '../../bloc/sale_history/sale_history_bloc.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({
    Key? key,
    required this.personInfo,
    this.initialData
  }) : super(key: key);

  final Person personInfo;
  final ServicesStatistic? initialData;

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final DateTime _initialDate = DateTime.now().toLocal();

  late DateTimeFormat _formatter;

  DateTime? _selectedDate;
  Iterable<Sale>? _groupedServices;

  void _pickMonth(SaleHistoryBloc saleHistoryBloc) {
    showMonthPicker(
      context: context,
      firstDate: DateTime(_initialDate.year - 1, 5),
      lastDate: _initialDate,
      initialDate: _selectedDate ?? _initialDate,
    ).then((value) {
      if (value != null) {
        _selectedDate = value;
        _groupedServices = null;
        saleHistoryBloc.add(SaleHistoryGetEvent(
          id: widget.personInfo.id,
          from: DateTime(value.year, value.month, 1).toString(),
          till: DateTime(value.year, value.month + 1, 1).toString(),
        ));
      }
    });
  }

  Widget _buildContent(ServicesStatistic? statistic) {
    if (statistic != null) {
      _groupedServices = statistic.groupedServices;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${statistic != null ? statistic.salary.round() : '0'} ₽',
          style: Styles.titleBoldStyle,
        ),

        Text(
          '${statistic != null ? statistic.count : '0'} шт.',
          style: Styles.textStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ErrorComponent errorComponent = ErrorComponent(context: context);
    final SaleHistoryBloc saleHistoryBloc = context.read<SaleHistoryBloc>();
    _formatter = DateTimeFormat(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        flexibleSpace: Config.flexibleGradientSpace,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Config.padding),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Статистика за ', style: Styles.titleStyle,),

                  TouchableOpacityEffect(
                    onPressed: () {
                      _pickMonth(saleHistoryBloc);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Config.infoColor,
                        borderRadius: BorderRadius.circular(Config.smallBorderRadius),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Config.padding / 2),
                      child: BlocBuilder<SaleHistoryBloc, SaleHistoryState>(
                        builder: (context, state) {
                          return Text(
                            _formatter.getDateTimeString(_selectedDate ?? _initialDate, 'MMMM'),
                            style: Styles.titleBoldStyle,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BonusScreen(),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Config.infoColor,
                    borderRadius: BorderRadius.circular(Config.activityBorderRadius),
                  ),
                  child: const StatisticRowComponent(label: 'Премия', value: '0 ₽',),
                ),
              ),

              const SizedBox(height: Config.padding / 2,),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FinesScreen(),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Config.infoColor,
                    borderRadius: BorderRadius.circular(Config.activityBorderRadius),
                  ),
                  child: const StatisticRowComponent(label: 'Штрафы', value: '0 ₽',),
                ),
              ),

              const Divider(),

              const StatisticRowComponent(label: 'План на месяц', value: '0 ₽'),

              const SizedBox(height: Config.padding / 3,),

              const StatisticRowComponent(label: 'Выполнено', value: '0 ₽'),

              const SizedBox(height: Config.padding / 3,),

              const StatisticRowComponent(label: 'Осталось выполнить', value: '0 ₽'),

              const Divider(),

              GestureDetector(
                onTap: () {
                  if (_groupedServices != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ServicesProvidedScreen(
                        groupedServices: _groupedServices!.toList(),
                      ),
                    ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Config.infoColor,
                    borderRadius: BorderRadius.circular(Config.activityBorderRadius),
                  ),
                  child: StatisticRowComponent(
                    label: 'Оказано услуг', value: '',
                    valueWidget: BlocBuilder<SaleHistoryBloc, SaleHistoryState>(
                      builder: (context, state) {
                        if (state is SaleHistoryLoadingState) {
                          return const WaitingComponent(height: 45);
                        } else if (state is SaleHistoryLoadedState) {
                          return _buildContent(state.servicesStatistic);
                        } else if (state is SaleHistoryErrorState) {
                          errorComponent.show(state.error);
                        }

                        return _buildContent(null);
                      },
                    ),
                  )
                ),
              ),

              const SizedBox(height: Config.padding / 2,),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GoodsSoldScreen(),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Config.infoColor,
                    borderRadius: BorderRadius.circular(Config.activityBorderRadius),
                  ),
                  child: const StatisticRowComponent(
                    label: 'Продано товаров', value: '0 ₽', add: '0 шт.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
