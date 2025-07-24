import 'dart:math';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../core/database/app_db.dart';

import '../viewmodels/location_view_model.dart';
import 'route_history_screen.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({Key? key}) : super(key: key);

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  LatLng? _currentPosition;
  GoogleMapController? _mapController;
  bool _mapReady = false;
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    // Removed simulatePath for real live tracking
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _animateCamera(_currentPosition!);
  }

  void _animateCamera(LatLng target) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: 17,
            tilt: 60,
            bearing: 90,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Route History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RouteHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 17,
                    tilt: 60,
                    bearing: 90,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    if (vm.routePoints.isNotEmpty)
                      Marker(
                        markerId: const MarkerId('start'),
                        position: vm.routePoints.first,
                        infoWindow: const InfoWindow(title: 'Start'),
                      ),
                    if (vm.routePoints.length > 1)
                      Marker(
                        markerId: const MarkerId('end'),
                        position: vm.routePoints.last,
                        infoWindow: const InfoWindow(title: 'End'),
                      ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('user_path'),
                      color: Colors.blue,
                      width: 6,
                      points: vm.routePoints,
                    ),
                  },
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _mapReady = true;
                    if (_currentPosition != null) {
                      _animateCamera(_currentPosition!);
                    }
                  },
                ),
                if (_showSaveButton)
                  Positioned(
                    bottom: 90,
                    left: 16,
                    right: 16,
                    child: SizedBox.shrink(), // Remove Save Route button
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (vm.isTracking) {
            vm.pauseTracking();
            // Automatically save the route when paused
            if (vm.routePoints.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No route points to save!')),
              );
            } else {
              final now = DateTime.now();
              final db = AppDatabase();
              final pathJson = jsonEncode(vm.routePoints.map((e) => {'lat': e.latitude, 'lng': e.longitude}).toList());
              print('Saving route with points:  {vm.routePoints}');
              print('Serialized pathJson:  {pathJson}');
              print('Route start time:  ${vm.routeStartTime}, end time:  ${now}, distance:  ${vm.totalDistance}');
              final id = await db.insertRoute(RoutesCompanion(
                name: Value('My Route  0{now.toIso8601String()}'),
                startTime: Value(vm.routeStartTime ?? now),
                endTime: Value(now),
                distance: Value(vm.totalDistance),
                pathJson: Value(pathJson),
              ));
              print('Inserted route with id:  {id}');
              vm.clearRoute();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Route saved!')),
              );
            }
            setState(() {
              _showSaveButton = false;
            });
          } else {
            vm.startTracking();
            setState(() {
              _showSaveButton = false;
            });
          }
        },
        icon: Icon(vm.isTracking ? Icons.pause : Icons.play_arrow),
        label: Text(vm.isTracking ? 'Pause Tracking' : 'Resume Tracking'),
      ),
    );
  }
} 