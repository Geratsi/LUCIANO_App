
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Styles.dart';
import '../Config.dart';
import '../bloc/text_input/text_input_bloc.dart';

class MainTextInput extends StatelessWidget {
  const MainTextInput({
    Key? key,
    required this.controller,
    this.padding,
    this.onSubmit,
    this.textStyle,
    this.focusNode,
    this.onChanged,
    this.iconColor,
    this.borderRadius,
    this.backgroundColor,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.maxLength = 10000,
    this.textAlign = TextAlign.start,
    this.placeholder = '',
    this.hasTrailing = true,
    this.textInputType = TextInputType.text,
    this.capitalization = TextCapitalization.sentences,
    this.textInputAction = TextInputAction.done,
    this.defaultValidation = false,
  }) : super(key: key);

  final int minLines;
  final int maxLength;
  final int? maxLines;
  final bool readOnly;
  final bool hasTrailing;
  final bool defaultValidation;
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
  final TextCapitalization capitalization;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TextInputBloc>(
      create: (context) => TextInputBloc(
        isVisible: controller.text.trim().isNotEmpty,
        currentColor: Config.textColor, errorText: '',
      ),
      child: _MainTextInput(
        padding: padding ?? const EdgeInsets.fromLTRB(
          Config.padding / 1.1, Config.padding / 1.1,
          Config.padding / 3, Config.padding / 1.1,
        ),
        onSubmit: onSubmit ?? () {},
        minLines: minLines,
        maxLines: maxLines,
        readOnly: readOnly,
        textStyle: textStyle ?? Styles.titleStyle,
        iconColor: iconColor ?? Config.primaryDarkColor,
        maxLength: maxLength,
        onChanged: onChanged ?? (val) {},
        textAlign: textAlign,
        focusNode: focusNode ?? FocusNode(),
        controller: controller,
        placeholder: placeholder,
        hasTrailing: hasTrailing,
        borderRadius: borderRadius ?? Config.activityBorderRadius,
        textInputType: textInputType,
        capitalization: capitalization,
        backgroundColor: backgroundColor ?? Config.infoColor,
        inputFormatters: inputFormatters ?? [],
        textInputAction: textInputAction,
        defaultValidation: defaultValidation,
      ),
    );
  }
}

class _MainTextInput extends StatelessWidget {
  const _MainTextInput({
    Key? key,
    required this.padding,
    required this.onSubmit,
    required this.minLines,
    required this.maxLines,
    required this.readOnly,
    required this.iconColor,
    required this.maxLength,
    required this.onChanged,
    required this.textStyle,
    required this.textAlign,
    required this.focusNode,
    required this.controller,
    required this.hasTrailing,
    required this.placeholder,
    required this.borderRadius,
    required this.textInputType,
    required this.capitalization,
    required this.backgroundColor,
    required this.inputFormatters,
    required this.textInputAction,
    required this.defaultValidation,
  }) : super(key: key);

  final int minLines;
  final int maxLength;
  final int? maxLines;
  final bool readOnly;
  final bool hasTrailing;
  final bool defaultValidation;
  final Color iconColor;
  final Color backgroundColor;
  final String placeholder;
  final double borderRadius;
  final Function onSubmit;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final EdgeInsets padding;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function(String) onChanged;
  final TextCapitalization capitalization;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;

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

    controller.addListener(() {
      textInputBloc.add(TextInputVisibleOrNot(
        isVisible: controller.text.trim().isNotEmpty,
      ));
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
              readOnly: readOnly,
              minLines: minLines,
              maxLines: maxLines,
              focusNode: focusNode,
              maxLength: maxLength,
              textAlign: textAlign,
              controller: controller,
              cursorColor: textInputBloc.currentColor,
              cursorWidth: Config.cursorWidth,
              placeholder: placeholder,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              placeholderStyle: TextStyle(
                fontSize: Config.textLargeSize, color: textInputBloc.currentColor,
              ),
              textCapitalization: capitalization,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              onSubmitted: (String? val) {
                focusNode.unfocus();
                onSubmit();
              },
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: textInputBloc.currentColor, width: 1),
                borderRadius: BorderRadius.circular(borderRadius),
              ),

              suffix: textInputBloc.isVisible
                  ? hasTrailing ? IconButton(
                onPressed: () {
                  controller.clear();
                  FocusScope.of(context).requestFocus(focusNode);
                },
                icon: Icon(
                  Icons.cancel, size: Config.iconSize,
                  color: textInputBloc.currentColor,
                ),
              ) : Config.emptyWidget
                  : Config.emptyWidget,
            ),

            errorBlock,
          ],
        );
      },
    );
  }
}
