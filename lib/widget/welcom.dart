import 'package:flutter/material.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/widget/home_page.dart';

class Welcom extends StatefulWidget {
  const Welcom({super.key});

  @override
  State<Welcom> createState() => _welcomState();
}

class _welcomState extends State<Welcom> {
  @override
  Widget build(BuildContext context) {
    List<District> cities = District.citiesList
        .where((district) => district.isDefault == false)
        .toList();
    List<District> selectedCities = District.getSelectedCities();

    Constants myConstants = Constants();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myConstants.primaryColor.withOpacity(.7),
        centerTitle: true,
        title: Text(
          '${selectedCities.length.toString()}Selected',
        ),
      ),
      body: ListView.builder(
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
                  //chèn ontap vào Icon tích dấu.
                  onTap: () {
                    setState(() {
                      cities[index].isSlected = !cities[index].isSlected;
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
          child: Icon(Icons.pin_drop),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }),
    );
  }
}
