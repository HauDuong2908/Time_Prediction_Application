import 'package:flutter/material.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/widget/weather_enum.dart';

class WeatherPro extends ChangeNotifier {
  String? selectedDate;
  int selectedDayIndex = 0;
  String imageUrl = '';

  String weatherStateNames = 'Loading...';
  int temperatures = 0;
  int maxTemps = 0;
  int humidities = 0;
  int precipprob = 0;
  int winSpeeds = 0;
  String currentDates = 'Loading...';

  List<String> listWeatherState = [];
  List<DailyWeather> consolidateWeatherList = [];

  void updateWeatherData(DailyWeather weather) {
    weatherStateNames = weather.weatherStateName;
    temperatures = weather.temperature;
    maxTemps = weather.maxTemp;
    humidities = weather.humidity;
    precipprob = weather.precipprob;
    winSpeeds = weather.winSpeed;
    currentDates = weather.datetime;

    listWeatherState = weatherStateNames.split(',');
    final listEnumState = listWeatherState
        .map((e) => WeatherState.getEnumFromCode(e.trim()))
        .whereType<WeatherState>()
        .toList();

    imageUrl = listEnumState.isNotEmpty ? listEnumState.first.image : '';
  }

  void selectDay(int index) async {
    if (index < consolidateWeatherList.length) {
      selectedDayIndex = index;
      updateWeatherData(consolidateWeatherList[index]);
      selectedDate = consolidateWeatherList[index].datetime;
      notifyListeners();
    }
  }

  // final LayerLink _layerLink = LayerLink();
  // final ScrollController _controller = ScrollController();
  // OverlayEntry? _overlayEntry;
  // bool _isOpen = false;

  // void _toggleDropdown(BuildContext context, Function(String) onItemSelected, List<String> items) {
  //   if (_isOpen) {
  //     _overlayEntry?.remove();
  //       _isOpen = false;
  //   } else {
  //     _overlayEntry = _createOverlayEntry(context, onItemSelected, items);
  //     Overlay.of(context).insert(_overlayEntry!);
  //       _isOpen = true;
  //   }
  //   notifyListeners();
  // }

  //  OverlayEntry _createOverlayEntry(BuildContext context, Function(String) onItemSelected, List<String> items) {
  //   RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   var size = renderBox.size;
  //   var offset = renderBox.localToGlobal(Offset.zero);
}
