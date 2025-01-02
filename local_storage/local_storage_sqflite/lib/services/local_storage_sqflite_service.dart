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
}
