import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Provider/weather_provider.dart';

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myConstants = Provider.of<Constants>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<WeatherPro>(
              builder: (context, weatherProvider, child) {
                return listDateTime(weatherProvider, myConstants);
              },
            ),
          ),
        ],
      ),
    );
  }
}

ListView listDateTime(WeatherPro weatherProvider, Constants myConstants) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: weatherProvider.consolidateWeatherList.length,
    itemBuilder: (BuildContext context, int index) {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final selectedDay =
          weatherProvider.consolidateWeatherList[index].datetime;

      // Sử dụng DateFormat để phân tích selectedDay
      DateTime parseDate;
      DateFormat format = DateFormat('EEE MMM dd, yyyy');
      parseDate = format.parse(selectedDay);

      // Định dạng selectedDay cho so sánh
      String dayFormat = DateFormat('yyyy-MM-dd').format(parseDate);

      String dayName = dayFormat == today
          ? "Today"
          : DateFormat('EEE').format(parseDate).substring(0, 3);
      String newDate = DateFormat('dd/MM').format(parseDate).substring(0, 5);

      return GestureDetector(
        onTap: () {
          weatherProvider.selectDay(index);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 7,
          decoration: BoxDecoration(
            gradient: weatherProvider.selectedDayIndex == index
                ? myConstants.myGradient
                : null,
            color: dayFormat != today
                ? const Color.fromARGB(255, 9, 51, 167)
                : null,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                color: dayFormat == today
                    ? const Color.fromARGB(255, 9, 51, 167)
                    : const Color.fromARGB(255, 9, 51, 167).withOpacity(.2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayName,
                style: TextStyle(
                  fontSize: 17,
                  color: dayFormat == today
                      ? Colors.white
                      : myConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                newDate,
                style: TextStyle(
                  fontSize: 17,
                  color: dayFormat == today
                      ? Colors.white
                      : myConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
