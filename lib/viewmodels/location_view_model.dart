import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ziya_project/repository/location_repository.dart';

import '../core/database/app_db.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationRepository repository;
  LocationViewModel(this.repository);

  String currentRouteId = "default_route";
  List<LatLng> routePoints = [];

  Stream<List<LocationPoint>>? _stream;

  void startListeningToRoute() {
    _stream = repository.watchRoute(currentRouteId);
    _stream!.listen((data) {
      routePoints = data
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      notifyListeners();
    });
  }

  Future<void> saveLocation(double lat, double lng) async {
    await repository.insertLocation(lat, lng, currentRouteId);
  }
}
