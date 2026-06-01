import 'package:flutter/material.dart';
import 'medicamento/lista.dart';
import '../data/app_settings.dart';
import '../repository/local_medicamento_repository.dart';
import '../services/api_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _sincronizando = false;

  Future<void> _sincronizar() async {
    setState(() => _sincronizando = true);
    try {
      final locais = await LocalMedicamentoRepository().buscarTodos();
      await sincronizarMedicamentosApi(locais);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sincronização concluída!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao sincronizar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sincronizando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Medicamentos')),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade300,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication_liquid,
                        color: Colors.white, size: 72),
                    SizedBox(height: 12),
                    Text(
                      'MedControl',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Controle seus medicamentos',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _FeatureItem(
                    nome: 'Medicamentos',
                    icone: Icons.medication,
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListaMedicamentos(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: AppSettings.useApi,
                      builder: (context, useApi, _) => SwitchListTile(
                        title: const Text('Fonte de dados'),
                        subtitle: Text(
                            useApi ? 'API remota' : 'Armazenamento local'),
                        secondary: Icon(
                          useApi ? Icons.cloud : Icons.storage,
                          color: Colors.blue.shade900,
                        ),
                        value: useApi,
                        onChanged: (value) =>
                            AppSettings.useApi.value = value,
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          Icon(Icons.sync, color: Colors.blue.shade900),
                      title: const Text('Sincronizar local → API'),
                      subtitle:
                          const Text('Envia dados locais para a nuvem'),
                      trailing: _sincronizando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey.shade600),
                      onTap: _sincronizando ? null : _sincronizar,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String nome;
  final IconData icone;
  final void Function() onClick;

  const _FeatureItem({
    required this.nome,
    required this.icone,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 120,
          width: 120,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
