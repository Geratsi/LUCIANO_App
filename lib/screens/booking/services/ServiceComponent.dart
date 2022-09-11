
import 'package:flutter/material.dart';

import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Service.dart';

class ServiceComponent extends StatefulWidget {
  const ServiceComponent({
    Key? key,
    required this.item,
    required this.onPressed,
    this.isDisabled = false,
  }) : super(key: key);

  final bool isDisabled;
  final Service item;
  final Function onPressed;

  @override
  State<ServiceComponent> createState() => _ServiceComponentState();
}

class _ServiceComponentState extends State<ServiceComponent> {
  late bool _isSelected;
  late Service _service;

  @override
  void initState() {
    super.initState();

    _service = widget.item;
    _isSelected = _service.isSelected;
  }

  @override
  void didUpdateWidget(covariant ServiceComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    _service = widget.item;
    _isSelected = _service.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _service.count = 1;

        setState(() {
          _isSelected = !_isSelected;
        });

        widget.onPressed();
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Config.activityBorderRadius - 10),
          color: _isSelected ? Config.primaryColor : Config.infoColor,
          boxShadow: [
            BoxShadow(
              color: _isSelected ? Config.shadowColor.withOpacity(0.2) : Colors.transparent,
              spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: Config.padding),
        duration: const Duration(milliseconds: Config.animDuration),
        child: Padding(
          padding: const EdgeInsets.all(Config.padding / 2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _service.label,
                  style: _isSelected ? Styles.textTitleColorBoldStyle : Styles.textTitleColorStyle,
                  // textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
