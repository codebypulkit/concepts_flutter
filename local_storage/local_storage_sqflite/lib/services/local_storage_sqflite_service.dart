import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Singleton class, so that no other instance of the class can be created.
class LocalStorageSqfliteService {
  // Created literal variables as these would be referred multiple times.
  final _tasksTableName = "tasks";
  final _tasksIdColumnName = "id";
  final _tasksContentColumnName = "content";
  final _tasksStatusColumnName = "status";

  Database? _database;

  static final instance = LocalStorageSqfliteService._internal();

  LocalStorageSqfliteService._internal();

  Future<Database> getDatabase() async {
    _database ??= await getDatabasePath();
    return _database!;
  }

  Future<Database> getDatabasePath() async {
    // First we will choose where our database is going to be stored.
    // So first we fetch the path of the database directory.
    final databaseDirectoryPath = await getDatabasesPath();

    // Then we will construct the complete path of the database file.
    // This includes the path of the database directory and the name of the database file.
    // We will use the join function from the path package to combine the path of the database directory and the name of the database file.
    final databaseFilePath = join(databaseDirectoryPath, "my_database.db");

    // Next we will use the sqflite package to open our database.
    // But with just the line below, the database wouldn't work as we want it to.
    // because for now the db doesn't have a defined schema and doesn't have
    // any tables within it. So even if we have opened it, we can't use it.

    //-> final database = await openDatabase(databaseFilePath);

    final database = await openDatabase(
      databaseFilePath,
      version: 1,
      // onCreate helps us define the logic that would be executed, when the db
      // initially gets created.
      onCreate: (db, version) {
        // Execute an SQL query with no return value.
        db.execute('''
          CREATE TABLE $_tasksTableName (
            $_tasksIdColumnName INTEGER PRIMARY KEY,
            $_tasksContentColumnName TEXT NOT NULL,
            $_tasksStatusColumnName INTEGER NOT NULL
          )
        ''');
      },
    );
    return database;
  }

  // Operation : INSERT
  Future<void> write({required String content}) async {
    final db = await getDatabase();

    // We use the insert method on the db instance, it accepts the table name
    // and then a map where the key in the map corresponds to the table col
    // and the value is what is to be inserted in the cell of the specified col.
    // Note: Since we are not specifying an id explicitly, even though we have an
    // id column, that is a PRIMARY KEY field, SQLite would auto increment
    // the id starting from 1 and so on. Because the id column is PRIMARY KEY
    // it would do so, else it would have left it as NULL.
    // Also, db.insert returns the id.
    await db.insert(_tasksTableName, {
      _tasksContentColumnName: content,
      _tasksStatusColumnName:
          0, // By default considering that task is not done.
    });
  }

  // Operation : READ (query)
  Future<List<Map<String, Object?>>> read() async {
    final db = await getDatabase();

    // The query method is used to read data from the table that has been passed
    // in the method's argument.
    // The query method returns a list, that contains all the records in key value maps
    // column name is the key and the record is the value.
    final data = await db.query(_tasksTableName);

    // We can also pass conditions where we want to query specific data from the database.
    await db.query(_tasksTableName, where: 'id = ?', whereArgs: [2]);

    return data;
  }

  // Operation : UPDATE (update)
  Future<void> update(int id) async {
    final db = await getDatabase();

    // By default the update method would run for all the records in the table
    // passed to it.
    // It takes a Map<String, Object?> as the second positional argument, which
    // key specifies the column of the record and the value is the new value that
    // would be put in place.
    // await db.update(_tasksTableName, {"content": "Hello World!"});

    // Since we do not want to update all the records we pass the where argument.
    // The statement below would update the content value of the record whose id is
    // the id passed from outside.
    await db.update(
      _tasksTableName,
      {"content": "Hello World"},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
