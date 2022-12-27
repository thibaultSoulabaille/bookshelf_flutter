import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bookshelf/model/shelf.dart';

class BookShelfDatabase {
  // instance of shelve database
  static final BookShelfDatabase instance = BookShelfDatabase._init();

  static Database? _database;

  // private constructor
  BookShelfDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bookshelf.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), filePath),

      // When the database is first created, create a table to store shelves.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE shelves(id INTEGER PRIMARY KEY, name TEXT NOT NULL)',
        );
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> createShelf(Shelf shelve) async {
    final db = await instance.database;

    await db.insert(
      'shelves',
      shelve.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateShelf(Shelf shelf) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Shelf.
    await db.update(
      'shelves',
      shelf.toMap(),
      // Ensure that the Shelf has a matching id.
      where: 'id = ?',
      // Pass the Shelf's id as a whereArg to prevent SQL injection.
      whereArgs: [shelf.id],
    );
  }

  Future<List<Shelf>> loadAllShelves() async {
    final db = await instance.database;

    // Query the table for all the Shelves
    final List<Map<String, dynamic>> maps = await db.query(
      'shelves',
      orderBy: 'name',
    );

    // Convert the List<Map<String, dynamic> into a List<Shelves>
    return List.generate(maps.length, (i) {
      return Shelf(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<Shelf> loadShelve(int id) async {
    final db = await instance.database;

    // Query the table for all the Shelves
    final maps = await db.query(
      'shelves',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Shelf(
        id: maps[0]['id'] as int?,
        name: maps[0]['name'] as String,
      );
    } else {
      throw Exception("Access error : No shelve with given id");
    }
  }

  Future<void> deleteShelf(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Shelf from the database.
    await db.delete(
      'shelves',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Shelf's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
