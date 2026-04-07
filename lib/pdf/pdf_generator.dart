import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BasePdf {
  static Future<File> save(List<int> bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$fileName");

    await file.writeAsBytes(bytes);
    return file;
  }
}