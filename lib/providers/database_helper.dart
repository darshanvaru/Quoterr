import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quote.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quotes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE bookmarks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quote TEXT,
            author TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertQuote(Quote quote) async {
    final db = await database;
    await db.insert('bookmarks', quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Quote>> getBookmarkedQuotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');

    return List.generate(maps.length, (i) {
      return Quote.fromMap(maps[i]); // Use the fromMap method here
    });
  }

  Future<void> deleteQuote(Quote quote) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'quote = ? AND author = ?',
      whereArgs: [quote.quote, quote.author],
    );
  }
}
