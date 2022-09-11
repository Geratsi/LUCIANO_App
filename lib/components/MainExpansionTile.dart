
import 'package:flutter/material.dart';

import '../Config.dart';
import 'TouchableOpacityEffect.dart';

class MainExpansionTile extends StatefulWidget {
  const MainExpansionTile({
    Key? key,
    required this.title,
    required this.childrenWidgets,
    this.textColor,
    this.iconColor,
    this.mainPadding,
    this.priceWidget,
    this.borderColor,
    this.borderRadius,
    this.quantityWidget,
    this.childrenPadding,
    this.expandedAlignment,
    this.onExpansionChanged,
    this.collapsedTextColor,
    this.collapsedIconColor,
    this.mainBackgroundColor,
    this.childrenBackgroundColor,
    this.collapsedBackgroundColor,
    this.expandedCrossAxisAlignment,
    this.borderWidth = 0,
    this.maintainState = false,
    this.initiallyExpanded = false,
    this.childrenHorizontalPadding = Config.padding / 2,
  }) : assert(
        expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
        'CrossAxisAlignment.baseline is not supported since the expanded children '
            'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  final bool maintainState;
  final bool initiallyExpanded;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? collapsedIconColor;
  final Color? collapsedTextColor;
  final Color? mainBackgroundColor;
  final Color? childrenBackgroundColor;
  final Color? collapsedBackgroundColor;
  final Widget title;
  final double borderWidth;
  final double childrenHorizontalPadding;
  final double? mainPadding;
  final Widget? priceWidget;
  final double? borderRadius;
  final Widget? quantityWidget;
  final Alignment? expandedAlignment;
  final List<Widget> childrenWidgets;
  final EdgeInsetsGeometry? childrenPadding;
  final ValueChanged<bool>? onExpansionChanged;
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  @override
  State<MainExpansionTile> createState() => _MainExpansionTileState();
}

class _MainExpansionTileState extends State<MainExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);

  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late Animation<double> _iconTurns;
  late List<Widget> _childrenWidgets;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _childrenWidgets = widget.childrenWidgets;
    _controller = AnimationController(duration:  const Duration(milliseconds: Config.animDuration), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MainExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    _childrenWidgets = widget.childrenWidgets;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? theme.textTheme.subtitle1!.color
      ..end = widget.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.mainBackgroundColor ?? Config.infoColor;
    super.didChangeDependencies();
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        widget.borderRadius ?? Config.activityBorderRadius,),
      child: Container(
        decoration: BoxDecoration(
          color: widget.mainBackgroundColor ?? Config.infoColor,
          border: Border.all(
            color: widget.borderColor ?? Config.activityHintColor,
            width: widget.borderWidth,
          ),
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? Config.activityBorderRadius,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TouchableOpacityEffect(
              child: Container(
                decoration: BoxDecoration(
                  color: _backgroundColor.value ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? Config.activityBorderRadius,
                  ),
                ),
                padding: EdgeInsets.all(widget.mainPadding ?? Config.padding),
                child: Row(
                  children: <Widget>[
                    Expanded(child: widget.title,),

                    RotationTransition(
                      turns: _iconTurns,
                      child: const Icon(
                        Icons.arrow_drop_down, color: Config.textTitleColor,
                        size: Config.iconSize,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: _handleTap,
            ),

            ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  widget.borderRadius != null ? widget.borderRadius! - 2 : Config.activityBorderRadius - 2,
                ),
              ),
              child: Align(
                alignment: widget.expandedAlignment ?? Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> childrenWidgets = [..._childrenWidgets];
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    List<Widget> children = [];
    if (widget.quantityWidget != null) {
      children.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Config.padding / 2 - widget.childrenHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.quantityWidget!,
            const Divider(color: Config.textColor),
          ],
        ),
      ));
    }
    if (childrenWidgets.isNotEmpty) {
      final Widget lastItem = childrenWidgets.removeLast();
      for (Widget widget in childrenWidgets) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: Config.padding / 2),
          child: widget,
        ));
      }
      if (widget.priceWidget != null) {
        children.add(lastItem);
      } else {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: Config.padding / 2),
          child: lastItem,
        ));
      }
    }
    if (widget.priceWidget != null) {
      if (_childrenWidgets.isNotEmpty) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Config.padding / 2 - widget.childrenHorizontalPadding,
          ),
          child: const Divider(color: Config.textColor,),
        ));
      }
      children.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Config.padding / 2 - widget.childrenHorizontalPadding,
        ),
        child: widget.priceWidget!,
      ));
    }

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: children.isNotEmpty ? Container(
          color: widget.childrenBackgroundColor ?? Config.activityHintColor.withOpacity(.5),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              widget.childrenHorizontalPadding,
              Config.padding / 2,
              widget.childrenHorizontalPadding,
              0,
            ),
            child: Column(
              crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ) : const SizedBox(),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
