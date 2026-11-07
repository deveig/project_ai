import '../model/perma.dart';
import '../services/database_service.dart';

class GardenRepository {
  GardenRepository({required DatabaseService databaseService}) : _databaseService = databaseService;
  late final DatabaseService _databaseService;
  Future<void> saveGarden(Garden garden) {
    return _databaseService.insertGarden(garden);
  }
  // Future<Garden?> updateGarden(Garden garden) {}
  Future<Garden?> getGarden() {
    return _databaseService.getGarden();
  }
}
