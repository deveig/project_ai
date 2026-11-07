import '../../data/model/perma.dart';
import '../../data/repositories/area_repository.dart';

class AreaViewModel {
  AreaViewModel({required AreaRepository areaRepository}) : _areaRepository = areaRepository;
  late final AreaRepository _areaRepository;
  
  Future<void> saveArea(Area area) async {
    try {
      await _areaRepository.saveArea(area);
    } catch (e) {
      throw Exception('Failed to create area: $e');
    }
  }
  Future<List<Area>?> getAreasByGardenId(int gardenId) {
    return _areaRepository.getAreasByGardenId(gardenId);
  }
  Future<void> deleteArea(Area area) {
    return _areaRepository.deleteArea(area);
  }
  Future<void> addPlantToArea(int areaId, int plantId) async {
    try {
      await _areaRepository.addPlantToArea(areaId, plantId);
    } catch (e) {
      throw Exception('Failed to add plant to area: $e');
    }
  }
  Future<List<Plant?>?> getAreaPlantsByAreaId(int areaId) {
    return _areaRepository.getAreaPlantsByAreaId(areaId);
  }
}