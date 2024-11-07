import 'package:flutter/material.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/welcom.dart';

AppBar App_Bar(Size size, WeatherPro weatherProvider, BuildContext context) {
  return AppBar(
    leading: BackButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Welcom()),
        );
      },
    ),
    automaticallyImplyLeading: false,
    centerTitle: false,
    titleSpacing: 0,
    backgroundColor: Colors.blue,
    elevation: 0.0,
    title: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  value:
                      weatherProvider.cities.contains(weatherProvider.location)
                          ? weatherProvider.location
                          : weatherProvider.cities[0],
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: weatherProvider.cities.map((String location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    weatherProvider.location = newValue!;
                    weatherProvider.loadWeather(newValue);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
