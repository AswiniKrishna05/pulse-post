import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/database/app_db.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class RouteHistoryScreen extends StatefulWidget {
  @override
  _RouteHistoryScreenState createState() => _RouteHistoryScreenState();
}

class _RouteHistoryScreenState extends State<RouteHistoryScreen> {
  late final AppDatabase db;
  late Future<List<RouteEntry>> _routesFuture;

  Future<void> deleteDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
    if (await file.exists()) {
      await file.delete();
      print('Database deleted!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database deleted! Please restart the app.')),
      );
      setState(() {
        _routesFuture = db.getAllRoutes();
      });
    } else {
      print('Database file does not exist.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database file does not exist.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    db = AppDatabase(); // Or use your singleton/provider if you have one
    _routesFuture = db.getAllRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route History')),
      body: FutureBuilder<List<RouteEntry>>(
        future: _routesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No routes tracked yet.'));
          }
          final routes = snapshot.data!;
          return ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              final duration = route.endTime.difference(route.startTime);
              final distance = route.distance;
              return ListTile(
                title: Text("My Route ${route.startTime.toIso8601String()}"),
                subtitle: Text(
                  "Start: ${route.startTime}\n"
                  "End: ${route.endTime}\n"
                  "Duration: ${duration.inMinutes} min\n"
                  "Distance: ${distance.toStringAsFixed(2)} m",
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RouteDetailScreen(route: route),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: () async {
                    await db.deleteRoute(route.id);
                    setState(() {
                      _routesFuture = db.getAllRoutes();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await deleteDatabaseFile();
        },
        icon: Icon(Icons.delete_forever),
        label: Text('Delete DB'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class RouteDetailScreen extends StatelessWidget {
  final RouteEntry route;
  const RouteDetailScreen({required this.route});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> points = jsonDecode(route.pathJson);
    final List<LatLng> path = points
        .map((e) => LatLng((e['lat'] as num).toDouble(), (e['lng'] as num).toDouble()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(route.name)),
      body: path.isEmpty
          ? Center(child: Text('No path data'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: path.first,
                zoom: 16,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  color: Colors.blue,
                  width: 5,
                  points: path,
                ),
              },
              markers: {
                if (path.isNotEmpty)
                  Marker(
                    markerId: MarkerId('start'),
                    position: path.first,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  ),
                if (path.length > 1)
                  Marker(
                    markerId: MarkerId('end'),
                    position: path.last,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  ),
              },
            ),
    );
  }
} 