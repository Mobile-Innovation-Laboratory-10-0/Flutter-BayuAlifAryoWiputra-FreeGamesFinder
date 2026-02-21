import 'package:free_games_finder/app/data/models/favorite_mode.dart';
// import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorites(
      gameId INTEGER PRIMARY KEY,
      title TEXT,
      thumbnail TEXT,
      genre TEXT,
      playDate TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');
  }

  Future<int> insertFavorite(FavoriteModel favorite) async {
    final db = await instance.database;
    return await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateFavorite(FavoriteModel favorite) async {
    final db = await instance.database;
    return await db.update(
      'favorites',
      favorite.toMap(),
      where: 'gameId = ?',
      whereArgs: [favorite.gameId],
    );
  }

  Future<int> deleteFavorite(int id) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'gameId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }

  // Future<bool> isFavorite(int id) async {
  //   final db = await instance.database;
  //   final result = await db.query(
  //     'favorites',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //   return result.isNotEmpty;
  // }
}
