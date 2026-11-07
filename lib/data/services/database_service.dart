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

  // Define a function that inserts areas into the database
  Future<void> insertArea(Area area) async {
    // Get a reference to the database.
    final db = await database;
    await db.insert(
      'areas',
      area.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves areas of garden by id.
  Future<List<Area>?> getAreaByGardenId(int gardenId) async {
    // Get a reference to the database.
    final db = await database;
    final List<Map<String, Object?>> areasMaps = await db.query('areas', where: "garden_id = ?", whereArgs: [gardenId]);
    return areasMaps.map((a) => Area.fromJson(a)).toList();
  }

  // A method that deletes an area
  Future<void> deleteArea(Area area) async {
    final db = await database;
    await db.delete('areas', where: "id = ?", whereArgs: [area.id]);
  }

  Future<void> addPlantToArea(int areaId, int plantId) async {
    final db = await database;
    // Get the area by id
    await db.insert(
      'areas_plants',
      {'area_id': areaId, 'plant_id': plantId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Plant?>?> getAreaPlantsByAreaId(int areaId) async {
    final db = await database;
    final List<Map<String, Object?>> areaPlantsMaps = await db.rawQuery('SELECT * FROM plants JOIN areas_plants ON plants.id = areas_plants.plant_id WHERE areas_plants.area_id = ?', [areaId]);// Debugging line to check the retrieved area maps
    return areaPlantsMaps.isNotEmpty ? areaPlantsMaps.map((p) => Plant(
      id: p['id'] as int,
      name: p['name'] as String,
      icon: p['icon'] as String,
      family: p['family'] as String,
      type: PlantType.values.firstWhere((v) => v.toString() == p['type'] as String),
      size: p['size'] as int,
      growthType: p['growth_type'] as String,
      rootType: p['root_type'] as String,
      leafType: p['leaf_type'] as String,
      sunExposure: p['sun_exposure'] as String,
      watering: p['watering'] as String,
      sowingPeriod: p['sowing_period'] as String,
      creeping: p['creeping'] as int == 1 ? true : false,
      isMelliferous: p['melliferous'] as int == 1 ? true : false,
      isParasiteAttackRisk: p['parasite_attack'] as int == 1 ? true : false,
      isAntiParasite: p['anti_parasite'] as int == 1 ? true : false,
      isNitrogenInput: p['nitrogen'] as int == 1 ? true : false,
      isNutrientRich: p['nutrient_rich'] as int == 1 ? true : false,
      advices: (p['advices'] as List<Advisor>?) != null ? List<Advisor>.from(p['advices'] as List<Advisor>) : [],
    )).toList() : null;
  }

  Future<void> insertPlant(Plant plant) async {
    // Get a reference to the database.
    final db = await database;
    await db.insert(
      'plants',
      plant.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves a plant by id from the plants table.
  Future<Plant?> getPlantById(int plantId) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for a plant by id.
    final List<Map<String, Object?>> plantMaps = await db.query('plants', where: "id = ?", whereArgs: [plantId]);
    return plantMaps.isNotEmpty ? Plant(
      id: plantMaps.first['id'] as int,
      name: plantMaps.first['name'] as String,
      icon: plantMaps.first['icon'] as String,
      family: plantMaps.first['family'] as String,
      type: PlantType.values.firstWhere((v) => v.toString() == plantMaps.first['type'] as String),
      size: plantMaps.first['size'] as int,
      growthType: plantMaps.first['growth_type'] as String,
      rootType: plantMaps.first['root_type'] as String,
      leafType: plantMaps.first['leaf_type'] as String,
      sunExposure: plantMaps.first['sun_exposure'] as String,
      watering: plantMaps.first['watering'] as String,
      sowingPeriod: plantMaps.first['sowing_period'] as String,
      creeping: plantMaps.first['creeping'] as int == 1 ? true : false,
      isMelliferous: plantMaps.first['melliferous'] as int == 1 ? true : false,
      isParasiteAttackRisk: plantMaps.first['parasite_attack'] as int == 1 ? true : false,
      isAntiParasite: plantMaps.first['anti_parasite'] as int == 1 ? true : false,
      isNitrogenInput: plantMaps.first['nitrogen'] as int == 1 ? true : false,
      isNutrientRich: plantMaps.first['nutrient_rich'] as int == 1 ? true : false,
      advices: (plantMaps.first['advices'] as List<Advisor>?) != null ? List<Advisor>.from(plantMaps.first['advices'] as List<Advisor>) : [],
    ) : null;
  }

  // A method that retrieves all plants from the plants table.
  Future<List<Plant?>> getAllPlants() async {
    // Get a reference to the database.
    final db = await database;
    // Query the table for all plants.
    final List<Map<String, Object?>> plantMaps = await db.query('plants');
    return plantMaps.map((p) => Plant(
      id: p['id'] as int,
      name: p['name'] as String,
      icon: p['icon'] as String,
      family: p['family'] as String,
      type: PlantType.values.firstWhere((v) => v.toString() == p['type'] as String),
      size: p['size'] as int,
      growthType: p['growth_type'] as String,
      rootType: p['root_type'] as String,
      leafType: p['leaf_type'] as String,
      sunExposure: p['sun_exposure'] as String,
      watering: p['watering'] as String,
      sowingPeriod: p['sowing_period'] as String,
      creeping: p['creeping'] as int == 1 ? true : false,
      isMelliferous: p['melliferous'] as int == 1 ? true : false,
      isParasiteAttackRisk: p['parasite_attack'] as int == 1 ? true : false,
      isAntiParasite: p['anti_parasite'] as int == 1 ? true : false,
      isNitrogenInput: p['nitrogen'] as int == 1 ? true : false,
      isNutrientRich: p['nutrient_rich'] as int == 1 ? true : false,
      advices: (p['advices'] as List<Advisor>?) != null ? List<Advisor>.from(p['advices'] as List<Advisor>) : [],
    )).toList();
  }

  Future<List<Plant?>> getPlantsByCriteria(String criteria) async {
    // Get a reference to the database.
    final db = await database;
    // Query the table for all plants.
    final List<Map<String, Object?>> plantMaps = await db.query('plants', where: "type = ?", whereArgs: ['PlantType.$criteria']);
    return plantMaps.map((p) => Plant(
      id: p['id'] as int,
      name: p['name'] as String,
      icon: p['icon'] as String,
      family: p['family'] as String,
      type: PlantType.values.firstWhere((v) => v.toString() == p['type'] as String),
      size: p['size'] as int,
      growthType: p['growth_type'] as String,
      rootType: p['root_type'] as String,
      leafType: p['leaf_type'] as String,
      sunExposure: p['sun_exposure'] as String,
      watering: p['watering'] as String,
      sowingPeriod: p['sowing_period'] as String,
      creeping: p['creeping'] as int == 1 ? true : false,
      isMelliferous: p['melliferous'] as int == 1 ? true : false,
      isParasiteAttackRisk: p['parasite_attack'] as int == 1 ? true : false,
      isAntiParasite: p['anti_parasite'] as int == 1 ? true : false,
      isNitrogenInput: p['nitrogen'] as int == 1 ? true : false,
      isNutrientRich: p['nutrient_rich'] as int == 1 ? true : false,
      advices: (p['advices'] as List<Advisor>?) != null ? List<Advisor>.from(p['advices'] as List<Advisor>) : [],
    )).toList();
  }

  Future<List<Plant?>?> getPlantsByAreaId(int areaId) async {
    final db = await database;
    final List<Map<String, Object?>> areaPlantsMaps = await db.rawQuery('SELECT * FROM plants JOIN areas_plants ON plants.id = areas_plants.plant_id WHERE area_id = ?', [areaId]);
    return areaPlantsMaps.isNotEmpty ? areaPlantsMaps.map((p) => Plant(
      id: p['id'] as int,
      name: p['name'] as String,
      icon: p['icon'] as String,
      family: p['family'] as String,
      type: PlantType.values.firstWhere((v) => v.toString() == p['type'] as String),
      size: p['size'] as int,
      growthType: p['growth_type'] as String,
      rootType: p['root_type'] as String,
      leafType: p['leaf_type'] as String,
      sunExposure: p['sun_exposure'] as String,
      watering: p['watering'] as String,
      sowingPeriod: p['sowing_period'] as String,
      creeping: p['creeping'] as int == 1 ? true : false,
      isMelliferous: p['melliferous'] as int == 1 ? true : false,
      isParasiteAttackRisk: p['parasite_attack'] as int == 1 ? true : false,
      isAntiParasite: p['anti_parasite'] as int == 1 ? true : false,
      isNitrogenInput: p['nitrogen'] as int == 1 ? true : false,
      isNutrientRich: p['nutrient_rich'] as int == 1 ? true : false,
      advices: (p['advices'] as List<Advisor>?) != null ? List<Advisor>.from(p['advices'] as List<Advisor>) : [],
    )).toList() : null;
  }

  // A method that deletes a plant by id from the plants table.
  Future<void> deletePlantInArea(Plant plant, int areaId) async {
    final db = await database;
    await db.delete('areas_plants', where: "plant_id = ? AND area_id = ?", whereArgs: [plant.id, areaId]);
  }
}