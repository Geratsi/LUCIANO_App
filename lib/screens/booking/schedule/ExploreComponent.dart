
import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';

class ExploreComponent extends StatelessWidget {
  const ExploreComponent({
    Key? key,
    required this.name,
    required this.source,
    required this.child,
  }) : super(key: key);

  final String name;
  final String source;
  final Widget child;
  final double buttonHeight = 150;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => child),
        );
      },
      subtitle: Container(
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Config.activityBorderRadius),
          color: Config.primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(name, style: Styles.titleStyle),
          ],
        ),
        padding: const EdgeInsets.only(bottom: Config.padding),
      ),
    );
  }
}