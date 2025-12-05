// lib/views/tela_principal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:analisador_texto_completo/services/auth_service.dart';
import 'package:analisador_texto_completo/viewmodels/main_viewmodel.dart';
import 'package:analisador_texto_completo/views/tela_login.dart';
import 'package:analisador_texto_completo/views/tela_resultados.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainVM = Provider.of<MainViewModel>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final userName = authService.currentUser?.fullName.split(' ').first ?? 'Usuário';

    if (authService.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisador de Texto'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair/Logout',
            onPressed: () {
              authService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Bem-vindo, $userName! 👋',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
              ),
            ),
            
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        TextField(
                          controller: mainVM.textController,
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Digite ou cole seu texto aqui...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: mainVM.textController,
                            builder: (context, value, child) {
                              if (value.text.isEmpty) return const SizedBox.shrink();
                              return IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: mainVM.clearText,
                                tooltip: 'Limpar texto',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    // O botão está sempre habilitado para clicarmos
                    child: ElevatedButton(
                      onPressed: () {
                          // 1. Chamar o ViewModel para processar o texto
                          mainVM.analyzeText(mainVM.textController.text);
                          
                          // 2. Verificar se o resultado é nulo (texto estava vazio)
                          if (mainVM.analyzerResult != null) {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ResultScreen(
                                          result: mainVM.analyzerResult!,
                                      ),
                                  ),
                              );
                          } else {
                              // 3. Se estiver vazio, mostra a mensagem (SnackBar)
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Por favor, insira algum texto para analisar.'),
                                      backgroundColor: Colors.red,
                                  ),
                              );
                          }
                      },
                      child: const Text('Analisar Texto'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            const Expanded(
              flex: 1,
              child: Center(
                child: Text('Análise pronta para ser iniciada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}