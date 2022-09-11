
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Config.dart';
import '../Styles.dart';
import '../bloc/text_input/text_input_bloc.dart';

class MainTextInputSecure extends StatelessWidget {
  const MainTextInputSecure({
    Key? key,
    required this.controller,
    this.padding,
    this.isSecure,
    this.onSubmit,
    this.textStyle,
    this.focusNode,
    this.onChanged,
    this.iconColor,
    this.borderRadius,
    this.backgroundColor,
    this.maxLength = 10000,
    this.textAlign = TextAlign.start,
    this.placeholder = '',
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.defaultValidation = false,
  }) : super(key: key);

  final int maxLength;
  final bool defaultValidation;
  final bool? isSecure;
  final Color? iconColor;
  final Color? backgroundColor;
  final String placeholder;
  final double? borderRadius;
  final Function? onSubmit;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TextInputBloc>(
      create: (context) => TextInputBloc(
        isVisible: isSecure != null ? !isSecure! : false,
        currentColor: Config.textColor, errorText: '',
      ),
      child: _MainTextInputSecure(
        padding: padding ?? const EdgeInsets.fromLTRB(
          Config.padding / 1.1, Config.padding / 1.1,
          Config.padding / 3, Config.padding / 1.1,
        ),
        onSubmit: onSubmit ?? () {},
        textStyle: textStyle ?? Styles.titleStyle,
        onChanged: onChanged ?? (_) {},
        iconColor: iconColor ?? Config.primaryDarkColor,
        focusNode: focusNode ?? FocusNode(),
        maxLength: maxLength,
        textAlign: textAlign,
        controller: controller,
        placeholder: placeholder,
        borderRadius: borderRadius ?? Config.activityBorderRadius,
        textInputType: textInputType,
        backgroundColor: backgroundColor ?? Config.infoColor,
        textInputAction: textInputAction,
        defaultValidation: defaultValidation,
      ),
    );
  }
}

class _MainTextInputSecure extends StatelessWidget {
  const _MainTextInputSecure({
    Key? key,
    required this.padding,
    required this.onSubmit,
    required this.onChanged,
    required this.iconColor,
    required this.textStyle,
    required this.focusNode,
    required this.maxLength,
    required this.textAlign,
    required this.controller,
    required this.placeholder,
    required this.borderRadius,
    required this.textInputType,
    required this.backgroundColor,
    required this.textInputAction,
    required this.defaultValidation,
  }) : super(key: key);

  final int maxLength;
  final bool defaultValidation;
  final Color iconColor;
  final Color backgroundColor;
  final String placeholder;
  final double borderRadius;
  final Function onSubmit;
  final FocusNode focusNode;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function(String) onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final TextInputBloc textInputBloc = context.read<TextInputBloc>();

    focusNode.addListener(() {
      if (focusNode.hasPrimaryFocus) {
        textInputBloc.add(TextInputChangeCurrentState(
          newColor: Config.primaryDarkColor, newErrorText: '',
        ));
      } else {
        if (defaultValidation) {
          if (controller.text.trim().isEmpty) {
            textInputBloc.add(TextInputChangeCurrentState(
              newColor: Config.errorColor, newErrorText: 'Пустое значение поля',
            ));
          } else {
            textInputBloc.add(TextInputChangeCurrentState(
              newColor: Config.textColor, newErrorText: '',
            ));
          }
        } else {
          textInputBloc.add(TextInputChangeCurrentState(
            newColor: Config.textColor, newErrorText: '',
          ));
        }
      }
    });

    return BlocBuilder<TextInputBloc, TextInputState>(
      builder: (context, state) {
        Widget errorBlock = Config.emptyWidget;
        if (defaultValidation) {
          errorBlock = Padding(
            padding: const EdgeInsets.symmetric(horizontal: Config.padding),
            child: Text(
              textInputBloc.errorText,
              style: TextStyle(
                fontSize: Config.textSmallSize, color: Config.errorColor,
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CupertinoTextField(
              style: textStyle,
              padding: padding,
              focusNode: focusNode,
              textAlign: textAlign,
              maxLength: maxLength,
              controller: controller,
              obscureText: !textInputBloc.isVisible,
              cursorColor: textInputBloc.currentColor,
              cursorWidth: Config.cursorWidth,
              placeholder: placeholder,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              placeholderStyle: TextStyle(
                fontSize: Config.textLargeSize, color: textInputBloc.currentColor,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: textInputBloc.currentColor, width: 1),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              onSubmitted: (String? val) {
                focusNode.unfocus();
                onSubmit();
              },
              suffix: IconButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  textInputBloc.add(TextInputVisibleOrNot(
                    isVisible: !textInputBloc.isVisible,
                  ));
                },
                icon: Icon(
                  textInputBloc.isVisible ? Icons.visibility : Icons.visibility_off,
                  size: Config.iconSize,
                  color: textInputBloc.currentColor,
                ),
              ),
            ),

            errorBlock,
          ],
        );
      },
    );
  }
}
