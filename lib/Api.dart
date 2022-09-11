
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

import 'Config.dart';
import 'entity/Booking.dart';
import 'entity/ExploreItem.dart';
import 'entity/BottomMenuItem.dart';

class Api {

  static Future<Response> post({
    required String url, required Map<String, dynamic> body,
    bool ignoreCertificate = false,
  }) async {
    Dio dio = Dio();
    if (ignoreCertificate) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    Response response = await dio.post(
      url,
      data: json.encode(body),
      options: Options(
        sendTimeout: Config.sendTimeout,
        responseType: ResponseType.bytes,
        receiveTimeout: Config.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    ).timeout(const Duration(milliseconds: Config.sendTimeout + Config.receiveTimeout));

    return response;
  }

  static Future<Map<dynamic, dynamic>> authorize({
    required String login, required String pass,
  }) async {
    final Response response = await post(
      url: Config.loginUrl,
      body: {
        "Login": "${Config.prefix}$login", "Password": pass,
      },
    );

    log(
      'Api.authorize: status code ${response.statusCode}', name: Config.appName,
    );

    Map<dynamic, dynamic> responseInMap = jsonDecode(utf8.decode(response.data)) as Map;
    responseInMap['request'] = response.requestOptions;

    return responseInMap;
  }

  static Future<Map<dynamic, dynamic>> getBookings(String token) async {
    final Response response = await post(
      url: Config.getBookingsUrl,
      body: {
        "UserGuid": token,
      },
    );

    log(
      'Api.getBookings: status code ${response.statusCode}',
      name: Config.appName,
    );

    Map<dynamic, dynamic> responseInMap = jsonDecode(utf8.decode(response.data)) as Map;
    responseInMap['request'] = response.requestOptions;

    return responseInMap;
  }

  static Future<Map<dynamic, dynamic>> getServices(String token) async {

    final Response response = await post(
      url: Config.getServicesUrl,
      body: {
        'UserGuid': token,
      },
    );

    log(
      'Api.getServices: response status: ${response.statusMessage} '
          'with code ${response.statusCode}',
      name: Config.appName,
    );

    Map<dynamic, dynamic> responseInMap = jsonDecode(utf8.decode(response.data)) as Map;
    responseInMap['request'] = response.requestOptions;

    return responseInMap;
  }

  static Future<List<dynamic>> getProtocols(Iterable<int> ids, int ownerId) async {
    final Response response = await post(
      url: Config.getProtocolsUrl,
      body: {
        "Id": ids.join(', '),
        "OwnerId": ownerId,
      },
    );

    log(
      'Api.getProtocols: status code ${response.statusMessage} '
        'with code ${response.statusCode}',
      name: Config.appName,
    );

    return jsonDecode(utf8.decode(response.data));
  }

  static Future<Map<dynamic, dynamic>> getEmployeeSaleHistory({
    required int id, required String from, required String till,
  }) async {
    final Response response = await post(
      url: Config.getSaleHistoryUrl,
      body: {
        "DateFrom": from, "DateTill": till, "EmployeeId": id,
      }
    );

    log(
      'Api.getEmployeeSaleHistory: status code ${response.statusCode}',
      name: Config.appName,
    );

    Map<dynamic, dynamic> responseInMap = jsonDecode(utf8.decode(response.data)) as Map;
    responseInMap['request'] = response.requestOptions;

    return responseInMap;
  }

  // static Future<Map<dynamic, dynamic>> sendServiceIds(
  //   int employeeId, List<String> serviceIds,
  // ) async {
  //   var response = await post(
  //     url: Config.sendServiceIdsUrl, ignoreCertificate: true,
  //     body: {
  //       "EmployeeId": employeeId, "ServiceIdList": serviceIds,
  //     },
  //   );
  //
  //   log('Api.sendServiceIds: status code ${response.statusCode}');
  //
  //   return jsonDecode(utf8.decode(response.data)) as Map;
  // }

  static Future<Map<dynamic, dynamic>> getProduct(int ownerId, String code) async {
    final Response response = await post(
      url: Config.getProductUrl,
      body: {
        "OwnerId": ownerId, "Barcode": code,
      },
    );

    log(
      'Api.getProduct: status code ${response.statusCode}', name: Config.appName,
    );

    Map<dynamic, dynamic> responseInMap = jsonDecode(utf8.decode(response.data)) as Map;
    responseInMap['request'] = response.requestOptions;

    return responseInMap;
  }

  static Future<Map<dynamic, dynamic>> bookingClose({
    required int profileId, required int bookingId, required int bookingTngId,
    required int clientId, required int tngClientId,
    required int ownerId, required int employeeId, required int employeeTngId,
    required String? comments,
    required List<Map<String, dynamic>> services,
    required List<Map<String, dynamic>> products,
  }) async {
    final Response response = await post(
      url: Config.sendBookingCloseUrl,
      body: {
        'ProfileId': profileId,
        'BookingId': bookingId, 'BookingTngId': bookingTngId,
        'ClientId': clientId, 'TngClientId': tngClientId,
        'Ownerid': ownerId,
        'EmployeeId': employeeId, 'EmployeeTngId': employeeTngId,
        'CommentRecommendation': comments,
        'Services': services,
        'NomenItems': products,
      },
    );

    log(
      'Api.bookingClose: status code ${response.statusCode}',
      name: Config.appName,
    );

    Map<dynamic, dynamic> responseInMap = jsonDecode(utf8.decode(response.data)) as Map;
    responseInMap['request'] = response.requestOptions;

    return responseInMap;
  }

  static Future<Map<dynamic, dynamic>> sendException({
    required int id, required String? ip, required String address,
    required String request, required String exceptionTrace,
  }) async {
    final Response response = await post(
      url: Config.sendExceptionTraceUrl,
      body: {
        "Id": id,
        "Ip": ip,
        "Address": address,
        "Request": request,
        "Ex": exceptionTrace,
      },
    );

    log(
      'Api.sendException: status code ${response.statusCode}',
      name: Config.appName,
    );

    return jsonDecode(utf8.decode(response.data)) as Map;
  }

  static Future<Map<dynamic, dynamic>> editProfileInfo({
    required int ownerId, required int profileId,
    String? aboutMe, String? image,
  }) async {
    final Response response = await post(
      url: Config.sendProfileInfoUrl,
      body: {
        "EmployeeId": profileId,
        "Notes": aboutMe,
        "Imagebase64": image,
        "OwnerId": ownerId,
      },
    );

    log(
      'Api.editProfileInfo: status code ${response.statusCode}',
      name: Config.appName,
    );

    return jsonDecode(utf8.decode(response.data)) as Map;
  }

  static List<BottomMenuItem> getBottomMenuItems() {
    return [
      const BottomMenuItem(
        name: 'Брони',
        selectedImagePath: 'assets/images/s_bookings.png',
        unselectedImagePath: 'assets/images/un_bookings.png',
        isPadding: true,
      ),
      const BottomMenuItem(
        name: 'Статистика',
        selectedImagePath: 'assets/images/s_stats.png',
        unselectedImagePath: 'assets/images/un_stats.png',
      ),
      const BottomMenuItem(
        name: 'Профиль',
        selectedImagePath: 'assets/images/s_profile.png',
        unselectedImagePath: 'assets/images/un_profile.png',
      ),
    ];
  }

  static List<ExploreItem> getExploreItems() {
    return [
      ExploreItem('Бассейн', 'assets/images/photo.jpg'),
      ExploreItem('СПА', 'assets/images/photo.jpg'),
      ExploreItem('Йога', 'assets/images/photo.jpg'),
      ExploreItem('Ресторан', 'assets/images/photo.jpg'),
      ExploreItem('Клуб Океан', 'assets/images/photo.jpg'),
      ExploreItem('Медицинский центр', 'assets/images/photo.jpg'),
      ExploreItem('Фитнес центр', 'assets/images/photo.jpg'),
    ];
  }

  static Future<List<Booking>> getAppointments() async {
    // final DateTime today = DateTime.now();
    // final DateTime start = DateTime(today.year, today.month, today.day, 12, 0, 0);
    // final DateTime end = start.add(const Duration(hours: 1));

    return [
      // Booking(
      //   title: 'title', client: 'client', profileId: 0, endTime: end,
      //   startTime: start, status: 'status', bookingId: 0, saleManager: 0,
      //   closeBookingId: 0, subject: 'Иванов Иван Иванович',
      //   color: Colors.blueGrey, ownerId: 0,
      //   recurrenceRule: 'FREQ=DAILY;COUNT=2', // repeats
      //   isAllDay: false,
      //   statusId: 1,
      // ),
      // Booking(
      //   title: 'title', client: 'client', profileId: 0, status: 'status',
      //   bookingId: 0, saleManager: 0, ownerId: 0,
      //   startTime: start.add(const Duration(hours: 2)),
      //   endTime: end.add(const Duration(hours: 3)),
      //   closeBookingId: 0, subject: 'Dart Weider',
      //   color: Colors.green.shade800,
      //   recurrenceRule: 'FREQ=DAILY;COUNT=1', // repeats
      //   isAllDay: false,
      //   statusId: 2
      // ),
      // Booking(
      //   title: 'title', client: 'client', profileId: 0, status: 'status',
      //   bookingId: 0, saleManager: 0, ownerId: 0,
      //   startTime: start.add(const Duration(hours: 5)),
      //   endTime: end.add(const Duration(hours: 6)),
      //   closeBookingId: 0, subject: 'Emma Hewitt',
      //   color: Colors.grey.shade800,
      //   recurrenceRule: 'FREQ=DAILY;COUNT=1', // repeats
      //   isAllDay: false,
      //   statusId: 3,
      // ),
    ];
  }
}
