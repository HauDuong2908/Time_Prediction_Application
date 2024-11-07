import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

class weather_items extends StatelessWidget {
  const weather_items({
    Key? key,
    required this.value,
    required this.color,
    required this.text,
    required this.unit,
  }) : super(key: key);

  final int value;
  final String unit;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 6.0,
            animation: true,
            animationDuration: 1200,
            percent: value / 100,
            footer: Text(
              value.toString() + unit,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white.withOpacity(0.3),
            progressColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.butt,
          ),
          // const SizedBox(height: 2),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          )
        ],
      ),
    );
  }
}
