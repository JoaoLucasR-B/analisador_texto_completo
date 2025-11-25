// lib/views/tela_cadastro.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:analisador_texto_completo/viewmodels/register_viewmodel.dart';
import 'package:analisador_texto_completo/views/tela_login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);
    
    if (viewModel.state == RegisterState.error && viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage!), backgroundColor: Colors.red),
        );
      });
    }

    if (viewModel.state == RegisterState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso! Faça o Login.'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator())); 
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre-se'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome Completo'),
                validator: viewModel.validateFullName,
                onChanged: (value) => viewModel.updateField(newFullName: value),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 15),

              TextFormField(
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                inputFormatters: [cpfMaskFormatter],
                validator: viewModel.validateCpf,
                onChanged: (value) => viewModel.updateField(newCpf: value),
              ),
              const SizedBox(height: 15),

              _buildDateOfBirthField(viewModel),
              const SizedBox(height: 15),

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
              const SizedBox(height: 10),

              _buildPasswordValidationCheckboxes(viewModel),
              const SizedBox(height: 15),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmação de Senha'),
                obscureText: _obscurePassword,
                validator: viewModel.validateConfirmPassword,
                onChanged: (value) => viewModel.updateField(newConfirmPassword: value),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: viewModel.isFormValid && viewModel.state != RegisterState.loading
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          await viewModel.registerUser();
                        }
                      }
                    : null,
                child: viewModel.state == RegisterState.loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Cadastrar'),
              ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text("Já tem conta? Faça Login", style: TextStyle(color: Colors.blueGrey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField(RegisterViewModel viewModel) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: viewModel.dateOfBirth ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != viewModel.dateOfBirth) {
          viewModel.updateField(newDateOfBirth: pickedDate);
          _formKey.currentState?.validate();
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data de Nascimento',
          border: OutlineInputBorder(),
        ),
        child: Text(
          viewModel.dateOfBirth == null
              ? 'Selecione a Data'
              : DateFormat('dd/MM/yyyy').format(viewModel.dateOfBirth!),
          style: TextStyle(
            color: viewModel.dateOfBirth == null ? Colors.grey : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordValidationCheckboxes(RegisterViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: viewModel.passwordValidationRules.entries.map((entry) {
        final String rule = entry.key;
        final bool isValid = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isValid ? Colors.green : Colors.red,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(rule, style: TextStyle(color: isValid ? Colors.green : Colors.red)),
            ],
          ),
        );
      }).toList(),
    );
  }
}