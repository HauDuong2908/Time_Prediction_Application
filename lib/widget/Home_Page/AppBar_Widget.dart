import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/welcom.dart';

AppBar App_Bar(Size size, WeatherPro weatherProvider, BuildContext context) {
  final TextEditingController textEditingController = TextEditingController();
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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/pin.png',
                  width: 20,
                ),
                const SizedBox(width: 4),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: weatherProvider.citiesWeather.map((String location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    value: weatherProvider.citiesWeather
                            .contains(weatherProvider.location)
                        ? weatherProvider.location
                        : weatherProvider.citiesWeather.isNotEmpty
                            ? weatherProvider.citiesWeather[0]
                            : null,
                    onChanged: (String? newValue) {
                      if (newValue != null &&
                          newValue != weatherProvider.location) {
                        weatherProvider.setLocation(newValue);
                        weatherProvider.loadLocation(newValue);
                      }
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 200,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {
            Navigator.pop(
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
