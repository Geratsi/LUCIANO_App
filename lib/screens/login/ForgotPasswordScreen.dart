import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:luciano/components/MainOpacityButton.dart';
import 'package:luciano/components/MainTextInput.dart';
import 'package:luciano/components/MainContentWithLabel.dart';
import 'package:luciano/Config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _mailController = TextEditingController();

  @override
  void dispose() {
    _mailController.dispose();

    super.dispose();
  }

  void _checkMail() {
    if (_mailController.text.trim().isNotEmpty) {
      print('correct');
      print(_mailController.text);
    } else {
      print('ne o4enb');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar( // наслоение на предыдущий скрин
        title: Text(localizations!.passwordRecovery),
      ),

      body: Padding(
        padding: const EdgeInsets.all(Config.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MainContentWithLabel(
              label: localizations.yourEmail,
              contentWidget: MainTextInput(
                controller: _mailController,
                placeholder: 'example@yandex.ru',
                capitalization: TextCapitalization.none,
              ),
            ),

            const SizedBox(height: Config.padding * 2),

            MainOpacityButton(
              label: localizations.recover,
              onPressed: _checkMail,
            ),
          ],
        ),
      ),
    );
  }
}

