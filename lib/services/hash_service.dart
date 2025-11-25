// lib/services/hash_service.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashService {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}