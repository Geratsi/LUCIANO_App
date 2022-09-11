
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:luciano/Config.dart';
import 'package:luciano/Styles.dart';
import 'package:luciano/Storage.dart';
import 'package:luciano/l10n/l10n.dart';
import 'package:luciano/entity/SelectItem.dart';
import 'package:luciano/components/MainSwitch.dart';
import 'package:luciano/utilities/ValueListener.dart';
import 'package:luciano/components/ModalProgress.dart';
import 'package:luciano/components/android/AndroidSelect.dart';
import 'package:luciano/components/ModalBottomMessage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ModalProgress _loading;

  bool _sms = true;
  bool _news = true;
  bool _notifications = true;
  Locale _localLanguage = const Locale('ru');

  void _initialize() {
    Storage.get('sms').then((value) {
      if (value != null) {
        setState(() {
          _sms = value == '1' ? true : false;
        });
      }
    });

    Storage.get('news').then((value) {
      if (value != null) {
        setState(() {
          _news = value == '1' ? true : false;
        });
      }
    });

    Storage.get('notifications').then((value) {
      if (value != null) {
        setState(() {
          _notifications = value == '1' ? true : false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initialize();
  }

  void _chooseLanguage(ValueListener provider) {
    Iterable<SelectItem> _selectItems = L10n.all.map(
      (Locale locale) => SelectItem(
        L10n.getLabel(locale.languageCode),
        () {
          Navigator.of(context).pop();
          Timer(const Duration(milliseconds: Config.animDuration), () => provider.setValue = locale);
          _localLanguage = locale;
        }
      ),
    );

    if (Platform.isIOS) {
      // showCupertinoModalPopup(
      //   context: context,
      //   builder: (_) => IOSSelect(
      //     title: 'Выберите язык',
      //     selectActions: _selectActions,
      //   ),
      // );

    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (_) => AndroidSelect(
          title: AppLocalizations.of(context)!.chooseLanguage,
          selectItems: _selectItems,
        ),
      );
    }
  }

  void _saveData() {
    _loading.show();

    Storage.set('sms', _sms ? '1' : '0');
    Storage.set('news', _news ? '1' : '0');
    Storage.set('notifications', _notifications ? '1' : '0');
    Storage.set('languageCode', _localLanguage.languageCode);

    Timer(const Duration(milliseconds: 500), () {
      _loading.hide();
      ScaffoldMessenger.of(context).showSnackBar(
          ModalBottomMessage(
            message: 'Данные успешно сохранены!',
            messageColor: Config.successColor,
            bgColor: Config.activityHintColor,
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ValueListener<Locale> provider = Provider.of<ValueListener<Locale>>(context);
    final localizations = AppLocalizations.of(context);
    _loading = ModalProgress.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings, style: Styles.titleStyle,),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveData,
            icon: const Icon(Icons.done),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            MainSwitch(
              value: _notifications,
              onPressed: (val) {
                setState(() {
                  _notifications = val;
                });
              },
              child: Text(localizations!.notifications, style: Styles.titleStyle,),
            ),

            MainSwitch(
              value: _sms,
              onPressed: (val) {
                setState(() {
                  _sms = val;
                });
              },
              child: Text(localizations.sms, style: Styles.titleStyle,),
            ),

            MainSwitch(
              value: _news,
              onPressed: (val) {
                setState(() {
                  _news = val;
                });
              },
              child: Text(localizations.news, style: Styles.titleStyle,),
            ),

            Container(
              color: Config.activityHintColor,
              padding: const EdgeInsets.fromLTRB(Config.padding / 2, Config.padding / 2,
                  Config.padding / 2, Config.padding / 2),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.changeLanguage, style: Styles.titleStyle,),
                    const Icon(Icons.language, size: Config.iconSize,),
                  ],
                ),
                onPressed: () {_chooseLanguage(provider);},
              ),
            ),

            const Divider(thickness: 1, height: 1, color: Config.textTitleColor,),
          ],
        ),
      ),
    );
  }
}

