// lib/models/user.dart
import 'package:flutter/foundation.dart';

class User {
  final int? id;
  final String fullName;
  final String cpf;
  final DateTime dateOfBirth;
  final String email;
  final String hashedPassword; 

  User({
    this.id,
    required this.fullName,
    required this.cpf,
    required this.dateOfBirth,
    required this.email,
    required this.hashedPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'cpf': cpf,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'email': email,
      'hashedPassword': hashedPassword,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      fullName: map['fullName'] as String,
      cpf: map['cpf'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      email: map['email'] as String,
      hashedPassword: map['hashedPassword'] as String,
    );
  }
}