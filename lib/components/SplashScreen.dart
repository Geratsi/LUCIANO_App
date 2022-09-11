
import 'package:luciano/Config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2), vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    if(mounted) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.activityBackColor,

      body: Center(
        // child: ScaleTransition(
        //   scale: _animation,
        //   child: Padding(
        //     padding: EdgeInsets.all(Config.padding),
        //     child: Image.asset('assets/images/gold.png',),
        //   ),
        // ),

        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.all(Config.padding),
            child: Image.asset('assets/images/gold.png',),
          ),
        ),
      ),
    );
  }
}
