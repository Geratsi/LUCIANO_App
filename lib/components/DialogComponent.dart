
import 'dart:ui';

import 'package:flutter/material.dart';

import 'DialogActionButton.dart';
import '../Config.dart';
import '../entity/DialogAction.dart';

class DialogComponent extends StatelessWidget {
  const DialogComponent({
    Key? key,
    required this.title,
    required this.actions,
    this.content,
    this.barrierDismissible = true,
  }) : super(key: key);

  final Widget title;
  final Widget? content;
  final List<DialogAction> actions;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (barrierDismissible) {
                    Navigator.of(context).pop();
                  }
                },
                splashColor: Colors.transparent,
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(Config.padding * 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Config.infoColor,
                      borderRadius: BorderRadius.circular(Config.activityBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Config.shadowCardColor,
                          spreadRadius: 1,
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Config.padding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: Config.padding),
                            child: title,
                          ),

                          content != null ? Padding(
                            padding: const EdgeInsets.only(top: Config.padding),
                            child: content,
                          ) : const SizedBox(),

                          const SizedBox(height: Config.padding * 1.5,),

                          Row(
                            mainAxisAlignment: actions.length == 1
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceAround,
                            children: actions.map((action) =>
                                DialogActionButton(action: action)).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
