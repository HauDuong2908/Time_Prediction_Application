// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/Models/constants.dart';

// import 'package:weather_app/Provider/connect_api.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/Home_Page/AppBar_Widget.dart';
import 'package:weather_app/widget/Home_Page/List_Datetime_Widget.dart';

import 'Weather_Item_Widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final weatherProvider = Provider.of<WeatherPro>(context, listen: false);
    if (weatherProvider.cities.isNotEmpty) {
      weatherProvider.loadWeather(weatherProvider.cities[0]);
    }
    for (var city in weatherProvider.selectedCities) {
      weatherProvider.cities.add(city.city);
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final weatherProvider = Provider.of<WeatherPro>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: App_Bar(size, weatherProvider),
      body: Container(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: listDateTime(weatherProvider, myConstants),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: weatherProvider.imageUrl == ''
                      ? const Text('')
                      : Image.asset(
                          'assets/${weatherProvider.imageUrl}.png',
                          width: 90,
                        ),
                ),
                // child: ,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.8),
                      child: Text(
                        weatherProvider.temperatures.toString(),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = myConstants.linearGradient,
                        ),
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = myConstants.linearGradient,
                      ),
                    ),
                    Text(
                      'C',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = myConstants.linearGradient,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        weatherProvider.listWeatherState[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weatherProvider.currentDates,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weather_items(
                      value: weatherProvider.precips,
                      text: 'Predictability',
                      unit: '%',
                      // imageUrl: 'assets/windspeed.png',
                      color: Colors.blue,
                    ),
                    weather_items(
                      value: weatherProvider.humidities,
                      text: 'Humidity',
                      unit: '%°', color: Colors.blue,
                      // imageUrl: 'assets/humidity.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
