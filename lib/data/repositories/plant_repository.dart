import '../model/perma.dart';
import '../services/database_service.dart';

class PlantRepository {
  PlantRepository({required DatabaseService databaseService}) : _databaseService = databaseService;
  late final DatabaseService _databaseService;
  Future<void> savePlant(Plant plant) async {
    return _databaseService.insertPlant(plant);
  }
  Future<Plant?> getPlantById(int plantId) async {
    return _databaseService.getPlantById(plantId);
  }
  Future<List<Plant?>?>getPlantsByAreaId(int areaId) async {
    return _databaseService.getPlantsByAreaId(areaId);
  }
  Future<List<Plant?>> getAllPlants() async {
    return _databaseService.getAllPlants();
  }
  Future<void> deletePlantInArea(Plant plant, int areaId) async {
    return _databaseService.deletePlantInArea(plant, areaId);
  }
  Future<List<Plant?>?> getPlantsByCriteria(String criteria) {
    return _databaseService.getPlantsByCriteria(criteria);
  }
}