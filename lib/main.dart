import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'data/model/perma.dart';
import 'data/repositories/area_repository.dart';
import 'data/repositories/garden_repository.dart';
import 'data/repositories/plant_repository.dart';
import 'data/services/database_service.dart';
import 'ui/view_models/widgets/area_screen.dart';
import 'ui/view_models/widgets/garden_screen.dart';
import './data/plants.dart' as plants_data;
import 'ui/view_models/widgets/plant_screen.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Open the database and store the reference.
  final path = join(await getDatabasesPath(), 'perma_database.db');
  await deleteDatabase(path);
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    path,
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      //db.transaction((txn) async {
      //UML: Garden 1 --- * Area * --- 0 Plant * --- 1 Advisor
      //ddl: cardinality: 1 --- * means one to many, * --- 1 means many to one, * --- * means many to many (additional table to store the relationship)
      db.execute('CREATE TABLE gardens(id INTEGER PRIMARY KEY)');
      db.execute(
        'CREATE TABLE areas(id INTEGER PRIMARY KEY, garden_id INTEGER, FOREIGN KEY(garden_id) REFERENCES gardens(id))',
      );
      db.execute(
        'CREATE TABLE areas_plants(area_id INTEGER, plant_id INTEGER, PRIMARY KEY(area_id, plant_id), FOREIGN KEY(area_id) REFERENCES areas(id), FOREIGN KEY(plant_id) REFERENCES plants(id))',
      );
      db.execute(
        'CREATE TABLE plants(id INTEGER PRIMARY KEY, name TEXT, icon TEXT, family TEXT, type TEXT, size INTEGER, growth_type TEXT, root_type TEXT, leaf_type TEXT, sun_exposure TEXT, watering TEXT, sowing_period TEXT, creeping INTEGER, melliferous INTEGER, parasite_attack INTEGER, nitrogen INTEGER, anti_parasite INTEGER, nutrient_rich INTEGER)',
      );
      db.execute(
        'CREATE TABLE advices(id INTEGER PRIMARY KEY, advice TEXT, plantId INTEGER, FOREIGN KEY(plantId) REFERENCES plant(id))',
      );
      for (var plant in plants_data.plants) {
        db.insert(
          'plants',
          plant.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        //db.execute('INSERT INTO plants (name, icon, family, type, size, growth_type, root_type, leaf_type, sun_exposure, watering, sowing_period, creeping, melliferous, parasite_attack, nitrogen, anti_parasite, nutrient_rich, advices) VALUES($plant.name, $plant.icon, $plant.family, $plant.type, $plant.size, $plant.growthType, $plant.rootType, $plant.leafType, $plant.sunExposure, $plant.watering, $plant.sowingPeriod, $plantCreeping, $isMelliferous, $isParasiteAttackRisk, $isNitrogenInput, $isAntiParasite, $isNutrientRich, $plant.advices)');
      }
      // });
      db.insert(
        'gardens',
        Garden(id: 1).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => DatabaseService(database: database)),
        Provider(create: (context) => GardenRepository(databaseService: context.read())),
        Provider(create: (context) => AreaRepository(databaseService: context.read())),
        Provider(create: (context) => PlantRepository(databaseService: context.read()))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                GardenScreen(title: 'Welcome to your garden'),
          ),
          GoRoute(
            path: '/area',
            builder: (context, state) => AreaScreen(areaIndex: state.pathParameters['areaIndex'] != null ? int.parse(state.pathParameters['areaIndex']!) : 0, areaId: state.pathParameters['areaId'] != null ? int.parse(state.pathParameters['areaId']!) : 0),
          ),
          GoRoute(
            path: '/plant',
            builder: (context, state) => PlantScreen(plantId: state.pathParameters['plantId'] != null ? int.parse(state.pathParameters['plantId']!) : 0, areaId: state.pathParameters['areaId'] != null ? int.parse(state.pathParameters['areaId']!) : 0),
          ),
        ],
      ),
    );
  }
}
