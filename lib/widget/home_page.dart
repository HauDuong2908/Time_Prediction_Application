// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/Models/constants.dart';

import 'package:weather_app/Provider/connect_api.dart';

import 'weather_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Gọi hàm để lấy dữ liệu vị trí và thời tiết
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    if (weatherProvider.cities.isNotEmpty) {
      weatherProvider.fetchLocation(weatherProvider.cities[0]);
      weatherProvider.fetchWeatherData(weatherProvider.cities[0]);
    }

    // Thêm các thành phố đã chọn vào danh sách cities
    for (int i = 0; i < weatherProvider.selectedCities.length; i++) {
      weatherProvider.cities.add(weatherProvider.selectedCities[i].city);
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final weatherProvider = Provider.of<WeatherProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
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
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/profile.png',
                  width: 40,
                  height: 40,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: weatherProvider.cities
                              .contains(weatherProvider.location)
                          ? weatherProvider.location
                          : weatherProvider.cities[
                              0], // Đảm bảo value khớp với một giá trị hợp lệ
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: weatherProvider.cities.map((String location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        weatherProvider.location = newValue!;
                        weatherProvider.fetchLocation(newValue);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherProvider.consolidateWeatherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String today = DateTime.now().toString().substring(0, 10);
                      final selectedDay = weatherProvider
                          .consolidateWeatherList[index]['datetime'];

                      var parseDate = DateTime.parse(weatherProvider
                          .consolidateWeatherList[index]['datetime']);
                      var newDate =
                          DateFormat('dd/MM').format(parseDate).substring(0, 5);
                      var newDate1 =
                          DateFormat('EEE').format(parseDate).substring(0, 3);

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        margin: const EdgeInsets.only(bottom: 80, top: 10),
                        width: 100,
                        decoration: BoxDecoration(
                            color: selectedDay == today
                                ? myConstants.primaryColor
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: selectedDay == today
                                    ? myConstants.primaryColor
                                    : Colors.black54.withOpacity(.2),
                              ),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              newDate,
                              style: TextStyle(
                                fontSize: 17,
                                color: selectedDay == today
                                    ? Colors.white
                                    : myConstants.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              newDate1,
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
                    })),
            Text(
              weatherProvider.location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            Text(
              weatherProvider.currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                color: myConstants.primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: myConstants.primaryColor.withOpacity(.5),
                    offset: const Offset(0, 25),
                    blurRadius: 10,
                    spreadRadius: -12,
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: weatherProvider.imageUrl == ''
                        ? const Text('')
                        : Image.asset(
                            'assets/${weatherProvider.imageUrl}.png',
                            width: 150,
                          ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      weatherProvider.weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4.8),
                            child: Text(
                              weatherProvider.temperature.toString(),
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient,
                              ),
                            ),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                          Text(
                            'C',
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weather_items(
                    value: weatherProvider.winSpeed,
                    text: 'Win Speed',
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weather_items(
                    value: weatherProvider.humidity,
                    text: 'Humidity',
                    unit: 'C°',
                    imageUrl: 'assets/humidity.png',
                  ),
                  weather_items(
                    value: weatherProvider.maxTemp,
                    text: 'Max Temp',
                    unit: 'C°',
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
