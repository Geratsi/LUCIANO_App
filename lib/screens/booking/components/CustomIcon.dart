
import 'package:flutter/material.dart';

import '../../../Config.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    required this.icon,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Config.iconSize,
      height: Config.iconSize,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: Config.iconSize - 3,
              height: Config.iconSize - 3,
              decoration: BoxDecoration(
                color: isActive
                    ? Config.primaryColor : Config.primaryLightColor,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Icon(icon, color: Config.infoColor, size: Config.iconSize),
        ],
      ),
    );
  }
}
