
import 'package:flutter/material.dart';

import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Booking.dart';
import '../../../utilities/DateTimeFormat.dart';

class BookingInfoComponent extends StatelessWidget {
  const BookingInfoComponent({
    Key? key,
    required this.booking,
  }) : super(key: key);

  final Booking booking;

  Widget _getBookingComponent(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: Config.padding / 4),
          child: Icon(icon, size: Config.iconSize, color: Config.textColor,),
        ),

        const SizedBox(width: Config.padding,),

        Expanded(child: Text(label, style: Styles.textStyle,),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> mainInfo = booking.subject.split(Config.groupSeparator);
    final DateTimeFormat _formatter = DateTimeFormat(
      Localizations.localeOf(context).languageCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(mainInfo[1], style: Styles.titleStyle, textAlign: TextAlign.center,),

        const SizedBox(height: Config.padding,),

        _getBookingComponent(Icons.person, mainInfo[0].trim()),

        const SizedBox(height: Config.padding / 2,),

        _getBookingComponent(Icons.calendar_today_rounded,
            '${_formatter.getDateTimeString(booking.startTime, 'MMMMEEEEd')} '
                '${booking.startTime.year}'),

        const SizedBox(height: Config.padding / 2,),

        _getBookingComponent(
            Icons.watch_later_outlined,
            '${_formatter.getDateTimeString(booking.startTime, 'Hm')} - '
                '${_formatter.getDateTimeString(booking.endTime, 'Hm')}'
        ),

        const SizedBox(height: Config.padding / 2,),

        RichText(
          text: TextSpan(
            text: 'Статус брони: ',
            style: Styles.textStyle,
            children: <TextSpan>[
              TextSpan(text: booking.statusName, style: Styles.textBoldStyle),
            ],
          ),
        ),

        booking.roomName != null
            ? Padding(
          padding: const EdgeInsets.only(top: Config.padding / 2),
          child: RichText(
            text: TextSpan(
              text: 'Кабинет: ',
              style: Styles.textStyle,
              children: <TextSpan>[
                TextSpan(text: booking.roomName!, style: Styles.textBoldStyle),
              ],
            ),
          ),
        )
            : const SizedBox(),

        booking.notes != null
            ? Padding(
          padding: const EdgeInsets.only(top: Config.padding / 2),
          child: RichText(
            text: TextSpan(
              text: 'Коментарий: ',
              style: Styles.textStyle,
              children: <TextSpan>[
                TextSpan(text: booking.notes!),
              ],
            ),
          ),
        )
            : const SizedBox(),
      ],
    );
  }
}
