
import 'package:luciano/Config.dart';
import 'package:flutter/material.dart';

class FloatingActionBubble extends AnimatedWidget {
  const FloatingActionBubble({
    Key? key,
    required this.title,
    required this.items,
    required this.onPress,
    required Animation animation,
    this.backGroundColor,
  })  : super(listenable: animation, key: key);

  final Widget title;
  final List<BubbleMenuItem> items;
  final Function onPress;
  final Color? backGroundColor;

  get _animation => listenable;

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    TextDirection textDirection = Directionality.of(context);

    double animationDirection = textDirection == TextDirection.ltr ? -1 : 1;

    final transform = Matrix4.translationValues(
      animationDirection *
          (screenWidth - _animation.value * screenWidth) *
          ((items.length - index) / 4),
      0.0,
      0.0,
    );

    return Align(
      alignment: textDirection == TextDirection.ltr
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Transform(
        transform: transform,
        child: Opacity(
          opacity: _animation.value,
          child: items[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IgnorePointer(
          ignoring: _animation.value == 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: Config.padding / 4),
            padding: const EdgeInsets.only(bottom: Config.padding / 2),
            itemCount: items.length,
            itemBuilder: buildItem,
          ),
        ),

        FloatingActionButton.extended(
          backgroundColor: backGroundColor ?? Config.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Config.activityBorderRadius),
          ),
          onPressed: () {
            onPress();
          },
          label: title,
        ),
      ],
    );
  }
}

/// Creates a bubble menu for all the items for floating action menu button.
class BubbleMenuItem extends StatelessWidget {
  const BubbleMenuItem({
    Key? key,
    required this.child,
    required this.onPress,
  }) : super(key: key);

  final Widget child;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Config.activityBorderRadius),
      ),
      color: Config.activityHintColor,
      onPressed: onPress,
      child: child,
    );
  }
}
