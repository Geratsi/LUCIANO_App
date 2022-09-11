import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:luciano/components/LabelAndIconButton.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';

class ExploreCardScreen extends StatelessWidget {
  const ExploreCardScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  static const List images = [
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png',
  ];

  final double swiperHeight = 260;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      body: Column(
        children: <Widget>[
          Container(
            color: Config.activityHintColor,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: swiperHeight,
                  child: Swiper(
                    autoplay: true,
                    pagination: const SwiperPagination(),
                    itemBuilder: (BuildContext context, int index) {
                      return Image(
                        image: AssetImage(images[index]),
                        fit: BoxFit.contain, repeat: ImageRepeat.noRepeat,
                      );
                    },
                    itemCount: images.length,
                    itemWidth: MediaQuery.of(context).size.width,
                    layout: SwiperLayout.DEFAULT,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Config.padding * 2, vertical: Config.padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text('Время работы:', style: Styles.titleStyle,
                      ),
                      Text('6.00 - 22.00', style: Styles.titleStyle
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Config.padding),
            child: Column(
              children: <Widget>[
                LabelAndIconButton(
                  label: 'Мои брони',
                  handler: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) => const BookingsScheduleScreen()));
                  },
                ),

                const SizedBox(height: Config.padding,),

                LabelAndIconButton(
                  label: 'Познакомьтесь с командой',
                  handler: () {

                  },
                ),

                const SizedBox(height: Config.padding,),

                LabelAndIconButton(
                  label: 'Записаться на услугу',
                  handler: () {

                  },
                ),

                const SizedBox(height: Config.padding,),

                LabelAndIconButton(
                  label: 'Групповые занятия',
                  handler: () {

                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

