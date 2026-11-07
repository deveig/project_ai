import '../../data/model/perma.dart';
import '../../data/repositories/garden_repository.dart';

class GardenViewModel {
  GardenViewModel({required GardenRepository gardenRepository}) : _gardenRepository = gardenRepository;
  late final GardenRepository _gardenRepository;

  Future<Garden?> load() async {
    try {
      return await _gardenRepository.getGarden();
    } catch (e) {
      throw Exception('Failed to load garden: $e');
    }
  }

  Future<void> saveGarden(Garden garden) async {
    try {
      return await _gardenRepository.saveGarden(garden);
    } catch (e) {
      throw Exception('Failed to create garden: $e');
    }
  }
}