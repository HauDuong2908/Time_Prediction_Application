import 'package:flutter/material.dart';
import 'package:weather_app/Models/constants.dart';
// import 'package:weather_app/widget/home1.dart';
import 'package:weather_app/widget/welcom.dart';

// ignore: must_be_immutable, camel_case_types
class getStarted extends StatelessWidget {
  getStarted({super.key});

  Constants constants = Constants();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: constants.primaryColor.withOpacity(.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Get_Started.png',
              width: 300,
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Welcom(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                  color: constants.blue1.withOpacity(.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.indigo, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
