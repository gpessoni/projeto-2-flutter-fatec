import '../models/medicamento.dart';
import '../services/api_service.dart';
import 'medicamento_repository.dart';

class ApiMedicamentoRepository implements MedicamentoRepository {
  @override
  Future<List<Medicamento>> buscarTodos() => buscarMedicamentosApi();

  @override
  Future<void> salvar(Medicamento medicamento) async {
    await salvarMedicamentoApi(medicamento);
  }

  @override
  Future<void> atualizar(Medicamento medicamento) async {
    await atualizarMedicamentoApi(medicamento);
  }

  @override
  Future<void> deletar(int id) => deletarMedicamentoApi(id);
}
