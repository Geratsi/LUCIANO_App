
import 'package:flutter/material.dart';

import '../../../Config.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    Key? key,
    required this.imageProvider,
    this.child,
  }) : super(key: key);

  final Widget? child;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Config.avatarSize * 2,
      height: Config.avatarSize * 2,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: Config.avatarSize * 2,
              height: Config.avatarSize * 2,
              decoration: const BoxDecoration(
                color: Config.primaryLightColor, shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image(
                image: imageProvider, width: Config.avatarSize * 2 - 5,
                height: Config.avatarSize * 2 - 5, fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: child ?? const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
