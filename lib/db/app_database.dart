import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import '../models/medicamento.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'medicines.db');
  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute('''
        create table medicamentos(
          id integer primary key autoincrement,
          nome text,
          dosagem text,
          horario text,
          tomado integer,
          observacoes text
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
            'ALTER TABLE medicamentos ADD COLUMN observacoes text');
      }
    },
    version: 2,
  );
}

Future<int> salvarMedicamento(Medicamento medicamento) async {
  final Database db = await getDatabase();
  return db.insert('medicamentos', medicamento.toMap());
}

Future<int> atualizarMedicamento(Medicamento medicamento) async {
  final Database db = await getDatabase();
  return db.update(
    'medicamentos',
    medicamento.toMap(),
    where: 'id = ?',
    whereArgs: [medicamento.id],
  );
}

Future<List<Medicamento>> buscarMedicamentos() async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> resultado = await db.query('medicamentos');
  return resultado.map((map) => Medicamento.fromMap(map)).toList();
}

Future<void> deletarMedicamento(int id) async {
  final Database db = await getDatabase();
  await db.delete('medicamentos', where: 'id = ?', whereArgs: [id]);
}

Future<void> testarBanco() async {
  final String path = join(await getDatabasesPath(), 'medicines.db');
  final File arquivoBanco = File(path);
  final bool existe = await arquivoBanco.exists();
  if (existe) {
    print('****Banco de dados encontrado: $path');
    final Database db = await openDatabase(path);
    final List<Map<String, dynamic>> tabelas = await db
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    if (tabelas.isNotEmpty) {
      for (var tabela in tabelas) {
        print('- ${tabela['name']}');
      }
    } else {
      print('****Nenhuma tabela encontrada no banco.');
    }
    await db.close();
  } else {
    print('XXXX - O arquivo do banco de dados não foi encontrado em: $path');
  }
}
