import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Provider/connect_api.dart';

ListView listDateTime(WeatherProvider weatherProvider, Constants myConstants) {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: weatherProvider.consolidateWeatherList.length,
      itemBuilder: (BuildContext context, int index) {
        String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final selectedDay =
            weatherProvider.consolidateWeatherList[index]['datetime'];

        var parseDate = DateTime.parse(
            weatherProvider.consolidateWeatherList[index]['datetime']);
        var newDate = DateFormat('dd/MM').format(parseDate).substring(0, 5);
        var newDate1 = DateFormat('EEE').format(parseDate).substring(0, 3);

        return Container(
          width: MediaQuery.of(context).size.width / 7,
          decoration: BoxDecoration(
              gradient: selectedDay == today ? myConstants.myGradient : null,
              color: selectedDay != today
                  ? const Color.fromARGB(255, 9, 51, 167)
                  : null,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                  color: selectedDay == today
                      ? myConstants.primaryColor
                      : const Color.fromARGB(136, 221, 215, 215)
                          .withOpacity(.2),
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                newDate1,
                style: TextStyle(
                  fontSize: 17,
                  color: selectedDay == today
                      ? Colors.white
                      : myConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                newDate,
                style: TextStyle(
                  fontSize: 17,
                  color: selectedDay == today
                      ? Colors.white
                      : myConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
      });
}
