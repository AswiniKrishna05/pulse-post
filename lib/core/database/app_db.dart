import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_db.g.dart';

@DataClassName('LocationPoint')
class LocationPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get routeId => text()();
}

// New table for routes
@DataClassName('RouteEntry')
class Routes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  RealColumn get distance => real()();
  TextColumn get pathJson => text()(); // Store the list of LatLng as JSON
}

@DriftDatabase(tables: [LocationPoints, Routes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Insert new point
  Future<int> insertPoint(LocationPointsCompanion entry) =>
      into(locationPoints).insert(entry);

  // Watch all points of a route
  Stream<List<LocationPoint>> watchPointsByRoute(String routeId) =>
      (select(locationPoints)..where((tbl) => tbl.routeId.equals(routeId)))
          .watch();

  // Insert a new route
  Future<int> insertRoute(RoutesCompanion entry) =>
      into(routes).insert(entry);

  // Get all routes
  Future<List<RouteEntry>> getAllRoutes() => select(routes).get();

  // Delete a route by id
  Future<int> deleteRoute(int id) => (delete(routes)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
    return NativeDatabase(file);
  });
}
