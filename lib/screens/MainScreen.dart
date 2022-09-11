
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'stats/StatisticScreen.dart';
import 'profile/ProfileScreen.dart';
import 'booking/BookingsScheduleScreen.dart';
import '../Api.dart';
import '../entity/Booking.dart';
import '../entity/AppointmentDataSource.dart';
import '../repository/bookings_repository.dart';
import '../bloc/main_screen/main_screen_bloc.dart';
import '../repository/sale_history_repository.dart';
import '../bloc/sale_history/sale_history_bloc.dart';
import '../bloc/profile_change/profile_change_bloc.dart';
import '../bloc/bookings_schedule/bookings_schedule_bloc.dart';
import '../../Config.dart';
import '../../entity/Person.dart';
import '../../entity/BottomMenuItem.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.personInfo,
  }) : super(key: key);

  final Person personInfo;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DateTime _now = DateTime.now().toLocal();
  final PageController _pageController = PageController();
  final BookingsRepository _bookingsRepository = BookingsRepository();
  final SaleHistoryRepository _saleHistoryRepository = SaleHistoryRepository();
  final AppointmentDataSource _appointmentDataSource = AppointmentDataSource(
    source: <Booking>[],
  );

  late Person _personInfo;
  late List<BottomMenuItem> _bottomMenuItems;

  @override
  void initState() {
    super.initState();

    _personInfo = widget.personInfo;
    _bottomMenuItems = Api.getBottomMenuItems();
  }

  void _onItemTapped(int index, MainScreenBloc mainScreenBloc) {
    _pageController.animateToPage(
      index, duration: const Duration(milliseconds: Config.animDuration),
      curve: Curves.easeInOut,
    );
    mainScreenBloc.add(MainScreenChangeScreen(index: index));
  }

  Image _getImage(String path) {
    return Image.asset(
      path, key: ValueKey(Random().nextInt(100)), width: Config.iconSize,
      height: Config.iconSize,
    );
  }

  List<Widget> _buildChildren(MainScreenBloc mainScreenBloc) {
    List<Widget> children = [];
    for (int index = 0; index < _bottomMenuItems.length; index++) {
      if (index == 0) {
        children.add(BookingsScheduleScreen(
          personInfo: _personInfo,
          navigateToProfile: () {
            _onItemTapped(2, mainScreenBloc);
          },
          appointmentDataSource: _appointmentDataSource,
        ));
      }
      else if (index == 1) {
        children.add(StatisticScreen(personInfo: _personInfo,),);
      } else {
        children.add(
          BlocProvider<ProfileChangeBloc>(
            create: (context) => ProfileChangeBloc(),
            child: ProfileScreen(personInfo: _personInfo,),
          ),
        );
      }
    }

    return children;
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainScreenBloc mainScreenBloc = context.read<MainScreenBloc>();
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<BookingsScheduleBloc>(
            create: (context) => BookingsScheduleBloc(
              bookingsRepository: _bookingsRepository,
              appointmentDataSource: _appointmentDataSource,
            )..add(BookingsScheduleInitializeEvent()),
          ),

          BlocProvider<SaleHistoryBloc>(
            create: (context) => SaleHistoryBloc(
              saleHistoryRepository: _saleHistoryRepository,
            )..add(SaleHistoryGetEvent(
              id: _personInfo.id,
              from: DateTime(_now.year, _now.month, 1).toString(),
              till: DateTime(_now.year, _now.month + 1, 1).toString(),
            )),
          ),
        ],
        child: PageView(
          children: _buildChildren(mainScreenBloc),
          controller: _pageController,
          onPageChanged: (index) {
            mainScreenBloc.add(MainScreenChangeScreen(index: index));
          },
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Config.textColor),),
        ),
        child: BlocBuilder<MainScreenBloc, int>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                _onItemTapped(index, mainScreenBloc);
              },
              iconSize: Config.iconSize - 5,
              currentIndex: state,
              backgroundColor: Config.primaryColor,
              selectedFontSize: Config.textSmallSize,
              selectedItemColor: Config.textDarkerColor,
              unselectedFontSize: Config.textSmallSize,
              unselectedItemColor: Config.textDarkColor,
              items: <BottomNavigationBarItem>[
                for (final bottomMenuItem in _bottomMenuItems) BottomNavigationBarItem(
                  icon: Padding(
                    padding: bottomMenuItem.isPadding
                        ? const EdgeInsets.only(left: 6.0)
                        : EdgeInsets.zero,
                    child: AnimatedSwitcher(
                      duration: const Duration(
                          milliseconds: Config.animDuration),
                      child: state == _bottomMenuItems.indexOf(bottomMenuItem)
                          ? _getImage(bottomMenuItem.selectedImagePath)
                          : _getImage(bottomMenuItem.unselectedImagePath),
                    ),
                  ),
                  label: bottomMenuItem.name,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
