
import 'package:intl/intl.dart';

class DateTimeFormat {

  late String languageCode;

  DateTimeFormat(this.languageCode);

  String getDateTimeString(DateTime value, String pattern) {
    return DateFormat(pattern, languageCode)
        .format(value)
        .split(' ')
        .map((e) => e.length > 2 ? '${e[0].toUpperCase()}${e.substring(1)}' : e)
        .join(' ');
  }
}
