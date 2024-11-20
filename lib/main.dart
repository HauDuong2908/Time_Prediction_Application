import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Provider/cities_provider.dart';
import 'package:weather_app/Provider/dropdown_provider.dart';
import 'package:weather_app/Provider/initializeAsyncData.dart';
import 'package:weather_app/Provider/location_provider.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/Go_Route.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => WeatherPro()),
      ChangeNotifierProvider(create: (_) => Initializeasyncdata()),
      ChangeNotifierProvider(create: (_) => CitiesProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => DropdownProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterWidget.router,
    );
  }
}
