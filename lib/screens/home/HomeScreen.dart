
import 'package:flutter/material.dart';

import '../../Config.dart';
import '../../entity/Person.dart';
import '../../entity/BottomMenuItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.personInfo,
  }) : super(key: key);

  final Person personInfo;

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  late List<BottomMenuItem> _bottomMenuItems;

  int _selectedIndex = 0;

  BottomMenuItem get bottomMenuItem => _bottomMenuItems[_selectedIndex];

  @override
  void initState() {
    super.initState();

    _bottomMenuItems = [
      // BottomMenuItem(
      //   name: 'Брони',
      //   widget: BookingsScheduleScreen(
      //     navigateToProfile: () {
      //       _onItemTapped(2);
      //     }
      //   ),
      //   selectedImagePath: 'assets/images/s_bookings.png',
      //   unselectedImagePath: 'assets/images/s_bookings.png',
      // ),
      // BottomMenuItem(
      //   name: 'Статистика',
      //   // widget: StatisticScreen(personInfo: widget.personInfo),
      //   selectedImagePath: 'assets/images/s_bookings.png',
      //   unselectedImagePath: 'assets/images/s_bookings.png',
      // ),
      // BottomMenuItem(
      //   name: 'Профиль',
      //   // widget: ProfileScreen(personInfo: widget.personInfo,),
      //   selectedImagePath: 'assets/images/s_bookings.png',
      //   unselectedImagePath: 'assets/images/s_bookings.png',
      // ),
    ];
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    _pageController.animateToPage(
      index, duration: const Duration(milliseconds: Config.animDuration),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          ..._bottomMenuItems.map((e) => Container())
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Config.textColor),),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          iconSize: Config.iconSize - 5,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: Config.textSmallSize,
          selectedItemColor: Config.textDarkerColor,
          unselectedFontSize: Config.textSmallSize,
          backgroundColor: Config.primaryLightColor,
          unselectedItemColor: Config.textTitleColor,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            for (final bottomMenuItem in _bottomMenuItems) BottomNavigationBarItem(
              icon: Image.asset(
                _selectedIndex == _bottomMenuItems.indexOf(bottomMenuItem)
                    ? bottomMenuItem.selectedImagePath
                    : bottomMenuItem.unselectedImagePath,
                width: Config.iconSize, height: Config.iconSize,
              ),
              label: bottomMenuItem.name,
            )
          ],
        ),
      ),
    );
  }
}
