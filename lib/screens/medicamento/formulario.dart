import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/medicamento.dart';
import '../../data/app_settings.dart';

class FormularioMedicamento extends StatefulWidget {
  final Medicamento? medicamento;

  const FormularioMedicamento({super.key, this.medicamento});

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

  bool get _editando => widget.medicamento != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      _controladorNome.text = widget.medicamento!.nome;
      _controladorDosagem.text = widget.medicamento!.dosagem;
      _controladorHorario.text = widget.medicamento!.horario;
      _controladorObservacoes.text = widget.medicamento!.observacoes ?? '';
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorDosagem.dispose();
    _controladorHorario.dispose();
    _controladorObservacoes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Medicamento' : 'Novo Medicamento'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorNome,
              rotulo: 'Nome do Medicamento',
              dica: 'Ex: Dipirona',
              icone: Icons.medication,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorDosagem,
              rotulo: 'Dosagem',
              dica: 'Ex: 500mg',
              icone: Icons.local_pharmacy,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorHorario,
              rotulo: 'Horário',
              dica: 'Ex: 08:00',
              icone: Icons.schedule,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorObservacoes,
              rotulo: 'Observações',
              dica: 'Anotações opcionais',
              icone: Icons.notes,
              tipoTeclado: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _confirmar(context),
                child: Text(_editando ? 'Salvar' : 'Adicionar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmar(BuildContext context) async {
    final String nome = _controladorNome.text;
    final String dosagem = _controladorDosagem.text;
    final String horario = _controladorHorario.text;
    final String observacoes = _controladorObservacoes.text;

    if (nome.isEmpty || dosagem.isEmpty || horario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, dosagem e horário.')),
      );
      return;
    }

    try {
      if (_editando) {
        final atualizado = Medicamento(
          nome,
          dosagem,
          horario,
          id: widget.medicamento!.id,
          tomado: widget.medicamento!.tomado,
          observacoes: observacoes.isEmpty ? null : observacoes,
        );
        await AppSettings.repository.atualizar(atualizado);
      } else {
        final novo = Medicamento(
          nome,
          dosagem,
          horario,
          observacoes: observacoes.isEmpty ? null : observacoes,
        );
        await AppSettings.repository.salvar(novo);
      }

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }
}
