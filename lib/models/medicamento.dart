class Medicamento {
  final int? id;
  final String nome;
  final String dosagem;
  final String horario;
  bool tomado;
  final String? observacoes;

  Medicamento(
    this.nome,
    this.dosagem,
    this.horario, {
    this.id,
    this.tomado = false,
    this.observacoes,
  });

  // SQLite → objeto
  factory Medicamento.fromMap(Map<String, dynamic> map) {
    final m = Medicamento(
      (map['nome'] as String?) ?? '',
      (map['dosagem'] as String?) ?? '',
      (map['horario'] as String?) ?? '',
      id: map['id'] as int?,
      observacoes: map['observacoes'] as String?,
    );
    m.tomado = map['tomado'] == 1;
    return m;
  }

  // objeto → SQLite (sem id, autoincrement)
  Map<String, dynamic> toMap() => {
        'nome': nome,
        'dosagem': dosagem,
        'horario': horario,
        'tomado': tomado ? 1 : 0,
        'observacoes': observacoes,
      };

  // API JSON → objeto
  factory Medicamento.fromJson(Map<String, dynamic> json) {
    final m = Medicamento(
      (json['nome'] as String?) ?? '',
      (json['dosagem'] as String?) ?? '',
      (json['horario'] as String?) ?? '',
      id: json['id'] as int?,
      observacoes: json['observacoes'] as String?,
    );
    m.tomado = (json['tomado'] as bool?) ?? false;
    return m;
  }

  // objeto → API JSON
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        'dosagem': dosagem,
        'horario': horario,
        'tomado': tomado,
        if (observacoes != null && observacoes!.isNotEmpty)
          'observacoes': observacoes,
      };

  @override
  String toString() =>
      'Medicamento{id: $id, nome: $nome, dosagem: $dosagem, horario: $horario, tomado: $tomado, observacoes: $observacoes}';
}
