import 'package:sqflite/sqflite.dart';

import '../model/perma.dart';

class DatabaseService {

  DatabaseService({required this.database});

  final Future<Database> database;
  
  // Define a function that inserts gardens into the database
  Future<void> insertGarden(Garden garden) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Garden into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same garden is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'gardens',
      garden.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves a garden by id from the gardens table.
  Future<Garden?> getGarden() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for a garden by id.
    final List<Map<String, Object?>> gardenMaps = await db.query('gardens');
    return Garden(id: gardenMaps.first['id'] as int);
  }
}