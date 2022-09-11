
import 'dart:convert';

import 'package:flutter/material.dart';

class Config{
  //MAIN STYLE
  static const Color primaryColor = Color.fromRGBO(215, 178, 126, 1.0),
    primaryDarkColor = Color.fromRGBO(172, 142, 101, 1.0),
    primaryLightColor = Color.fromRGBO(235, 217, 191, 1.0),

    secondaryButtonColor = Color.fromRGBO(204, 204, 204, 1.0);

  static Color shadowColor = Colors.black,
    shadowNavColor = Colors.black.withOpacity(0.15),
    shadowCardColor = Colors.black.withOpacity(0.25),

    splashColor = primaryLightColor,
    splashOverlayColor = primaryLightColor.withOpacity(0.5),

    errorColor = Colors.red.shade400,
    warningColor = Colors.red.shade300,
    progressColor = Colors.blue.shade800,
    successColor = Colors.green.shade600,
    progressHintColor = Colors.green.shade800;

  static const int animDuration = 250,
    progressDuration = 500,
    notificationDuration = 2000;

  //GLOBAL COMPONENTS
  //TEXT
  static const String appName = '___LUCIANO APP___';
  static const Color textColorOnPrimary = Colors.white;
  static const Color textColor = Color.fromRGBO(128, 128, 128, 1.0),
    textDarkColor = Color.fromRGBO(112, 106, 91, 1.0),
    textDarkerColor = Color.fromRGBO(0, 0, 1, 1.0),
    textTitleColor = Color.fromRGBO(89, 89, 89, 1.0);
  static const double textLargeSize = 20, textMediumSize = 16, textSmallSize = 14;

  //ACTIVITY
  static const Color appointmentColor = Color.fromRGBO(136, 136, 136, 1.0);
  static const Color activityBackColor = Color.fromRGBO(226, 217, 203, 1.0);
  static const Color activityHintColor = Color.fromRGBO(230, 230, 230, 1.0);
  static const double activityBorderRadius = 25, smallBorderRadius = 12, padding = 16;
  static const Widget emptyWidget = SizedBox.shrink();

  //COMPONENTS
  static const double cursorWidth = 3, iconSize = 30, avatarSize = 100;

  //ACTIVITY BAR
  static const Color activityBottomBarItemActiveColor = Colors.red;
  static Color activityBottomBarItemUnActiveColor = Colors.blue.shade900;

  //OTHER
  static const Color baseInfoColor = Color.fromRGBO(204, 204, 204, 0.2),
    infoColor = Color.fromRGBO(248, 245, 237, 1.0);
  static Color waitingColor = Colors.yellow.shade600,
    baseWarningInfoColor = Colors.red.shade100;
  static String groupSeparator = ascii.decode([29]), currency = '₽';
  static RegExp findTrailingZeros = RegExp(r'([.]*0)(?!.*\d)'),
    doubleInputREgExp = RegExp(r'(^\d*\.?\d*)');

  //API ADDRESS
  static const String prefix = r'kzn\mirspa\',
    loginUrl = 'https://bossapi.luciano.ru/api/MobileAuth/Login',
    getProductUrl = 'https://etpzakaz.ru/sfarm/ws/api/MobApp/ProductInfoGet',
    getServicesUrl = 'https://bossapi.luciano.ru/api/EmployeeService/EmployeeServicesGet',
    getBookingsUrl = 'https://bossapi.luciano.ru/api/MedEmployeeSchedule/MedEmployeeScheduleGet',
    getProtocolsUrl = 'https://etpzakaz.ru/sfarm/ws/api/OwnerServices/GetProtocols',
    getSaleHistoryUrl = 'https://bossapi.luciano.ru/api/SaleHistoryGet/SaleHistoryGet',
    sendServiceIdsUrl = 'https://bossapi.luciano.ru/api/SaleHistory/InsertSaleHistory',
    sendProfileInfoUrl = 'https://bossapi.luciano.ru/api/Person/Edit',
    sendBookingCloseUrl = 'https://bossapi.luciano.ru/api/BookingClose/BookingClosing',
    sendProtocolItemsUrl = 'https://etpzakaz.ru/sfarm/ws/api/OwnerServices',
    updateBookingInfoUrl = 'https://bossapi.luciano.ru/api/BookingStatusChange/StatusChange',
    sendExceptionTraceUrl = 'https://bossapi.luciano.ru/api/Logger/Write';

  //DATETIME
  static const Duration duration = Duration(hours: 1);

  //TIMEOUT
  static const int sendTimeout = 35000,
    receiveTimeout = 25000;

  //STORAGE KEYS
  static const String username = 'username',
    password = 'password',
    employeeId = 'employeeId',
    isSaveData = 'isSaveData',
    filePath = 'user_photo_in_bytes',
    userKey = 'userKey';

  //APP BAR
  static Widget flexibleGradientSpace = Container(
    decoration: const BoxDecoration(
      // gradient: LinearGradient(
      //   begin: Alignment.topRight,
      //   end: Alignment.bottomLeft,
      //   colors: [
      //     primaryDarkColor, primaryLightColor,
      //     primaryDarkColor, primaryLightColor,
      //   ],
      // ),
    ),
  );
}
