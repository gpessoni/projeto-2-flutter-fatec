import 'package:flutter/foundation.dart';
import '../repository/medicamento_repository.dart';
import '../repository/local_medicamento_repository.dart';
import '../repository/api_medicamento_repository.dart';

class AppSettings {
  AppSettings._();

  static final ValueNotifier<bool> useApi = ValueNotifier(false);

  static MedicamentoRepository get repository =>
      useApi.value ? ApiMedicamentoRepository() : LocalMedicamentoRepository();
}
