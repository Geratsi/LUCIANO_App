
import 'package:flutter/cupertino.dart';

class IOSSelect extends StatefulWidget {
  const IOSSelect({
    Key? key,
    required this.title,
    required this.selectActions,
    this.cancelButton,
  }) : super(key: key);

  final String title;
  final Iterable<Map> selectActions;
  final Widget? cancelButton;

  @override
  State<IOSSelect> createState() => _IOSSelectState();
}

class _IOSSelectState extends State<IOSSelect> {

  final List<CupertinoActionSheetAction> _actions = <CupertinoActionSheetAction>[];

  @override
  void initState() {
    super.initState();

    for (var item in widget.selectActions) {
      _actions.add(CupertinoActionSheetAction(
        onPressed: item['handler'],
        child: Text(item['label']),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 18),
      ),
      actions: _actions,
      cancelButton: widget.cancelButton ??
          CupertinoButton(
            child: const Text(
              'Отмена',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
    );
  }
}

