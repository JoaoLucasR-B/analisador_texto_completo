// lib/views/tela_login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:analisador_texto_completo/viewmodels/login_viewmodel.dart';
import 'package:analisador_texto_completo/views/tela_cadastro.dart';
import 'package:analisador_texto_completo/views/tela_principal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    if (viewModel.state == LoginState.error && viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage!), backgroundColor: Colors.red),
        );
      });
    }

    if (viewModel.state == LoginState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator())); 
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: viewModel.validateEmail,
                onChanged: (value) => viewModel.updateField(newEmail: value),
              ),
              const SizedBox(height: 15),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: viewModel.validatePassword,
                onChanged: (value) => viewModel.updateField(newPassword: value),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: viewModel.isFormValid && viewModel.state != LoginState.loading
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus(); 
                          viewModel.loginUser();
                        }
                      }
                    : null,
                child: viewModel.state == LoginState.loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Entrar'),
              ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text("Ainda não tem conta? Cadastre-se", style: TextStyle(color: Colors.blueGrey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}