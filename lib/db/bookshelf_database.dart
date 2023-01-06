import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bookshelf/model/shelf.dart';
import 'package:bookshelf/model/book.dart';

import '../model/author.dart';

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
        db.execute(
          '''
          CREATE TABLE shelves(id INTEGER PRIMARY KEY, name TEXT NOT NULL);
          ''',
        );
        db.execute(
          '''
          CREATE TABLE books(id INTEGER PRIMARY KEY, shelf_id INTEGER, title TEXT NOT NULL, cover BLOB NOT NULL, author_id INTEGER NOT NULL, n_pages INTEGER NOT NULL, release_date INTEGER NOT NULL, language TEXT NOT NULL, reading_status INTEGER NOT NULL, started_reading_date INTEGER, ended_reading_date INTEGER);
          ''',
        );
        db.execute(
          '''
          CREATE TABLE authors(id INTEGER PRIMARY KEY, first_name TEXT NOT NULL, last_name NOT NULL);
          ''',
        );
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 6,
    );
  }

  // SHELF FUNCTIONS
  Future<void> createShelf(Shelf shelve) async {
    final db = await instance.database;

    await db.insert(
      'shelves',
      shelve.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> updateShelf(Shelf shelf) async {
    // Get a reference to the database.
    final db = await instance.database;

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
    final db = await instance.database;

    // Remove the Shelf from the database.
    await db.delete(
      'shelves',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Shelf's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<int> getShelfLength(int id) async {
    // Get a reference to the database.
    final db = await instance.database;

    final List<Map<String, dynamic>> maps =
        await db.query('books', where: 'shelf_id = ?', whereArgs: [id]);

    return maps.length;
  }

  // BOOK FUNCTIONS
  Future<void> createBook(Book book) async {
    final db = await instance.database;

    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> updateBook(Book book) async {
    // Get a reference to the database.
    final db = await instance.database;

    // Update the given Shelf.
    await db.update(
      'books',
      book.toMap(),
      // Ensure that the Shelf has a matching id.
      where: 'id = ?',
      // Pass the Shelf's id as a whereArg to prevent SQL injection.
      whereArgs: [book.id],
    );
  }

  Future<List<Book>> loadAllBooks() async {
    final db = await instance.database;

    // Query the table for all the Shelves
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      orderBy: 'release_date',
    );

    // Convert the List<Map<String, dynamic> into a List<Shelves>
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        shelfId: maps[i]['shelf_id'],
        title: maps[i]['title'],
        cover: maps[i]['cover'],
        authorId: maps[i]['author_id'],
        nPages: maps[i]['n_pages'],
        releaseDateTimestamp: maps[i]['release_date'],
        language: maps[i]['language'],
        startedReadingDateTimestamp: maps[i]['started_reading_date'],
        endedReadingDateTimestamp: maps[i]['ended_reading_date'],
        readingStatus: maps[i]['reading_status'],
      );
    });
  }

  Future<Book> loadBook(int id) async {
    final db = await instance.database;

    // Query the table for all the Shelves
    final maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book(
        id: maps[0]['id'] as int?,
        shelfId: maps[0]['shelf_id'] as int?,
        title: maps[0]['title'] as String,
        cover: maps[0]['cover'] as Uint8List,
        authorId: maps[0]['author_id'] as int,
        nPages: maps[0]['n_pages'] as int,
        releaseDateTimestamp: maps[0]['release_date'] as int,
        language: maps[0]['language'] as String,
        startedReadingDateTimestamp: maps[0]['started_reading_date'] as int?,
        endedReadingDateTimestamp: maps[0]['ended_reading_date'] as int?,
        readingStatus: maps[0]['reading_status'] as int,
      );
    } else {
      throw Exception("Access error : No book with given id");
    }
  }

  Future<List<Book>> loadBooksByAuthor(int authorId) async {
    final db = await instance.database;

    // Query the table for all the Books
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'author_id = ?',
      whereArgs: [authorId],
      orderBy: 'release_date',
    );

    // Convert the List<Map<String, dynamic> into a List<Books>
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        shelfId: maps[i]['shelf_id'],
        authorId: maps[i]['author_id'],
        title: maps[i]['title'],
        cover: maps[i]['cover'],
        nPages: maps[i]['n_pages'],
        releaseDateTimestamp: maps[i]['release_date'],
        language: maps[i]['language'],
        startedReadingDateTimestamp: maps[i]['started_reading_date'],
        endedReadingDateTimestamp: maps[i]['ended_reading_date'],
        readingStatus: maps[i]['reading_status'],
      );
    });
  }

  Future<List<Book>> loadBooksByShelf(int shelfId) async {
    final db = await instance.database;

    // Query the table for all the Books
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'shelf_id = ?',
      whereArgs: [shelfId],
      orderBy: 'release_date',
    );

    // Convert the List<Map<String, dynamic> into a List<Books>
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        shelfId: maps[i]['shelf_id'],
        authorId: maps[i]['author_id'],
        title: maps[i]['title'],
        cover: maps[i]['cover'],
        nPages: maps[i]['n_pages'],
        releaseDateTimestamp: maps[i]['release_date'],
        language: maps[i]['language'],
        startedReadingDateTimestamp: maps[i]['started_reading_date'],
        endedReadingDateTimestamp: maps[i]['ended_reading_date'],
        readingStatus: maps[i]['reading_status'],
      );
    });
  }

  Future<void> deleteBook(int id) async {
    // Get a reference to the database.
    final db = await instance.database;

    // Remove the Shelf from the database.
    await db.delete(
      'books',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Shelf's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // AUTHOR FUNCTIONS
  Future<int> createAuthor(Author author) async {
    final db = await instance.database;

    return await db.insert(
      'authors',
      author.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Author>> loadAllAuthors() async {
    final db = await instance.database;

    // Query the table for all the Authors
    final List<Map<String, dynamic>> maps = await db.query(
      'authors',
      orderBy: 'last_name',
    );

    // Convert the List<Map<String, dynamic> into a List<Author>
    return List.generate(maps.length, (i) {
      return Author(
        id: maps[i]['id'],
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
      );
    });
  }

  Future<Author> loadAuthor(int id) async {
    final db = await instance.database;

    // Query the table for all the Authors
    final maps = await db.query(
      'authors',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Author(
        id: maps[0]['id'] as int?,
        firstName: maps[0]['first_name'] as String,
        lastName: maps[0]['last_name'] as String,
      );
    } else {
      throw Exception("Access error : No author with given id");
    }
  }

  Future<void> deleteAuthor(int id) async {
    // Get a reference to the database.
    final db = await instance.database;

    // Remove the Author from the database.
    await db.delete(
      'authors',
      // Use a `where` clause to delete a specific author.
      where: 'id = ?',
      // Pass the Author's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
