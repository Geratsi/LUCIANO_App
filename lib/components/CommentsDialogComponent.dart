
import 'package:flutter/material.dart';

import 'MainTextInput.dart';
import 'DialogComponent.dart';
import '../Styles.dart';
import '../entity/DialogAction.dart';

class CommentsDialogComponent extends StatelessWidget {
  const CommentsDialogComponent({
    Key? key,
    required this.sendFunc,
  }) : super(key: key);

  final Function(String) sendFunc;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return DialogComponent(
      title: const Text(
        'Добавьте комментарий', style: Styles.titleStyle,
        textAlign: TextAlign.center,
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainTextInput(
            controller: _controller, textInputType: TextInputType.multiline,
            minLines: 3, placeholder: 'Комментарий*', maxLines: null,
          ),

          const Text('* - необязательное поле', style: Styles.textSmallStyle,),
        ],
      ),
      actions: [
        DialogAction(label: 'Завершить', callback: () {
          Navigator.of(context).pop();
          sendFunc(_controller.text);
        }),
      ],
    );
  }
}
