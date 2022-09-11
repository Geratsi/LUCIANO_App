import 'package:flutter/material.dart';
import 'package:luciano/components/MainTextInput.dart';
import 'package:luciano/components/MainContentWithLabel.dart';
import 'package:luciano/Config.dart';
import 'package:luciano/Storage.dart';

class Address extends StatefulWidget {
  const Address({
    Key? key,
    required this.cityController,
    required this.indexController,
    required this.countryController,
    required this.addressController,
  }) : super(key: key);

  final TextEditingController cityController;
  final TextEditingController indexController;
  final TextEditingController countryController;
  final TextEditingController addressController;

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {

  late TextEditingController _cityController;
  late TextEditingController _indexController;
  late TextEditingController _countryController;
  late TextEditingController _addressController;

  void initialize() async {
    _cityController.text = await Storage.get('city') ?? '';
    _indexController.text = await Storage.get('index') ?? '';
    _countryController.text = await Storage.get('country') ?? '';
    _addressController.text = await Storage.get('address') ?? '';
  }

  @override
  void initState() {
    super.initState();

    _cityController = widget.cityController;
    _indexController = widget.indexController;
    _countryController = widget.countryController;
    _addressController = widget.addressController;

    initialize();
  }

  @override
  void didUpdateWidget(covariant Address oldWidget) {
    super.didUpdateWidget(oldWidget);

    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Config.padding, 0, Config.padding, Config.padding),
      child: Column(
        children: <Widget>[
          MainContentWithLabel(
            label: 'Ваша страна',
            contentWidget: MainTextInput(
              controller: _countryController, placeholder: 'Страна',
            ),
          ),

          MainContentWithLabel(
            label: 'Ваш город',
            contentWidget: MainTextInput(
              controller: _cityController, placeholder: 'Город',
            ),
          ),

          MainContentWithLabel(
            label: 'Ваш адрес',
            contentWidget: MainTextInput(
              controller: _addressController,
              placeholder: 'Улица, дом, квартира',
            ),
          ),

          MainContentWithLabel(
            label: 'Ваш индекс',
            contentWidget: MainTextInput(
              controller: _indexController,
              placeholder: 'Индекс', textInputType: TextInputType.number,
              maxLength: 6,
            ),
          ),
        ],
      ),
    );
  }
}
