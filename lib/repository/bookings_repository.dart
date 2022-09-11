
import '../Api.dart';

class BookingsRepository {

  Future<Map<dynamic, dynamic>> getBookings(String token) =>
      Api.getBookings(token);
}