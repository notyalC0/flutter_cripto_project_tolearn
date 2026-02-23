import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart';

class DB {
// construtor com acesso privado
  DB._();
// criar instancia do DB
  static final DB instance = DB._();
// instancia do sqlite
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cripto_v2.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int versao) async {
    await db.execute(_conta);
    await db.execute(_carteira);
    await db.execute(_historico);
    // garante que existe uma linha na conta
    await db.insert('conta', {'saldo': 0.0});
  }

  String get _conta => '''
CREATE TABLE conta (
id INTEGER PRIMARY KEY AUTOINCREMENT,
saldo REAL
)
''';

  String get _carteira => '''
CREATE TABLE carteira (
sigla TEXT PRIMARY KEY,
moeda TEXT,
quantidade TEXT

)
''';

  String get _historico => '''
CREATE TABLE historico (
id INTEGER PRIMARY KEY AUTOINCREMENT,
data_operacao INTEGER,
tipo_operacao TEXT,
moeda TEXT,
sigla TEXT,
valor REAL,
quantidade TEXT
)
''';
}
