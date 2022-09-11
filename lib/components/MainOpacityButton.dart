
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Styles.dart';
import '../Config.dart';
import '../bloc/opacity_button/opacity_button_bloc.dart';

class MainOpacityButton extends StatelessWidget {
  final bool isDisabled;
  final Color? borderColor;
  final Color? shadowColor;
  final Color? backgroundColor;
  final String label;
  final double activeOpacity;
  final double? width;
  final Function onPressed;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;
  final List<TextEditingController>? controllers;

  const MainOpacityButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.padding,
    this.labelStyle,
    this.borderColor,
    this.shadowColor,
    this.controllers,
    this.backgroundColor,
    this.isDisabled = false,
    this.activeOpacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OpacityButtonBloc>(
      create: (context) => OpacityButtonBloc(isDisabled: isDisabled),
      child: _MainOpacityButtonState(
        label: label,
        width: width ?? double.infinity,
        padding: padding ?? const EdgeInsets.all(Config.padding / 1.2),
        onPressed: onPressed,
        isDisabled: isDisabled,
        labelStyle: labelStyle ?? Styles.titleWhiteBoldStyle,
        borderColor: borderColor ?? Config.primaryLightColor,
        shadowColor: shadowColor ?? Config.shadowColor.withOpacity(0.9),
        controllers: controllers,
        activeOpacity: activeOpacity,
        backgroundColor: backgroundColor ?? Config.primaryColor,
      ),
    );
  }
}

class _MainOpacityButtonState extends StatelessWidget {
  final bool isDisabled;
  final Color borderColor;
  final Color shadowColor;
  final Color backgroundColor;
  final String label;
  final double activeOpacity;
  final double width;
  final Function onPressed;
  final TextStyle labelStyle;
  final EdgeInsets padding;
  final List<TextEditingController>? controllers;

  const _MainOpacityButtonState({
    Key? key,
    required this.label,
    required this.width,
    required this.padding,
    required this.onPressed,
    required this.isDisabled,
    required this.labelStyle,
    required this.borderColor,
    required this.shadowColor,
    required this.activeOpacity,
    required this.backgroundColor,
    this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OpacityButtonBloc opacityButtonBloc = context.read<OpacityButtonBloc>();

    if (opacityButtonBloc.isDisabled != isDisabled) {
      opacityButtonBloc.add(OpacityButtonChangeState(isDisabled: isDisabled));
    }

    if (controllers != null) {
      opacityButtonBloc.add(OpacityButtonChangeState(
        isDisabled: controllers!.any((element) => element.text.trim().isEmpty),
      ));
      for (final TextEditingController c in controllers!) {
        c.addListener(() {
          opacityButtonBloc.add(OpacityButtonChangeState(
            isDisabled: controllers!.any((element) => element.text.trim().isEmpty),
          ));
        });
      }
    }

    return SizedBox(
      width: width,
      child: BlocBuilder<OpacityButtonBloc, bool>(
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state,
            child: GestureDetector(
              onTapDown: (tap) {
                opacityButtonBloc.add(const OpacityButtonChangeState(
                  isDisabled: true,
                ));
              },
              onTapUp: (tap) {
                onPressed();
                Timer(const Duration(milliseconds: Config.animDuration), () {
                  opacityButtonBloc.add(const OpacityButtonChangeState(
                    isDisabled: false,
                  ));
                });
              },
              onLongPress: () {
                onPressed();
                opacityButtonBloc.add(const OpacityButtonChangeState(
                  isDisabled: false,
                ));
              },

              child: AnimatedContainer(
                width: double.infinity,
                curve: Curves.easeInOut,
                padding: padding,
                duration: const Duration(milliseconds: Config.animDuration),
                decoration: BoxDecoration(
                  color: state ? backgroundColor.withOpacity(activeOpacity)
                      : backgroundColor,
                  border: Border.all(
                    color: state ? Colors.transparent : borderColor,
                  ),
                  borderRadius: BorderRadius.circular(Config.activityBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: state ? Colors.transparent : shadowColor,
                      offset: const Offset(0, 0), // changes position of shadow
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: AnimatedDefaultTextStyle(
                  child: Text(label),
                  style: state
                      ? Styles.titleStyle
                      : labelStyle,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: Config.animDuration),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
