import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTimeProvider() {
    //Run on create class
    customDateTime();
  }
  List<DateTime> _daysOfWeek = [];

  List<DateTime> get daysOfWeek => _daysOfWeek;

  void customDateTime() {
    _generateDaysOfWeek();
  }

  Future<void> _generateDaysOfWeek() async {
    DateTime now = DateTime.now();
    // ignore: unused_local_variable
    DateFormat dateFormat = DateFormat('EEEE, MMM dd');

    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _daysOfWeek = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      _daysOfWeek.add((day));
    }
    var number = 10;
    number = await createInstance();
    log(number.toString());
    // notifyListeners();
  }

  Future<int> createInstance() async {
    Future<int> _p1() async {
      int r = 0;
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        r = 1;
      });
      return r;
    }

    Future<int> _p2() async {
      int r = 0;
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        r = 2;
      });
      return r;
    }

    Future<int> _p3() async {
      int r = 0;
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        r = 3;
      });
      return r;
    }

    // ignore: unused_local_variable
    DateFormat dateFormat = DateFormat('dd/MM/yyyy - HH : mm : ss ');

    int result = 0;
    final start = DateTime.now();
    int p1 = 0;
    int p2 = 0;
    int p3 = 0;
    Future<void> getP1() async {
      p1 = await _p1();
    }

    Future<void> getP2() async {
      p2 = await _p2();
    }

    Future<void> getP3() async {
      p3 = await _p3();
    }

    await Future.wait([
      getP1(),
      getP2(),
      getP3(),
    ]);

    final end = DateTime.now();
    log('${end.difference(start).inMilliseconds}');
    result = p1 + p2 + p3;
    log('p1: $p1 - p2: $p2 - p3: $p3');
    return result;
  }
}
