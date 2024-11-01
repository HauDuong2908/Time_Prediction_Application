import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseWeather {
  static Database? _db;
  static final DatabaseWeather intance = DatabaseWeather._constructor();

  final String _tableName = 'WeatherDatabase';
  final String id = 'id';
  final String weatherStateName = 'weatherStateName';
  final String temperature = 'temperature';
  final String maxTemp = 'maxTemp';
  final String humidity = 'humidity';
  final String winSpeed = 'winSpeed';
  final String dateTime = 'datetime';

  DatabaseWeather._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "DATE_TIME.db");
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute("CREATE TABLE $_tableName("
            " id INTEGER PRIMARY KEY,"
            "$weatherStateName TEXT, "
            "$temperature INTEGER, "
            " $maxTemp INTEGER, "
            " $humidity INTEGER,"
            " $winSpeed INTEGER,"
            " $dateTime DATETIME"
            ")");
      },
    );
    return database;
  }
}
