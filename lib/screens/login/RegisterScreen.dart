
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:luciano/Config.dart';
import 'package:luciano/components/MainTextInput.dart';
import 'package:luciano/components/ModalProgress.dart';
import 'package:luciano/components/MainOpacityButton.dart';
import 'package:luciano/components/MainContentWithLabel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late FocusNode _nameFocusNode;
  late FocusNode _mailFocusNode;
  late FocusNode _secondNameFocusNode;
  late ModalProgress _progressIndicator;
  late TextEditingController _nameController;
  late TextEditingController _mailController;
  late TextEditingController _secondNameController;

  @override
  void initState() {
    _nameFocusNode = FocusNode();
    _mailFocusNode = FocusNode();
    _secondNameFocusNode = FocusNode();
    _nameController = TextEditingController();
    _mailController = TextEditingController();
    _progressIndicator = ModalProgress.of(context);
    _secondNameController = TextEditingController();

    super.initState();
  }

  void _postUserToServer() {
    _progressIndicator.show();

    Timer(const Duration(milliseconds: Config.progressDuration), () {
      _progressIndicator.hide();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _mailController.dispose();
      _secondNameController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // 450 - height of content
    final double paddingTop = (MediaQuery.of(context).size.height - 450) / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.registration),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Config.padding, paddingTop,
            Config.padding, Config.padding,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              MainContentWithLabel(
                label: localizations.yourName,
                contentWidget: MainTextInput(
                  focusNode: _nameFocusNode, controller: _nameController,
                  placeholder: localizations.name, defaultValidation: true,
                  textInputAction: TextInputAction.next,
                  onSubmit: () {
                    FocusScope.of(context).requestFocus(_secondNameFocusNode);
                  },
                ),
              ),

              MainContentWithLabel(
                label: localizations.yourSecondName,
                contentWidget: MainTextInput(
                  focusNode: _secondNameFocusNode, defaultValidation: true,
                  controller: _secondNameController,
                  placeholder: localizations.secondName,
                  textInputAction: TextInputAction.next,
                  onSubmit: () {
                    FocusScope.of(context).requestFocus(_mailFocusNode);
                  },
                ),
              ),

              MainContentWithLabel(
                label: localizations.yourEmail,
                contentWidget: MainTextInput(
                  focusNode: _mailFocusNode, controller: _mailController,
                  placeholder: 'example@yandex.ru', defaultValidation: true,
                  textInputType: TextInputType.emailAddress,
                  capitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.go,
                  onSubmit: _postUserToServer,
                ),
              ),

              const SizedBox(height: Config.padding,),

              MainOpacityButton(
                label: localizations.register,
                onPressed: _postUserToServer,
                controllers: [_nameController, _secondNameController, _mailController],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
