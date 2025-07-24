import '../core/database/app_db.dart';

class LocationRepository {
  final AppDatabase db;
  LocationRepository(this.db);

  Future<void> insertLocation(double lat, double lng, String routeId) async {
    await db.insertPoint(LocationPointsCompanion.insert(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      routeId: routeId,
    ));
  }

  Stream<List<LocationPoint>> watchRoute(String routeId) {
    return db.watchPointsByRoute(routeId);
  }
}
