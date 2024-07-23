import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/alarm.dart';

class AlarmProvider with ChangeNotifier {
  List<Alarm> _alarms = [];

  List<Alarm> get alarms => _alarms;

  void setAlarms(List<Alarm> alarms) {
    _alarms = alarms;
    notifyListeners();
  }

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    notifyListeners();
  }

  void editAlarm(int index, Alarm newAlarm) {
    _alarms[index] = newAlarm;
    notifyListeners();
  }
}
