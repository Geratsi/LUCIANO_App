
import '../Api.dart';

class SaleHistoryRepository {

  Future<Map<dynamic, dynamic>> getSaleHistory(int id, String from, String till) =>
      Api.getEmployeeSaleHistory(id: id, from: from, till: till,);
}