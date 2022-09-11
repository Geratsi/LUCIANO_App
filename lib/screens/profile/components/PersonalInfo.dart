
import 'package:flutter/material.dart';

import 'LabelAndInput.dart';
import 'LabelAndContent.dart';
import '../../../Config.dart';
import '../../../entity/Person.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({
    Key? key,
    required this.personInfo,
    required this.aboutMeController,
  }) : super(key: key);

  final Person personInfo;
  final TextEditingController aboutMeController;

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late Person _personInfo;

  @override
  void initState() {
    super.initState();

    _personInfo = widget.personInfo;
  }

  @override
  Widget build(BuildContext context) {
    // final String _languageCode = Localizations.localeOf(context).languageCode;
    // _formatter = DateTimeFormat(Localizations.localeOf(context).languageCode);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Config.padding),
        child: Column(
          children: <Widget>[
            LabelAndContent(label: 'Фамилия:', content: _personInfo.surname),
            LabelAndContent(label: 'Имя:', content: _personInfo.name),
            LabelAndContent(label: 'Отчество:', content: _personInfo.secondName),
            LabelAndContent(label: 'Должность:', content: _personInfo.position),
            LabelAndContent(
              label: 'Пол:',
              content:  _personInfo.gender == 'f' ? 'Женский' : 'Мужской',
            ),
            LabelAndInput(label: 'Обо мне', controller: widget.aboutMeController),
          ],
        ),
      ),
    );
  }
}
