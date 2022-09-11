
import '../Api.dart';

class LoginRepository {

  Future<Map<dynamic, dynamic>> getPerson(String name, String pass) =>
      Api.authorize(login: name, pass: pass);
}