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

  final selectedCities = District.getSelectedCities();

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
      join(await getDatabasesPath(), 'Date_Time.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Weather(id INTEGER PRIMARY KEY, weatherStateName TEXT, temperature INTEGER, maxTemp INTEGER, humidity INTEGER, winSpeed INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> fetchLocation(String location) async {
    errorMessage = null;
    await fetchWeatherData(location);
  }

  Future<void> fetchWeatherData(String location) async {
    try {
      final Uri apiUrl = Uri.parse(
          '$baseUrl${Uri.encodeFull(location)}?unitGroup=metric&key=$apiKey&contentType=json');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final consolidateWeather = result['days'];
        final consolidateWeatherlists = [];
        final DateTime now = DateTime.now();

        int weekday = now.weekday;
        int future = 7 - weekday;
        int past = 7 - future;

        // if (consolidateWeather != null && consolidateWeather.isNotEmpty) {
        for (int i = 0; i < future; i++) {
          consolidateWeatherlists.add(consolidateWeather[i]);
        }
        temperature = consolidateWeatherlists[0]['temp'].round();
        weatherStateName = consolidateWeatherlists[0]['conditions'];
        maxTemp = consolidateWeatherlists[0]['tempmax'].round();
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

        final db = await _initDatabase();

        // Kiểm tra số lượng bản ghi hiện tại
        final countQuery =
            await db.rawQuery('SELECT COUNT(*) as count FROM Weather');
        print(countQuery);
        int recordCount = Sqflite.firstIntValue(countQuery) ?? 0;

        // Nếu số lượng bản ghi đạt tối đa, xóa bản ghi cũ nhất
        if (recordCount >= 7) {
          String lastDate = DateFormat('yyyy-MM-dd')
              .format(now.add(Duration(days: 7 + (past))));
          await db.delete(
            'Weather',
            where: 'datetime <= ?',
            whereArgs: [lastDate],
          );
        }

        // Thêm từng ngày dự báo vào cơ sở dữ liệu
        for (var day in consolidateWeatherList) {
          await db.insert(
            'Weather',
            {
              'datetime': day['datetime'],
              'weatherStateName': day['conditions'],
              'temperature': day['temp'].round(),
              'maxTemp': day['tempmax'].round(),
              'humidity': day['humidity'].round(),
              'winSpeed': day['windspeed'].round(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        isSaved = true; // Cập nhật trạng thái đã lưu
        notifyListeners();
        // }
      } else {
        errorMessage = "Không thể lấy dữ liệu thời tiết.";
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
      notifyListeners();
    }
  }
}
