import 'dart:convert';
import 'package:flutter/material.dart';
// Library
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/Models/district.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Folder
// import 'package:weather_app/Data/DB_Weather.dart';
import 'package:weather_app/widget/weather_enum.dart';

class WeatherProvider extends ChangeNotifier {
  String location = '';
  String? errorMessage;
  String imageUrl = '';
  bool isSaved = false;

  final selectedCities = District.getSelectedCities(District as List<District>);

  // Weather State
  String weatherStateName = 'Loading...';
  int temperature = 0;
  int maxTemp = 0;
  int humidity = 0;
  int winSpeed = 0;
  var currentDate = 'Loading...';

  // List
  final List<String> cities = ['Đà Nẵng'];
  List consolidateWeatherList = [];
  List forecastDays = [];

  final String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';
  final String apiKey = 'YCVZZSMMKNN59RN74H9VEQDH4';

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'DATE_TIME.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE WeatherTime(id INTEGER PRIMARY KEY, weatherStateName TEXT, temperature INTEGER, maxTemp INTEGER, humidity INTEGER, winSpeed INTEGER, dateTime DATETIME)',
        );
      },
      version: 1,
    );
  }

  Future<void> fetchLocation(String location) async {
    errorMessage = null;
    await fetchWeatherData(location);
  }

  Future<List> fetchWeatherData(String location) async {
    try {
      final Uri apiUrl = Uri.parse(
          '$baseUrl${Uri.encodeFull(location)}?unitGroup=metric&key=$apiKey&contentType=json');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final consolidateWeather = result['days'];
        final List<Map<String, dynamic>> consolidateWeatherlists = [];
        final DateTime now = DateTime.now();
        final db = await _initDatabase();

        int weekday = now.weekday;
        int future = 7 - weekday;
        int past = 7 - future;

        for (int i = 0; i < future + 7; i++) {
          await db.insert(
            'WeatherTime',
            {
              'datetime': consolidateWeather[i]['datetime'],
              'weatherStateName': consolidateWeather[i]['conditions'],
              'temperature': consolidateWeather[i]['temp'].round(),
              'maxTemp': consolidateWeather[i]['tempmax'].round(),
              'humidity': consolidateWeather[i]['humidity'].round(),
              'winSpeed': consolidateWeather[i]['windspeed'].round(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        final List<Map<String, dynamic>> weatherData =
            await db.query('WeatherTime');

        for (int i = 0; i < weatherData.length; i++) {
          consolidateWeatherlists.add(weatherData[i]);
        }
        temperature = consolidateWeatherlists[0]['temperature'].round();
        weatherStateName = consolidateWeatherlists[0]['weatherStateName'];
        maxTemp = consolidateWeatherlists[0]['maxTemp'].round();
        humidity = consolidateWeatherlists[0]['humidity'].round();
        winSpeed = consolidateWeatherlists[0]['windspeed'].round();

        final myDate = DateTime.parse(consolidateWeatherlists[0]['datetime']);
        currentDate = DateFormat('E MMM dd, yyyy').format(myDate);

        consolidateWeatherList = consolidateWeatherlists.toSet().toList();

        final listWeatherState = weatherStateName.split(',');
        final listEnumState = listWeatherState
            .map((e) => WeatherState.getEnumFromCode(e.trim()))
            .toList();

        imageUrl = listEnumState.first.image;

        // Kiểm tra số lượng bản ghi hiện tại
        final countQuery =
            await db.rawQuery('SELECT COUNT(*) as count FROM WeatherTime');
        int recordCount = Sqflite.firstIntValue(countQuery) ?? 0;

        // Nếu số lượng bản ghi đạt tối đa, xóa bản ghi cũ nhất
        if (recordCount >= 7) {
          String lastDate = DateFormat('yyyy-MM-dd')
              .format(now.add(Duration(days: 7 + (past))));
          await db.delete(
            'WeatherTime',
            where: 'datetime <= ?',
            whereArgs: [lastDate],
          );
        }
        isSaved = true; // Cập nhật trạng thái đã lưu
        notifyListeners();

        return consolidateWeatherlists;
      } else {
        errorMessage = "Không thể lấy dữ liệu thời tiết.";
        notifyListeners();
        return [];
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
      notifyListeners();
      return [];
    }
  }
}
