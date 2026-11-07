import '../model/perma.dart';
import '../services/database_service.dart';

class AreaRepository {
  AreaRepository({required DatabaseService databaseService}) : _databaseservice = databaseService;
  late final DatabaseService _databaseservice;
  Future<void> saveArea(Area area) async {
    await _databaseservice.insertArea(area);
  }
  Future<List<Area>?> getAreasByGardenId(int gardenId){
    return _databaseservice.getAreaByGardenId(gardenId);
  }
  Future<void> deleteArea(Area area){
    return _databaseservice.deleteArea(area);
  }
  Future<void> addPlantToArea(int areaId, int plantId) async {
    try {
      await _databaseservice.addPlantToArea(areaId, plantId);
    } catch (e) {
      throw Exception('Failed to add plant to area: $e');
    }
  }
  Future<List<Plant?>?> getAreaPlantsByAreaId(int areaId) {
    return _databaseservice.getAreaPlantsByAreaId(areaId);
  }
}