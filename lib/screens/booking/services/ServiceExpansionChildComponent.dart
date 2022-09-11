
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/ProtocolProduct.dart';
import '../../../components/MainTextInput.dart';
import '../../../components/DecrementWidget.dart';
import '../../../components/IncrementWidget.dart';

class ServiceExpansionChildComponent extends StatelessWidget {
  const ServiceExpansionChildComponent({
    Key? key,
    required this.costItem,
    required this.controller,
    this.horizontalPadding,
  }) : super(key: key);

  final double? horizontalPadding;
  final ProtocolProduct costItem;
  final TextEditingController controller;

  void _onChanged(String newValue) {
    try {
      costItem.currentQuantity = double.parse(newValue);
    } catch (error) {
      log('ServiceExpansionChildComponent._onChanged: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.text = costItem.getCurrentQuantityString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0,),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Wrap(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: costItem.name,
                    style: Styles.textSmallStyle,
                    children: <TextSpan>[
                      costItem is ProtocolProductChild
                          ? const TextSpan()
                          : TextSpan(
                        text: ' (${costItem.unit})',
                        style: Styles.textSmallBoldStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              costItem.needButtons
                  ? DecrementWidget(controller: controller, callback: (int _) {},)
                  : const SizedBox(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: costItem.needButtons ? 60 : 80,
                    child: MainTextInput(
                      padding: EdgeInsets.zero,
                      onChanged: _onChanged,
                      textAlign: TextAlign.center,
                      controller: controller,
                      hasTrailing: false,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(Config.doubleInputREgExp),
                      ],
                    ),
                  ),
                ],
              ),

              costItem.needButtons
                  ? IncrementWidget(controller: controller, callback: (int _) {},)
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
