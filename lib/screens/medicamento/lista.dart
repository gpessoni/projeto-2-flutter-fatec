import 'package:flutter/material.dart';
import '../../models/medicamento.dart';
import '../../data/app_settings.dart';
import 'formulario.dart';

class ListaMedicamentos extends StatefulWidget {
  const ListaMedicamentos({super.key});

  @override
  State<ListaMedicamentos> createState() => _ListaMedicamentosState();
}

class _ListaMedicamentosState extends State<ListaMedicamentos> {
  late Future<List<Medicamento>> _futuro;

  @override
  void initState() {
    super.initState();
    _carregar();
    AppSettings.useApi.addListener(_carregar);
  }

  @override
  void dispose() {
    AppSettings.useApi.removeListener(_carregar);
    super.dispose();
  }

  void _carregar() {
    setState(() {
      _futuro = AppSettings.repository.buscarTodos();
    });
  }

  Future<void> _toggleTomado(Medicamento medicamento) async {
    medicamento.tomado = !medicamento.tomado;
    try {
      await AppSettings.repository.atualizar(medicamento);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
    _carregar();
  }

  Future<void> _deletar(Medicamento medicamento) async {
    if (medicamento.id == null) return;
    try {
      await AppSettings.repository.deletar(medicamento.id!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: AppSettings.useApi,
          builder: (_, useApi, __) => Text(
            useApi ? 'Medicamentos (API)' : 'Medicamentos (Local)',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      body: FutureBuilder<List<Medicamento>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Erro ao carregar:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final medicamentos = snapshot.data ?? [];
          if (medicamentos.isEmpty) {
            return const Center(child: Text('Nenhum medicamento encontrado.'));
          }

          return ListView.builder(
            itemCount: medicamentos.length,
            itemBuilder: (context, index) {
              final medicamento = medicamentos[index];
              final sequencial = index + 1;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: medicamento.tomado
                        ? Colors.green
                        : Colors.blue.shade900,
                    child: Text(
                      '$sequencial',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    medicamento.nome,
                    style: TextStyle(
                      decoration: medicamento.tomado
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${medicamento.dosagem} — ${medicamento.horario}'),
                      if (medicamento.observacoes != null &&
                          medicamento.observacoes!.isNotEmpty)
                        Text(
                          medicamento.observacoes!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  isThreeLine: medicamento.observacoes != null &&
                      medicamento.observacoes!.isNotEmpty,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletar(medicamento),
                  ),
                  onTap: () => _toggleTomado(medicamento),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const FormularioMedicamento()),
          );
          _carregar();
        },
      ),
    );
  }
}
