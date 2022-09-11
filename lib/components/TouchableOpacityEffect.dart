
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Config.dart';
import '../bloc/touchable_opacity/touchable_opacity_bloc.dart';

class TouchableOpacityEffect extends StatelessWidget {
  const TouchableOpacityEffect({
    Key? key,
    required this.child,
    required this.onPressed,
    this.onLongPressed,
    this.setTapPosition,
    this.pressedOpacity = 0.5,
  }) : super(key: key);

  final Widget child;
  final double pressedOpacity;
  final Function onPressed;
  final Function? onLongPressed;
  final Function(Offset)? setTapPosition;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TouchableOpacityBloc(opacity: 1.0),
      child: _TouchableOpacityEffectState(
        child: child,
        onPressed: onPressed,
        onLongPressed: onLongPressed,
        pressedOpacity: pressedOpacity,
        setTapPosition: setTapPosition ?? (offset) {},
      ),
    );
  }
}

class _TouchableOpacityEffectState extends StatelessWidget {
  final Widget child;
  final double pressedOpacity;
  final Function onPressed;
  final Function? onLongPressed;
  final Function(Offset) setTapPosition;

  const _TouchableOpacityEffectState({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.pressedOpacity,
    required this.setTapPosition,
    this.onLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TouchableOpacityBloc touchableOpacityBloc = context.read<TouchableOpacityBloc>();

    return GestureDetector(
      onTapDown: (details) {
        touchableOpacityBloc.add(TouchableOpacityChangeState(opacity: pressedOpacity));
        setTapPosition(details.globalPosition);
      },

      onTapUp: (tap) {
        onPressed();
        touchableOpacityBloc.add(const TouchableOpacityChangeState(opacity: 1.0));
      },

      onLongPress: () {
        if (onLongPressed != null) {
          onLongPressed!();
        } else {
          onPressed();
        }
        touchableOpacityBloc.add(const TouchableOpacityChangeState(opacity: 1.0));
      },
      child: BlocBuilder<TouchableOpacityBloc, int>(
        builder: (context, state) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: Config.animDuration),
            opacity: touchableOpacityBloc.opacity,
            child: child,
          );
        },
      ),
    );
  }
}
