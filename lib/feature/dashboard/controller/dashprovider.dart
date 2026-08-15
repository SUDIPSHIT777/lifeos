import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/model/userdatabase.dart';
import 'package:lifeos/model/usermodel.dart';

class Userprovider extends ChangeNotifier {
  // ============ user data model ===========
  final Userdatabase userdatabase = Userdatabase();
  Usermodel? userdata;
  bool loading = false;
  String get username => userdata?.name ?? "User";
  String get email => userdata?.email ?? "user@email.com";
  // ========== Timer ============
  late Timer timer;
  String _gettime = "";
  String get gettime => _gettime;
  // ============ Notification ==============
  bool _isNotificationBusy = false;
  bool get isNotificationBusy => _isNotificationBusy;

  // =============== image and date path ===========
  String _imagepath = "";
  String get imagePath => _imagepath;

  Future<void> loaduserdata() async {
    userdata = await userdatabase.getuserdata();
    notifyListeners();
  }

  void clear() {
    userdata = null;
    notifyListeners();
  }

  void day() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      _gettime = "Good Morning";
      _imagepath = "assets/sun.png";
    } else if (hour >= 12 && hour < 17) {
      _gettime = "Good Afternoon";
      _imagepath = "assets/heat-wave.png";
    } else if (hour >= 17 && hour < 21) {
      _gettime = "Good Evening";
      _imagepath = "assets/sunsets.png";
    } else {
      _gettime = "Good Night";
      _imagepath = "assets/cloudy-night.png";
    }
    notifyListeners();
  }

  // ================ Time =====================
  late Timer timers;
  String _time = "";
  String _date = "";

  String get time => _time;
  String get date => _date;

  final DateFormat _timeFormat = DateFormat.Hm();
  final DateFormat _dateFormat = DateFormat("EEEE, MMM d");

  void _updateTime() {
    final now = DateTime.now();
    _time = _timeFormat.format(now);
    _date = "${_dateFormat.format(now)} ";
    notifyListeners();
  }

  Userprovider() {
    day();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) => day());
    _updateTime();
    timers = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
