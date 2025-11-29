import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/agendamento.dart';

class DatabaseService {
  static Database? _db;

  ///Retorna a instância do banco de dados
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  ///Inicializa o banco e cria a tabela se necessário
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pharma_scheduler.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE agendamentos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descricao TEXT,
            data TEXT NOT NULL,
            tipo TEXT NOT NULL,
            local TEXT
          )
        ''');
      },
    );
  }

  ///CREATE - adiciona um novo agendamento
  static Future<int> addAgendamento({
    required String titulo,
    required String descricao,
    required DateTime data,
    required String tipo,
    String? local,
  }) async {
    final db = await database;
    return await db.insert('agendamentos', {
      'titulo': titulo,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'tipo': tipo,
      'local': local,
    });
  }

  ///READ - retorna todos os agendamentos como objetos
  static Future<List<Agendamento>> getAgendamentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('agendamentos', orderBy: 'data ASC');

    return List.generate(maps.length, (i) {
      return Agendamento.fromMap(maps[i]);
    });
  }

  ///UPDATE - atualiza um agendamento existente
  static Future<void> updateAgendamento({
    required int id,
    required String titulo,
    required String descricao,
    required DateTime data,
    required String tipo,
    String? local,
  }) async {
    final db = await database;
    await db.update(
      'agendamentos',
      {
        'titulo': titulo,
        'descricao': descricao,
        'data': data.toIso8601String(),
        'tipo': tipo,
        'local': local,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///DELETE - remove um agendamento pelo ID
  static Future<void> deleteAgendamento(int id) async {
    final db = await database;
    await db.delete('agendamentos', where: 'id = ?', whereArgs: [id]);
  }
}