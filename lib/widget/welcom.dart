import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Provider/weather_provider.dart';
import 'package:weather_app/widget/Home_Page/HomePage_Widget.dart';

class Welcom extends StatefulWidget {
  const Welcom({super.key});

  @override
  State<Welcom> createState() => _WelcomState();
}

class _WelcomState extends State<Welcom> {
  final TextEditingController _searchController = TextEditingController();
  Constants myConstants = Constants();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = Provider.of<WeatherPro>(context, listen: false);
      await locationProvider.loadDistricts();
      print("Load districts completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherPro>(
      builder: (context, locationProvider, child) {
        void handleLocation(String location) {
          final resultLocation = locationProvider.addLocation(location);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(resultLocation)));
        }

        Size size = MediaQuery.of(context).size;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: myConstants.primaryColor.withOpacity(.7),
            centerTitle: true,
            title: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên địa điểm...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        handleLocation(value);
                        _searchController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      handleLocation(_searchController.text);
                      _searchController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: locationProvider.citiesLocation.length,
            itemBuilder: (BuildContext context, int index) {
              final city = locationProvider.citiesLocation[index];
              return GestureDetector(
                onTap: () {
                  locationProvider.toggleCitySelection(city);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: size.height * .08,
                  width: size.width,
                  decoration: BoxDecoration(
                    border: city.isSlected
                        ? Border.all(
                            color: myConstants.secondaryColor.withOpacity(.6),
                            width: 2,
                          )
                        : Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: myConstants.primaryColor.withOpacity(.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          locationProvider.toggleCitySelection(city);
                        },
                        child: Image.asset(
                          city.isSlected
                              ? 'assets/checked.png'
                              : 'assets/unchecked.png',
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        city.city,
                        style: TextStyle(
                          fontSize: 16,
                          color: city.isSlected
                              ? myConstants.primaryColor
                              : Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: myConstants.primaryColor,
              child: const Icon(Icons.pin_drop),
              onPressed: () {
                locationProvider.ListCitiesLocation();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
        );
      },
    );
  }
}
