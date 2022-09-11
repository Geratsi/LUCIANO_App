
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../bloc/final_salary_booking/final_salary_bloc.dart';

class FinalSalaryComponent extends StatelessWidget {
  const FinalSalaryComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FinalSalaryBloc salaryBloc = context.read<FinalSalaryBloc>();
    return BlocBuilder<FinalSalaryBloc, int>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            Config.padding / 4, 0, Config.padding / 4, Config.padding,
          ),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Стоимость приема:',
                  style: Styles.titleBoldStyle,
                ),
              ),
              Text(
                '${salaryBloc.finalSalary} ${Config.currency}',
                style: Styles.titleBoldStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
