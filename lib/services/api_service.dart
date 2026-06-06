import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicamento.dart';

const _baseUrl = 'https://projeto-flutter-fatec-api.onrender.com';

Future<List<Medicamento>> buscarMedicamentosApi() async {
  final response = await http.get(Uri.parse('$_baseUrl/medicamentos'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((e) => Medicamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  throw Exception('Erro ${response.statusCode} ao buscar medicamentos.');
}

Future<Medicamento> salvarMedicamentoApi(Medicamento medicamento) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/medicamentos'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(medicamento.toJson()),
  );
  if (response.statusCode == 201 || response.statusCode == 200) {
    try {
      return Medicamento.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      throw Exception('Resposta inesperada da API: ${response.body}');
    }
  }
  throw Exception('Erro ${response.statusCode} ao salvar: ${response.body}');
}

Future<Medicamento> atualizarMedicamentoApi(Medicamento medicamento) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/medicamentos/${medicamento.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(medicamento.toJson()),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    try {
      return Medicamento.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      throw Exception('Resposta inesperada da API: ${response.body}');
    }
  }
  throw Exception('Erro ${response.statusCode} ao atualizar: ${response.body}');
}

Future<void> deletarMedicamentoApi(int id) async {
  final response =
      await http.delete(Uri.parse('$_baseUrl/medicamentos/$id'));
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception('Erro ${response.statusCode} ao deletar medicamento.');
  }
}

Future<List<Medicamento>> sincronizarMedicamentosApi(
    List<Medicamento> medicamentos) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/medicamentos/sincronizar'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'medicamentos': medicamentos.map((m) => m.toJson()).toList()}),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    final decoded = jsonDecode(response.body);
    final List<dynamic> data =
        decoded is List ? decoded : (decoded as Map<String, dynamic>)['medicamentos'] as List<dynamic>;
    return data
        .map((e) => Medicamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  throw Exception('Erro ${response.statusCode} ao sincronizar: ${response.body}');
}
