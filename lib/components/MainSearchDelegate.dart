
import 'package:flutter/material.dart';

import '../Config.dart';
import '../entity/Service.dart';
import '../screens/booking/services/ServiceComponent.dart';

class MainSearchDelegate extends SearchDelegate<Service?> {
  MainSearchDelegate({
    Key? key,
    required this.allSearchItems,
    this.updateParentState,
    this.popularSearchItems,
  });

  final Function? updateParentState;
  final List<Service> allSearchItems;
  final List<Service>? popularSearchItems;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: Config.padding / 2),
        child: IconButton(
          icon: const Icon(Icons.cancel, size: Config.iconSize,),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: Config.iconSize),
      onPressed: () {
        close(context, null);
        if (updateParentState != null) {
          updateParentState!();
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Service> matchQuery = [];
    for (final Service item in allSearchItems) {
      if (item.label.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Config.padding),
        child: Column(
          children: <Widget>[
            ...matchQuery.map((item) => ServiceComponent(
              item: item,
              isDisabled: true,
              onPressed: () {
                item.isSelected = true;
                close(context, null);
              },
            ),)
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Service> matchQuery = [];
    for (final Service item in popularSearchItems ?? allSearchItems) {
      if (item.label.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Config.padding),
        child: Column(
          children: <Widget>[
            ...matchQuery.map((item) => ServiceComponent(
              item: item,
              isDisabled: true,
              onPressed: () {
                item.isSelected = true;
                close(context, null);
              },
            ),)
          ],
        ),
      ),
    );
  }
}
