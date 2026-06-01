import '../models/medicamento.dart';
import '../db/app_database.dart';
import 'medicamento_repository.dart';

class LocalMedicamentoRepository implements MedicamentoRepository {
  @override
  Future<List<Medicamento>> buscarTodos() => buscarMedicamentos();

  @override
  Future<void> salvar(Medicamento medicamento) async {
    await salvarMedicamento(medicamento);
  }

  @override
  Future<void> atualizar(Medicamento medicamento) async {
    await atualizarMedicamento(medicamento);
  }

  @override
  Future<void> deletar(int id) => deletarMedicamento(id);
}
