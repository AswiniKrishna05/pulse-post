import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ziya_project/repository/location_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../core/database/app_db.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationRepository repository;
  LocationViewModel(this.repository);

  String currentRouteId = "default_route";
  List<LatLng> routePoints = [];

  // Tracking state and metadata
  bool isTracking = false;
  DateTime? routeStartTime;
  DateTime? routeEndTime;

  StreamSubscription<Position>? _positionStream;

  void startTracking() {
    isTracking = true;
    routeStartTime = DateTime.now();
    routeEndTime = null;
    routePoints.clear();
    notifyListeners();

    // Start listening to real-time location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      routePoints.add(LatLng(position.latitude, position.longitude));
      notifyListeners();
      // Optionally save to DB:
      // saveLocation(position.latitude, position.longitude);
    });
  }

  void pauseTracking() {
    isTracking = false;
    routeEndTime = DateTime.now();
    _positionStream?.cancel();
    _positionStream = null;
    notifyListeners();
  }

  void resumeTracking() {
    isTracking = true;
    routeEndTime = null;
    notifyListeners();
  }

  void clearRoute() {
    routePoints.clear();
    routeStartTime = null;
    routeEndTime = null;
    notifyListeners();
  }

  double get totalDistance {
    if (routePoints.length < 2) return 0.0;
    double total = 0.0;
    for (int i = 1; i < routePoints.length; i++) {
      total += _haversine(routePoints[i - 1], routePoints[i]);
    }
    return total;
  }

  double _haversine(LatLng p1, LatLng p2) {
    const R = 6371000; // Earth radius in meters
    final dLat = _deg2rad(p2.latitude - p1.latitude);
    final dLon = _deg2rad(p2.longitude - p1.longitude);
    final a = 
      (sin(dLat / 2) * sin(dLat / 2)) +
      cos(_deg2rad(p1.latitude)) *
      cos(_deg2rad(p2.latitude)) *
      (sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (3.141592653589793 / 180.0);

  // Commented out for now: DB sync is not used for live tracking
  // void startListeningToRoute() {
  //   _stream = repository.watchRoute(currentRouteId);
  //   _stream!.listen((data) {
  //     routePoints = data
  //         .map((point) => LatLng(point.latitude, point.longitude))
  //         .toList();
  //     notifyListeners();
  //   });
  // }

  Future<void> saveLocation(double lat, double lng) async {
    await repository.insertLocation(lat, lng, currentRouteId);
  }
}
