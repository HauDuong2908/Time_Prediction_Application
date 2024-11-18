// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:weather_app/Provider/weather_provider.dart';

import 'package:weather_app/Dropdown_button/custom_dropdown.dart';
// import 'package:weather_app/widget/Home_Page/DropDown.dart';

AppBar App_Bar(Size size, WeatherPro weatherProvider, BuildContext context) {
  List<String> listlocation = weatherProvider.citiesWeather;
  final TextEditingController _controller = TextEditingController();

  // String? initialLocation = listlocation.isNotEmpty ? listlocation[0] : null;

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
          SizedBox(
            width: size.width * 0.6,
            height: 50,
            child: CustomDropdown(
              items: listlocation,
              controller: _controller,
              // initial: initialLocation,
              hintText: 'Selected',
              onChanged: (String? newValue) {
                if (newValue != null && newValue != weatherProvider.location) {
                  weatherProvider.setLocation(newValue);
                  weatherProvider.loadLocation(newValue);
                }
              },
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () => context.pop('/welcome'),
          icon: const Icon(Icons.location_city),
        ),
      ),
    ],
  );
}
