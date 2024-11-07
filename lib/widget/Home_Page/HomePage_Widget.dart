import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/Home_Page/AppBar_Widget.dart';
import 'package:weather_app/widget/Home_Page/List_Datetime_Widget.dart';

import 'Weather_Item_Widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final weatherProvider = Provider.of<WeatherPro>(context, listen: false);
    _pageController =
        PageController(initialPage: weatherProvider.selectedDayIndex);

    if (weatherProvider.cities.isNotEmpty) {
      weatherProvider.loadWeather(weatherProvider.cities[0]);
    }

    for (var city in weatherProvider.selectedCities) {
      weatherProvider.cities.add(city.city);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final weatherProvider = Provider.of<WeatherPro>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: App_Bar(size, weatherProvider, context),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: listDateTime(weatherProvider, myConstants,
                onDaySelected: (index) {
              weatherProvider.selectDay(index);
              _pageController.jumpToPage(index);
            }),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: weatherProvider.consolidateWeatherList.length,
              onPageChanged: (index) {
                weatherProvider.selectDay(index);
              },
              itemBuilder: (context, index) {
                return buildWeatherPage(
                    weatherProvider, myConstants, size, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeatherPage(
      WeatherPro weatherProvider, Constants myConstants, Size size, int index) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: weatherProvider.imageUrl == ''
                ? const Text('')
                : Image.asset(
                    'assets/${weatherProvider.imageUrl}.png',
                    width: 90,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                weatherProvider.temperatures.toString(),
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = myConstants.linearGradient,
                ),
              ),
              Text(
                '°C',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = myConstants.linearGradient,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              weatherProvider.listWeatherState.isNotEmpty
                  ? weatherProvider.listWeatherState[0]
                  : 'Loading...',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.blue,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              weatherProvider.currentDates,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: unnecessary_null_comparison
                weatherProvider.humidities != null
                    ? weather_items(
                        value: weatherProvider.humidities,
                        text: 'Humidity',
                        unit: '%',
                        color: Colors.blue,
                      )
                    : const Text('Loading...'),
                // ignore: unnecessary_null_comparison
                weatherProvider.precipprob != null
                    ? weather_items(
                        value: weatherProvider.precipprob,
                        text: 'Predictability',
                        unit: '%',
                        color: const Color.fromARGB(255, 99, 97, 204),
                      )
                    : const Text('Loading...'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
