import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/resena.dart';

class RecetaDb {
  RecetaDb._();
  static final RecetaDb instancia = RecetaDb._();
  static const _nombreArchivo = 'misrecetas.db';
  static const _tabla = 'resenas';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recetaId INTEGER NOT NULL UNIQUE,
            texto TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // guarda la reseña (si la receta ya tenía una, la reemplaza)
  Future<int> guardar(Resena resena) async {
    final db = await _database;
    return db.insert(
      _tabla,
      resena.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // busca la reseña de una receta (null si no tiene)
  Future<Resena?> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'recetaId = ?',
      whereArgs: [recetaId],
    );
    if (filas.isEmpty) return null;
    return Resena.fromMap(filas.first);
  }
}