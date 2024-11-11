import 'package:flutter/material.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/Home_Page/Weather_Item_Widget.dart';

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
