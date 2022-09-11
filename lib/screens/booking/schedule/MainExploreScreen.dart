
import 'package:luciano/Api.dart';
import 'package:luciano/Config.dart';
import 'package:flutter/material.dart';
import 'package:luciano/entity/ExploreItem.dart';
import 'package:luciano/screens/booking/schedule/ExploreComponent.dart';
import 'package:luciano/screens/booking/schedule/ExploreCardScreen.dart';

class MainExploreScreen extends StatefulWidget {
  const MainExploreScreen({Key? key,}) : super(key: key);

  @override
  _MainExploreScreenState createState() => _MainExploreScreenState();
}

class _MainExploreScreenState extends State<MainExploreScreen> {

  late List<ExploreItem> exploreItems;

  @override
  void initState() {
    exploreItems = Api.getExploreItems();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: Config.padding),
      scrollDirection: Axis.vertical,
      itemCount: exploreItems.length,
      itemBuilder: (context, int index) {
        final ExploreItem item = exploreItems[index];
        return ExploreComponent(
          name: item.title,
          source: item.source,
          child: ExploreCardScreen(title: item.title),
        );
      },
      separatorBuilder: (context, int index) {
        return const SizedBox(height: Config.padding / 1.5,);
      },
    );
  }
}
