import 'package:flutter/material.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/welcom.dart';

AppBar App_Bar(Size size, WeatherPro weatherProvider, BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: true,
    centerTitle: true,
    titleSpacing: 0,
    backgroundColor: Colors.blue,
    elevation: 0.0,
    title: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pin.png',
                width: 20,
              ),
              const SizedBox(width: 4),
              DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                value: weatherProvider.citiesWeather
                        .contains(weatherProvider.location)
                    ? weatherProvider.location
                    : weatherProvider.citiesWeather.isNotEmpty
                        ? weatherProvider.citiesWeather[0]
                        : null,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: weatherProvider.citiesWeather.map((String location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null &&
                      newValue != weatherProvider.location) {
                    weatherProvider.setLocation(newValue);
                    weatherProvider.loadLocation(newValue);
                  }
                },
              )),
            ],
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Welcom()),
            );
          },
          icon: const Icon(Icons.location_city),
        ),
      ),
    ],
  );
}
