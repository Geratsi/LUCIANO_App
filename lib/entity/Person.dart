
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;

import '../Config.dart';
import '../modelView/ExceptionLogger.dart';

class Person {
  final int id;
  final int ownerId;
  final String name;
  final String gender;
  final String surname;
  final String position;
  final String secondName;
  final DateTime? birthdayDate;

  String? notes;
  Uint8List imageBytes;
  Uint8List? newImageBytes;

  Person({
    required this.id, required this.name, required this.surname,
    required this.secondName, required this.gender, required this.imageBytes,
    required this.position, required this.ownerId, this.birthdayDate, this.notes,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    late Uint8List _imageBytes;
    final Map<String, dynamic> personInfo = json['personInfo'];
    final Map<String, dynamic>? employeeInfo = json['employeeInfo'];

    final String? imageString = json['image'];
    if (imageString == null || imageString.isEmpty) {
      rootBundle.load('assets/images/person.jpg').then((value) {
        _imageBytes = Uint8List.sublistView(value);
      });
      log('Person entity: image from server is null or empty, value: {$imageString}');
      ExceptionLogger.sendException(
        address: Config.loginUrl, request: '{}', profileId: '${personInfo['id']}',
        exceptionTrace: 'Image from server is null or empty, value: {$imageString}',
      );
    } else {
      _imageBytes = base64Decode(imageString);
    }

    return Person(
      id: personInfo['id'],
      name: personInfo['FirstName'] ?? '-',
      surname: personInfo['LastName'] ?? '-',
      secondName: personInfo['Patronymic'] ?? '-',
      birthdayDate: personInfo['Birthday'] != null
          ? DateTime.parse(personInfo['Birthday'],) : null,
      gender: personInfo['Gender'] ?? '-',
      imageBytes: _imageBytes,
      position: employeeInfo != null ? employeeInfo['FullName'] : '',
      ownerId: personInfo['OwnerId'],
      notes: personInfo['Notes'],
    );
  }
}
