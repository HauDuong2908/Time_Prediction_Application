// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/Models/constants.dart';

// import 'package:weather_app/Provider/connect_api.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/Home_Page/Home_Page_Ui.dart';

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
    final weatherProvider = Provider.of<WeatherPro>(context, listen: false);
    if (weatherProvider.cities.isNotEmpty) {
      weatherProvider.loadWeather(weatherProvider.cities[0]);
      // weatherProvider.loadWeather(weatherProvider.cities[0]);
    }

    // Thêm các thành phố đã chọn vào danh sách cities
    for (int i = 0; i < weatherProvider.selectedCities.length; i++) {
      weatherProvider.cities.add(weatherProvider.selectedCities[i].city);
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 71, 146, 221),
      Color.fromARGB(255, 39, 101, 163),
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final weatherProvider = Provider.of<WeatherPro>(context);
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
                        weatherProvider.loadWeather(newValue);
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
        // padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 60,
                  child: listDateTime(
                    weatherProvider,
                    myConstants,
                  )),
              Text(
                weatherProvider.location,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Text(
                weatherProvider.currentDates,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: weatherProvider.imageUrl == ''
                      ? const Text('')
                      : Image.asset(
                          'assets/${weatherProvider.imageUrl}.png',
                          width: 150,
                        ),
                ),
                // child: ,
              ),
              Container(
                width: size.width,
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        weatherProvider.weatherStateNames,
                        style: const TextStyle(
                          color: Colors.blue,
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
                                weatherProvider.temperatures.toString(),
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
                      value: weatherProvider.winSpeeds,
                      text: 'Win Speed',
                      unit: 'km/h',
                      imageUrl: 'assets/windspeed.png',
                    ),
                    weather_items(
                      value: weatherProvider.humidities,
                      text: 'Humidity',
                      unit: 'C°',
                      imageUrl: 'assets/humidity.png',
                    ),
                    weather_items(
                      value: weatherProvider.maxTemps,
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
      ),
    );
  }
}
