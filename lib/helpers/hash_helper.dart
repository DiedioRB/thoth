import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashHelper {
  static String sha256Encrypt(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }
}
