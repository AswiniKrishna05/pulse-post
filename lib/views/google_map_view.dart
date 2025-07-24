import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({Key? key}) : super(key: key);

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  LatLng? _currentPosition;
  GoogleMapController? _mapController;
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  final LatLng _destination = const LatLng(37.43296265331129, -122.08832357078792); // Example destination
  Stream<Position>? _positionStream;
  static const String _googleApiKey = 'YOUR_DIRECTIONS_API_KEY'; // <-- Replace with your Directions API key
  LatLng? _lastAnimatedPosition;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _initForegroundTask();
    _startForegroundTask();
    _listenToLocationChanges();
  }

  void _listenToLocationChanges() async {
    // Get initial position
    await _determinePosition();
    // Listen to location changes
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    );
    _positionStream!.listen((Position position) {
      final newLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = newLatLng;
      });
      _getPolyline();
      if (_mapReady && (_lastAnimatedPosition == null || _distance(_lastAnimatedPosition!, newLatLng) > 2)) {
        _animateCameraWithEffect(newLatLng, position.heading);
        _lastAnimatedPosition = newLatLng;
      }
    });
  }

  void _startForegroundTask() {
    print('Starting foreground task...');
    FlutterForegroundTask.startService(
      notificationTitle: 'Tracking Location',
      notificationText: 'Your movement is being tracked',
    );
  }



  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_channel_id',
        channelName: 'Location Tracking',
        channelDescription: 'Tracking your movement in the background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }




  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _getPolyline();
    _animateCamera(_currentPosition!);
  }

  Future<void> _getPolyline() async {
    if (_currentPosition == null) return;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _googleApiKey,
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      PointLatLng(_destination.latitude, _destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 6,
            points: _polylineCoordinates,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            jointType: JointType.round,
          ),
        };
      });
    }
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

  double _distance(LatLng a, LatLng b) {
    const double earthRadius = 6371000; // meters
    final dLat = (b.latitude - a.latitude) * pi / 180.0;
    final dLng = (b.longitude - a.longitude) * pi / 180.0;

    final sindLat = sin(dLat / 2);
    final sindLng = sin(dLng / 2);

    final va = sindLat * sindLat +
        sindLng * sindLng *
            cos(a.latitude * pi / 180.0) *
            cos(b.latitude * pi / 180.0);
    final vc = 2 * asin(sqrt(va));
    return earthRadius * vc;
  }


  Future<void> _animateCameraWithEffect(LatLng target, double bearing) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: 18,
            tilt: 70,
            bearing: bearing,
          ),
        ),
      );
    }
  }

  void _openInAppleMaps() async {
    if (_currentPosition == null) return;
    final url = 'http://maps.apple.com/?saddr=${_currentPosition!.latitude},${_currentPosition!.longitude}&daddr=${_destination.latitude},${_destination.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    FlutterForegroundTask.stopService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        actions: [
          if (Platform.isIOS)
            IconButton(
              icon: const Icon(Icons.map),
              tooltip: 'Open in Apple Maps',
              onPressed: _openInAppleMaps,
            ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 17,
                tilt: 60,
                bearing: 90,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: _currentPosition!,
                  infoWindow: const InfoWindow(title: 'You are here'),
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: _destination,
                  infoWindow: const InfoWindow(title: 'Destination'),
                ),
              },
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
                _mapReady = true;
                if (_currentPosition != null) {
                  _animateCameraWithEffect(_currentPosition!, 90);
                  _lastAnimatedPosition = _currentPosition!;
                }
              },
            ),
    );
  }
} 