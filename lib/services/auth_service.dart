// lib/services/auth_service.dart
import 'package:analisador_texto_completo/models/user.dart';
import 'package:analisador_texto_completo/services/database_service.dart';
import 'package:analisador_texto_completo/services/hash_service.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService();

  User? _currentUser; 
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    final user = await _dbService.getUserByEmail(email);

    if (user != null) {
      final providedHash = HashService.hashPassword(password);
      
      if (providedHash == user.hashedPassword) {
        _currentUser = user; 
        return true;
      }
    }
    _currentUser = null;
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String cpf,
    required DateTime dateOfBirth,
    required String email,
    required String password,
  }) async {
    final hashedPassword = HashService.hashPassword(password);

    final newUser = User(
      fullName: fullName,
      cpf: cpf,
      dateOfBirth: dateOfBirth,
      email: email,
      hashedPassword: hashedPassword,
    );

    try {
      await _dbService.insertUser(newUser);
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
  }
}