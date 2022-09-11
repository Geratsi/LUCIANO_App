import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class AvatarController {
  const AvatarController({
    required this.fileName,
  });

  final String fileName;

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    return '${appDocumentsDirectory.path}/$fileName';
  }

  void saveImageAsBytes(Uint8List image) async {
    File file = File(await getFilePath());
    file.writeAsBytes(image);
  }

  Future<Uint8List?> readImageBytes() async {
    File file = File(await getFilePath());
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }
}
