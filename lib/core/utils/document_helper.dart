import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentHelper {
  static Document parseFromContent(String content) {
    try {
      final jsonContent = jsonDecode(content);
      return Document.fromJson(jsonContent);
    } catch (_) {
      return Document()..insert(0, content);
    }
  }
}
