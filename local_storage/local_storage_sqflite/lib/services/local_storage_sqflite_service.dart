import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Singleton class, so that no other instance of the class can be created.
class LocalStorageSqfliteService {
  static final _instance = LocalStorageSqfliteService._internal();

  LocalStorageSqfliteService._internal();

  static Future<void> getDatabasePath() async {
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
  }
}
