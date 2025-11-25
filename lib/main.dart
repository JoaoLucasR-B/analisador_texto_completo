// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:analisador_texto_completo/services/auth_service.dart';
import 'package:analisador_texto_completo/services/database_service.dart';
import 'package:analisador_texto_completo/viewmodels/register_viewmodel.dart';
import 'package:analisador_texto_completo/viewmodels/login_viewmodel.dart';
import 'package:analisador_texto_completo/viewmodels/main_viewmodel.dart';
import 'package:analisador_texto_completo/views/tela_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const TextAnalyzerApp());
}

class TextAnalyzerApp extends StatelessWidget {
  const TextAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services (Objetos Únicos/Singleton)
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<AuthService>(create: (context) => AuthService()),
        
        // ViewModels (ChangeNotifier - Gerenciadores de Estado)
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<RegisterViewModel>(
          create: (context) => RegisterViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<MainViewModel>(
          create: (_) => MainViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Analisador de Texto Completo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const LoginScreen(), 
      ),
    );
  }
}