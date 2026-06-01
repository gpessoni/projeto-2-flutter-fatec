import '../models/medicamento.dart';

abstract class MedicamentoRepository {
  Future<List<Medicamento>> buscarTodos();
  Future<void> salvar(Medicamento medicamento);
  Future<void> atualizar(Medicamento medicamento);
  Future<void> deletar(int id);
}
