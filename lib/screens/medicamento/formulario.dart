import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/medicamento.dart';
import '../../data/app_settings.dart';

class FormularioMedicamento extends StatefulWidget {
  const FormularioMedicamento({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormularioMedicamentoState();
  }
}

class FormularioMedicamentoState extends State<FormularioMedicamento> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorDosagem = TextEditingController();
  final TextEditingController _controladorHorario = TextEditingController();
  final TextEditingController _controladorObservacoes =
      TextEditingController();

  static const _tituloAppBar = 'Novo Medicamento';
  static const _rotuloNome = 'Nome do Medicamento';
  static const _dicaNome = 'Ex: Dipirona';
  static const _rotuloDosagem = 'Dosagem';
  static const _dicaDosagem = 'Ex: 500mg';
  static const _rotuloHorario = 'Horário';
  static const _dicaHorario = 'Ex: 08:00';
  static const _rotuloObservacoes = 'Observações';
  static const _dicaObservacoes = 'Anotações opcionais';
  static const _textBotaoConfirmar = 'Adicionar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_tituloAppBar)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorNome,
              rotulo: _rotuloNome,
              dica: _dicaNome,
              icone: Icons.medication,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorDosagem,
              rotulo: _rotuloDosagem,
              dica: _dicaDosagem,
              icone: Icons.local_pharmacy,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorHorario,
              rotulo: _rotuloHorario,
              dica: _dicaHorario,
              icone: Icons.schedule,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorObservacoes,
              rotulo: _rotuloObservacoes,
              dica: _dicaObservacoes,
              icone: Icons.notes,
              tipoTeclado: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _criaMedicamento(context),
                child: const Text(_textBotaoConfirmar),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _criaMedicamento(BuildContext context) async {
    final String nome = _controladorNome.text;
    final String dosagem = _controladorDosagem.text;
    final String horario = _controladorHorario.text;
    final String observacoes = _controladorObservacoes.text;

    if (nome.isNotEmpty && dosagem.isNotEmpty && horario.isNotEmpty) {
      final medicamento = Medicamento(
        nome,
        dosagem,
        horario,
        observacoes: observacoes.isEmpty ? null : observacoes,
      );

      try {
        await AppSettings.repository.salvar(medicamento);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Medicamento adicionado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Preencha nome, dosagem e horário.')),
      );
    }
  }
}
