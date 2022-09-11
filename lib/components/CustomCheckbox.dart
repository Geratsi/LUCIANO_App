
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'TouchableOpacityEffect.dart';
import '../Styles.dart';
import '../Config.dart';
import '../bloc/checkbox/checkbox_bloc.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
    this.updater,
    this.labelStyle,
  }) : super(key: key);

  final bool isChecked;
  final String label;
  final TextStyle? labelStyle;
  final Function(bool) onChanged;
  final Future<bool?> Function()? updater;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckboxBloc(isChecked: isChecked),
      child: _CustomCheckbox(
        label: label,
        updater: updater ?? () async => null,
        isChecked: isChecked,
        onChanged: onChanged,
        labelStyle: labelStyle ?? Styles.textWhiteStyle,
      ),
    );
  }
}

class _CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final String label;
  final TextStyle labelStyle;
  final Function(bool) onChanged;
  final Future<bool?> Function() updater;

  const _CustomCheckbox({
    Key? key,
    required this.label,
    required this.updater,
    required this.isChecked,
    required this.onChanged,
    required this.labelStyle,
  }) : super(key: key);

  Future<void> _updateValue(CheckboxBloc checkboxBloc) async {
    final bool? newValue = await updater();
    if (newValue != null) {
      checkboxBloc.add(CheckboxChangeState(isChecked: newValue));
      onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CheckboxBloc checkboxBloc = context.read<CheckboxBloc>();
    _updateValue(checkboxBloc);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlocBuilder<CheckboxBloc, CheckboxState>(
          builder: (context, state) {
            return Checkbox(
              value: checkboxBloc.isChecked,
              onChanged: (bool? val) {
                if (val != null) {
                  checkboxBloc.add(CheckboxChangeState(isChecked: val));
                  onChanged(val);
                }
              },
              checkColor: Config.primaryLightColor,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Config.smallBorderRadius - 8),
              ),
              side: const BorderSide(color: Config.textColorOnPrimary, width: 2,),
            );
          },
        ),

        TouchableOpacityEffect(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Config.padding / 1.4, bottom: Config.padding / 1.5,
            ),
            child: Text(label, style: labelStyle,),
          ),
          onPressed: () {
            final bool _isChecked = checkboxBloc.isChecked;
            checkboxBloc.add(CheckboxChangeState(isChecked: !_isChecked));
            onChanged(!_isChecked);
          },
        ),
      ],
    );
  }
}
