// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:analisador_texto_completo/services/auth_service.dart';

enum LoginState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  LoginState _state = LoginState.idle;
  String? _errorMessage;

  LoginState get state => _state;
  String? get errorMessage => _errorMessage;

  String email = '';
  String password = '';

  LoginViewModel(this._authService);

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  void updateField({String? newEmail, String? newPassword}) {
    if (newEmail != null) email = newEmail;
    if (newPassword != null) password = newPassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'E-mail é obrigatório.';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória.';
    return null;
  }

  Future<bool> loginUser() async {
    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.login(email.trim(), password);
      
      if (success) {
        _state = LoginState.success;
      } else {
        _state = LoginState.error;
        _errorMessage = 'E-mail ou senha incorretos.';
      }
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = 'Ocorreu um erro: $e';
    }

    notifyListeners();
    return _state == LoginState.success;
  }
}