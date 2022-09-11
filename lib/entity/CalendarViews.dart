
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViews {

  static List<CalendarView> allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.month,
    CalendarView.schedule
  ];

  static String getViewName(CalendarView view) {
    switch(view) {
      case CalendarView.day:
        return 'День';
      case CalendarView.month:
        return 'Месяц';
      case CalendarView.schedule:
        return 'Календарь';
      default:
        return 'Неделя';
    }
  }
}
