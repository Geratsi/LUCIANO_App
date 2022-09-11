
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Config.dart';
import '../../../bloc/bookings_schedule/bookings_schedule_bloc.dart';

class AnimatedRefreshIconButton extends StatefulWidget {
  const AnimatedRefreshIconButton({Key? key}) : super(key: key);

  @override
  State<AnimatedRefreshIconButton> createState() => _AnimatedRefreshIconButtonState();
}

class _AnimatedRefreshIconButtonState extends State<AnimatedRefreshIconButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: Config.animDuration * 2), vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BookingsScheduleBloc bookingsScheduleBloc = context.read<BookingsScheduleBloc>();

    return InkResponse(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: Config.animDuration),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Stack(
            children: [
              RotationTransition(
                turns: _animationController,
                child: const Icon(Icons.refresh,),
              ),

              BlocListener<BookingsScheduleBloc, BookingsScheduleState>(
                listener: (context, state) {
                  if (state is BookingsScheduleLoadingState) {
                    _animationController.repeat();
                  } else {
                    _animationController.stop();
                  }
                },
                child: Config.emptyWidget,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        bookingsScheduleBloc.add(const BookingsScheduleUpdateEvent());
      },
    );
  }
}
