// lib/viewmodels/register_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:analisador_texto_completo/services/auth_service.dart';

enum RegisterState { idle, loading, success, error }

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;
  RegisterState _state = RegisterState.idle;
  String? _errorMessage;

  RegisterState get state => _state;
  String? get errorMessage => _errorMessage;

  String fullName = '';
  String cpf = '';
  String email = '';
  DateTime? dateOfBirth;
  String password = '';
  String confirmPassword = '';

  RegisterViewModel(this._authService);

  // Requisitos avançados de senha
  Map<String, bool> get passwordValidationRules {
    return {
      'Pelo menos 1 maiúscula (A-Z)': password.contains(RegExp(r'[A-Z]')),
      'Pelo menos 1 minúscula (a-z)': password.contains(RegExp(r'[a-z]')),
      'Pelo menos 1 número (0-9)': password.contains(RegExp(r'[0-9]')),
      'Pelo menos 1 caractere especial': password.contains(RegExp(r'[!@#$%^&*()]')),
    };
  }

  bool get isPasswordValid => passwordValidationRules.values.every((isValid) => isValid);

  bool get isFormValid {
    return fullName.isNotEmpty &&
           cpf.length == 14 && 
           email.isNotEmpty &&
           dateOfBirth != null &&
           isPasswordValid &&
           password == confirmPassword;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return 'Nome Completo é obrigatório.';
    if (value.trim().split(RegExp(r'\s+')).length < 2) {
      return 'Deve conter nome e sobrenome.';
    }
    return null;
  }

  String? validateCpf(String? value) {
    if (value == null || value.isEmpty) return 'CPF é obrigatório.';
    if (value.length != 14) return 'CPF incompleto.';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'E-mail é obrigatório.';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Formato de E-mail inválido.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória.';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirmação é obrigatória.';
    if (value != password) return 'As senhas não coincidem.';
    return null;
  }

  void updateField({
    String? newFullName, String? newCpf, String? newEmail,
    DateTime? newDateOfBirth, String? newPassword, String? newConfirmPassword,
  }) {
    if (newFullName != null) fullName = newFullName;
    if (newCpf != null) cpf = newCpf;
    if (newEmail != null) email = newEmail;
    if (newDateOfBirth != null) dateOfBirth = newDateOfBirth;
    if (newPassword != null) password = newPassword;
    if (newConfirmPassword != null) confirmPassword = newConfirmPassword;
    notifyListeners();
  }

  Future<bool> registerUser() async {
    _state = RegisterState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (dateOfBirth == null) throw Exception('Data de Nascimento não selecionada.');

      final success = await _authService.register(
        fullName: fullName.trim(),
        cpf: cpf,
        dateOfBirth: dateOfBirth!,
        email: email.trim(),
        password: password,
      );

      if (success) {
        _state = RegisterState.success;
      } else {
        _state = RegisterState.error;
        _errorMessage = 'O E-mail ou CPF já estão cadastrados.';
      }
    } catch (e) {
      _state = RegisterState.error;
      _errorMessage = 'Erro ao processar o cadastro: $e';
    }

    notifyListeners();
    return _state == RegisterState.success;
  }
}