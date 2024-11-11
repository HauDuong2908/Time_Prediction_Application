import 'package:flutter/material.dart';
import 'package:weather_app/API/location_service.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/widget/Home_Page/HomePage_Widget.dart';

class Welcom extends StatefulWidget {
  const Welcom({super.key});

  @override
  State<Welcom> createState() => _WelcomState();
}

class _WelcomState extends State<Welcom> {
  final TextEditingController _searchController = TextEditingController();
  List<District> cities = []; // Khởi tạo danh sách rỗng
  List<District> selectedCities = [];
  Constants myConstants = Constants();
  final locationService = LocationService(); // Tạo instance của LocationService

  @override
  void initState() {
    super.initState();
    _fetchCities(); // Gọi hàm để nạp dữ liệu từ API
  }

  // Hàm lấy dữ liệu từ API và cập nhật state
  void _fetchCities() async {
    try {
      List<District> fetchedCities = await locationService.fetchLocation();
      setState(() {
        cities = fetchedCities;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi tải dữ liệu từ API")),
      );
    }
  }

  void _addCityByName(String cityName) {
    final city = cities.firstWhere(
      (district) => district.city.toLowerCase() == cityName.toLowerCase(),
      orElse: () => District(
          city: 'not found', isDefault: false, isSlected: false, country: ''),
    );

    if (city.city == 'not found') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy địa điểm")),
      );
    } else if (!selectedCities.contains(city)) {
      setState(() {
        city.isSlected = true;
        selectedCities.add(city);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _addCityByName(value);
                    _searchController.clear();
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  _addCityByName(_searchController.text);
                  _searchController.clear();
                }
              },
            ),
          ],
        ),
      ),
      body: cities.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: size.height * .08,
                  width: size.width,
                  decoration: BoxDecoration(
                    border: cities[index].isSlected == true
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
                          setState(() {
                            cities[index].isSlected = !cities[index].isSlected;
                            if (cities[index].isSlected) {
                              selectedCities.add(cities[index]);
                            } else {
                              selectedCities.remove(cities[index]);
                            }
                          });
                        },
                        child: Image.asset(
                          cities[index].isSlected == true
                              ? 'assets/checked.png'
                              : 'assets/unchecked.png',
                          width: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        cities[index].city,
                        style: TextStyle(
                          fontSize: 16,
                          color: cities[index].isSlected == true
                              ? myConstants.primaryColor
                              : Colors.black54,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: myConstants.primaryColor,
          child: const Icon(Icons.pin_drop),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }),
    );
  }
}
