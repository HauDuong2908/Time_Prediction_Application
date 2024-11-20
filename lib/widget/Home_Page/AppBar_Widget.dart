// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Models/dropdown.dart';
import 'package:weather_app/Provider/initializeAsyncData.dart';
import 'package:weather_app/Provider/location_provider.dart';
// import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/Dropdown_button/custom_dropdown.dart';

AppBar App_Bar(Size size, LocationProvider locationProvider,
    BuildContext context, Initializeasyncdata inits) {
  final List<String> listlocation = inits.citiesWeather;
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> hintTextNotifier =
      ValueNotifier<String>(locationProvider.location);

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
            child: ValueListenableBuilder<String>(
              valueListenable: hintTextNotifier,
              builder: (context, hintText, _) {
                Dropdown dropdown = Dropdown(
                  items: listlocation,
                  controller: _controller,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 247, 242, 242)),
                  selectedStyle: const TextStyle(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  fielIcon: const Icon(Icons.arrow_drop_down),
                );

                return CustomDropdown(
                  dropdownModel: dropdown,
                  onChanged: (String? newValue) {
                    if (newValue != null &&
                        newValue != locationProvider.location) {
                      hintTextNotifier.value = newValue;
                      locationProvider.setLocation(newValue);
                      locationProvider.loadLocation(context, newValue);
                    }
                  },
                );
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
