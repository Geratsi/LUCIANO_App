
import 'dart:ui';

import 'package:flutter/material.dart';

import '../Config.dart';
import 'CustomProgressIndicator.dart';

class ModalProgress {
  final BuildContext _context;

  void show({bool glass = false}) {
    showDialog(
      context: _context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (ctx) => glass ? const FullGlassScreen() : const FullScreenLoader(),
    );
  }

  void hide() {
    Navigator.of(_context).pop();
  }

  ModalProgress._create(this._context);

  factory ModalProgress.of(BuildContext context) {
    return ModalProgress._create(context);
  }
}

class FullGlassScreen extends StatelessWidget {
  const FullGlassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.5),
              borderRadius: BorderRadius.circular(Config.activityBorderRadius),
            ),
            child: const Center(
              child: CustomProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
