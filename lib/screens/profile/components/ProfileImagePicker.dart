
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'CustomAvatar.dart';
import '../../../Config.dart';
import '../../../entity/Person.dart';
import '../../../entity/SelectItem.dart';
import '../../../components/android/AndroidSelect.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({
    Key? key,
    required this.personInfo,
  }) : super(key: key);

  final Person personInfo;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();

  late Person _personInfo;

  Uint8List? _newImageBytes;

  @override
  void initState() {
    super.initState();

    _personInfo = widget.personInfo;
  }

  /// Get from gallery
  void _getFromGallery() async {
    Navigator.pop(context);
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      _personInfo.newImageBytes = imageBytes;
      setState(() {
        _newImageBytes = imageBytes;
      });
    }
  }

  /// Get from camera
  void _getFromCamera() async {
    Navigator.pop(context);
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      _personInfo.newImageBytes = imageBytes;
      setState(() {
        _newImageBytes = imageBytes;
      });
    }
  }

  void _chooseSource() {
    Iterable<SelectItem> selectItems = <SelectItem>[
      SelectItem('Камера', _getFromCamera),
      SelectItem('Галерея', _getFromGallery),
    ];

    if (Platform.isIOS) {
      // showCupertinoModalPopup(
      //   context: context,
      //   builder: (_) => IOSSelect(
      //     title: 'Выберите хранилище',
      //     selectActions: _selectActions,
      //   ),
      // );

    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (_) => AndroidSelect(
          title: 'Выберите хранилище',
          selectItems: selectItems,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAvatar(
      imageProvider: MemoryImage(_newImageBytes ?? _personInfo.imageBytes),
      child: GestureDetector(
        onTap: _chooseSource,
        child: Container(
          width: Config.avatarSize * 2,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.4), shape: BoxShape.circle,
          ),
          child: Stack(
            children: const <Widget>[
              Center(
                child: Icon(Icons.photo_camera, color: Config.textColorOnPrimary,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
