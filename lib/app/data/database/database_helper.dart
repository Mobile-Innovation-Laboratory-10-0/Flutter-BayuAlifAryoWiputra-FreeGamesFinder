import 'package:free_games_finder/app/data/models/favorite_mode.dart';
import 'package:free_games_finder/app/data/models/plan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('free_games_v5  .db'); 
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorites(
      gameId INTEGER,
      username TEXT,
      title TEXT,
      thumbnail TEXT,
      genre TEXT,
      createdAt TEXT,
      updatedAt TEXT,
      PRIMARY KEY (gameId, username) 
    )
    ''');

    await db.execute('''
    CREATE TABLE plans(
      gameId INTEGER,
      username TEXT,
      title TEXT,
      thumbnail TEXT,
      genre TEXT,
      playDate TEXT,
      createdAt TEXT,
      PRIMARY KEY (gameId, username)
    )
    ''');

    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      password TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE comments(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      gameId INTEGER,
      username TEXT,
      comment TEXT,
      createdAt TEXT
    )
    ''');
  }

  // ================= FAVORITES =================
  Future<int> insertFavorite(FavoriteModel favorite) async {
    final db = await instance.database;
    return await db.insert('favorites', favorite.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteFavorite(int gameId, String username) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'gameId = ? AND username = ?', whereArgs: [gameId, username]);
  }

  Future<List<Map<String, dynamic>>> getFavorites(String username) async {
    final db = await instance.database;
    return await db.query('favorites', where: 'username = ?', whereArgs: [username]);
  }

  // ================= PLANS =================
  Future<int> insertPlan(PlanModel plan) async {
    final db = await instance.database;
    return await db.insert('plans', plan.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deletePlan(int gameId, String username) async {
    final db = await instance.database;
    return await db.delete('plans', where: 'gameId = ? AND username = ?', whereArgs: [gameId, username]);
  }

  Future<List<Map<String, dynamic>>> getPlans(String username) async {
    final db = await instance.database;
    return await db.query('plans', where: 'username = ?', whereArgs: [username], orderBy: 'playDate ASC');
  }

  Future<int> updatePlanDate(int gameId, String username, String newDate) async {
    final db = await instance.database;
    return await db.update(
      'plans', 
      {'playDate': newDate}, 
      where: 'gameId = ? AND username = ?', 
      whereArgs: [gameId, username]
    );
  }

  // ================= AUTH & COMMENTS =================
  Future<int> registerUser(String username, String password) async {
    final db = await instance.database;
    try {
      return await db.insert('users', {'username': username, 'password': password});
    } catch (e) {
      return -1; 
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> addComment(int gameId, String username, String comment) async {
    final db = await instance.database;
    return await db.insert('comments', {'gameId': gameId, 'username': username, 'comment': comment, 'createdAt': DateTime.now().toIso8601String()});
  }

  Future<List<Map<String, dynamic>>> getCommentsByGame(int gameId) async {
    final db = await instance.database;
    return await db.query('comments', where: 'gameId = ?', whereArgs: [gameId], orderBy: 'createdAt DESC');
  }
}