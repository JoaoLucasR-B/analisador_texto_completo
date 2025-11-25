// lib/views/tela_resultados.dart
import 'package:flutter/material.dart';
import 'package:analisador_texto_completo/viewmodels/main_viewmodel.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Análise'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultados da Análise:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const Divider(height: 30),

            _buildStatCard(
              title: 'Estatísticas de Leitura',
              children: [
                _buildStatRow('Tempo Estimado de Leitura:', result.readingTime),
                _buildStatRow('Total de Palavras:', result.totalWordCount.toString()),
                _buildStatRow('Total de Frases:', result.sentenceCount.toString()),
              ],
            ),
            const SizedBox(height: 16),

            _buildStatCard(
              title: 'Contagem de Caracteres',
              children: [
                _buildStatRow('Com espaços:', result.charCountWithSpaces.toString()),
                _buildStatRow('Sem espaços:', result.charCountWithoutSpaces.toString()),
                _buildStatRow('Apenas Letras:', result.letterCount.toString()),
                _buildStatRow('Apenas Dígitos:', result.digitCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}