import 'package:flutter/material.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/entity/SelectItem.dart';
import 'package:luciano/Styles.dart';

class AndroidSelect extends StatefulWidget {
  const AndroidSelect({
    Key? key,
    required this.title,
    required this.selectItems,
  }) : super(key: key);

  final String title;
  final Iterable<SelectItem> selectItems;

  @override
  State<AndroidSelect> createState() => _AndroidSelectState();
}

class _AndroidSelectState extends State<AndroidSelect> {
  final List<SimpleDialogOption> _actions = <SimpleDialogOption>[];

  @override
  void initState() {
    super.initState();

    _actions.addAll(
      widget.selectItems.map((item) => SimpleDialogOption(
        onPressed: () {item.onPressed();},
        child: Text(item.label, style: Styles.titlePrimaryStyle,
          textAlign: TextAlign.center,
        ),
        padding: const EdgeInsets.symmetric(vertical: Config.padding,),
      ))
    );

    _actions.add(
      SimpleDialogOption(
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: Config.padding),
          child: Text(
            'Отмена',
            style: Styles.titlePrimaryDarkStyle,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: Config.padding),
        child: Text(
          widget.title,
          style: Styles.titleStyle,
          textAlign: TextAlign.center,
        ),
      ),
      children: _actions,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Config.activityHintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Config.activityBorderRadius),
      ),
    );
  }
}

