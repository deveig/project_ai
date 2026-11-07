import '../../data/model/perma.dart';
import '../../data/repositories/plant_repository.dart';

class PlantViewModel {
  PlantViewModel({required PlantRepository plantRepository}) : _plantRepository = plantRepository;
  late final PlantRepository _plantRepository;
  
  Future<void> savePlant(Plant plant) async {
    try {
      await _plantRepository.savePlant(plant);
    } catch (e) {
      throw Exception('Failed to create plant: $e');
    }
  }
  Future<List<Plant?>> getAllPlants() async {
    return _plantRepository.getAllPlants();
  }
  Future<List<Plant?>?> getPlantsByAreaId(int areaId) {
    return _plantRepository.getPlantsByAreaId(areaId);
  }
  Future<void> deletePlantInArea(Plant plant, int areaId) async {
    try {
      await _plantRepository.deletePlantInArea(plant, areaId);
    } catch (e) {
      throw Exception('Failed to delete plant in area: $e');
    }
  }
  Future<Plant?> getPlantById(int plantId) {
    return _plantRepository.getPlantById(plantId);
  }
  Future<List<Plant?>?> getPlantsByCriteria(String criteria) {
    return _plantRepository.getPlantsByCriteria(criteria);
  }
}