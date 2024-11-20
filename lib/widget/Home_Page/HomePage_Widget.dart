import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Provider/initializeAsyncData.dart';
import 'package:weather_app/Provider/location_provider.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/Home_Page/AppBar_Widget.dart';
import 'package:weather_app/widget/Home_Page/Home_Body.dart';
import 'package:weather_app/widget/Home_Page/List_Datetime_Widget.dart';
import 'package:weather_app/widget/Home_Page/Nav_Bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initState = Provider.of<Initializeasyncdata>(context, listen: false);
    final weather = Provider.of<WeatherPro>(context, listen: false);
    _pageController = PageController(initialPage: weather.selectedDayIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedCities = District.getSelectedCities();
      if (selectedCities.isNotEmpty) {
        initState.initializeAsyncData(context);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherProvider = Provider.of<WeatherPro>(context);
    final inits = Provider.of<Initializeasyncdata>(context);
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          drawer: NavBar(),
          appBar: App_Bar(size, locationProvider, context, inits),
          body: locationProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: listDateTime(
                        weatherProvider,
                        myConstants,
                        onDaySelected: (index) {
                          weatherProvider.selectDay(index);
                          _pageController.jumpToPage(index);
                        },
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount:
                            weatherProvider.consolidateWeatherList.length,
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
        ),
      ],
    );
  }
}
