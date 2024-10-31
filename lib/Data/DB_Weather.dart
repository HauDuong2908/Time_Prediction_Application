import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class db {
  final int id;
  final String weatherStateName;
  final int temperature;
  final int maxTemp;
  final int humidity;
  final int winSpeed;

  db(this.id, this.weatherStateName, this.temperature, this.maxTemp,
      this.humidity, this.winSpeed);

  void db_weather() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'Date_Time.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE Weather(id INTEGER PRIMARY KEY, weatherStateName TEXT, temperature INTEGER, maxTemp INTEGER, humidity INTEGER, winSpeed INTEGER)');
      },
      version: 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'weatherStateName': weatherStateName,
      'temperature': temperature,
      'maxTemp': maxTemp,
      'humidity': humidity,
      'winSpeed': winSpeed,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, weatherStateName: $weatherStateName, temperature: $temperature, maxTemp: $maxTemp, humidity:$humidity, winSpeed:$winSpeed}';
  }
}
