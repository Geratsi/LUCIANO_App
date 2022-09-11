
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../Config.dart';

class BookingsScheduleAvatar extends StatefulWidget {
  const BookingsScheduleAvatar({
    Key? key,
    required this.imageBytes,
    required this.navigateToProfile,
  }) : super(key: key);

  final Function navigateToProfile;
  final Uint8List imageBytes;

  @override
  State<BookingsScheduleAvatar> createState() => _BookingsScheduleAvatarState();
}

class _BookingsScheduleAvatarState extends State<BookingsScheduleAvatar> {
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();

    _imageBytes = widget.imageBytes;
  }

  @override
  void didUpdateWidget(covariant BookingsScheduleAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _imageBytes = widget.imageBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Config.padding - 6),
      child: GestureDetector(
        onTap: () {
          widget.navigateToProfile();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                width: Config.iconSize * 1.5,
                height: Config.iconSize * 1.5,
                decoration: const BoxDecoration(
                  color: Config.activityBackColor, shape: BoxShape.circle,
                ),
              ),
            ),

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image(
                  image: MemoryImage(_imageBytes),
                  width: Config.iconSize * 1.5 - 3,
                  height: Config.iconSize * 1.5 - 3, fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
