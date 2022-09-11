
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'components/PersonalInfo.dart';
import 'components/ProfileImagePicker.dart';
import '../../Config.dart';
import '../../entity/Person.dart';
import '../../utilities/Message.dart';
import '../../modelView/EditProfile.dart';
import '../../components/ModalProgress.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
    required this.personInfo,
    required this.updateParentState,
  }) : super(key: key);

  final Person personInfo;
  final Function updateParentState;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _aboutMeController = TextEditingController();

  late Message _message;
  late Person _personInfo;
  late ModalProgress _progress;
  late List<Widget> _screenStructure;

  @override
  void initState() {
    super.initState();

    _personInfo = widget.personInfo;
    _message = Message(context: context);

    _aboutMeController.text = _personInfo.notes ?? '';

    _initialize();
  }

  @override
  void didUpdateWidget(covariant EditProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initialize();
  }

  void _initialize() {
    _screenStructure = [

      Padding(
        padding: const EdgeInsets.all(Config.padding),
        child: ProfileImagePicker(personInfo: _personInfo,),
      ),

      PersonalInfo(
        personInfo: _personInfo, aboutMeController: _aboutMeController,
      ),

      // SizedBox(height: Config.padding,),
      // Padding(
      //   padding: EdgeInsets.only(top: Config.padding,),
      //   child: Text('Адрес', style: Styles.textStyle,
      //     textAlign: TextAlign.center,
      //   ),
      // ),
      //
      // Address(
      //   cityController: _cityController,
      //   indexController: _indexController,
      //   countryController: _countryController,
      //   addressController: _addressController,
      // ),
    ];
  }

  Future<void> _saveData() async {
    if (_personInfo.newImageBytes != null ||
        _aboutMeController.text.trim() != _personInfo.notes) {
      _progress.show();

      final bool isSuccess = await EditProfile.editImageAndNotes(
        context: context, progress: _progress, ownerId: _personInfo.ownerId,
        profileId: _personInfo.id,
        imageBase64: _personInfo.newImageBytes != null
          ? base64Encode(_personInfo.newImageBytes!) : null,
        aboutMe: _aboutMeController.text.trim() != _personInfo.notes
            ? _aboutMeController.text
            : null,
      );

      if (isSuccess) {
        _message.showMessage(
          title: 'Успешно',
          content: 'Данные успешно сохранены!',
        );

        if (_personInfo.newImageBytes != null) {
          _personInfo.imageBytes = _personInfo.newImageBytes!;
          _personInfo.newImageBytes = null;
        }

        if (_aboutMeController.text.trim() != _personInfo.notes) {
          _personInfo.notes = _aboutMeController.text.trim();
        }

        widget.updateParentState();
      }
    } else {
      _message.showMessage(
        title: 'Ошибка',
        content: 'Измененные данные не найдены',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _progress = ModalProgress.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование'),
        actions: [
          IconButton(
            onPressed: _saveData,
            icon: const Icon(Icons.done),
          ),
        ],
      ),

      body: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        itemCount: _screenStructure.length,
        itemBuilder: (context, int index) {
          return _screenStructure[index];
        },
      ),
    );
  }
}
