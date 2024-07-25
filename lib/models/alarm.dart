import 'package:flutter_application_1/enums/alarms_enum.dart';
import 'package:riverpod/riverpod.dart';

class Alarm {
  int? id;
  String name;
  String time;
  bool active;
  AlarmType type;
  String? createdIn;
  String? editedIn;
  String? lastPlay;
  String? startIn;

  Alarm(
      {this.id,
      required this.name,
      required this.time,
      required this.active,
      required this.type,
      this.createdIn,
      this.editedIn,
      this.lastPlay,
      this.startIn});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'Time': time,
      'Active': active ? 1 : 0,
      'Type': type.index,
      'CreatedIn': createdIn,
      'EditedIn': editedIn,
      'StartIn': startIn,
    };
  }

  static Alarm fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['Id'],
      name: map['Name'],
      time: map['Time'],
      active: map['Active'] == 1 ? true : false,
      type: AlarmType.values[map['Type']],
      createdIn: map['CreatedIn'],
      editedIn: map['EditedIn'],
      lastPlay: map['LastPlay'],
      startIn: map['StartIn'],
    );
  }

  Alarm copyWith(
      {int? id,
      String? name,
      String? time,
      bool? active,
      AlarmType? type,
      String? createdIn,
      String? editedIn,
      String? lastPlay,
      String? startIn}) {
    return Alarm(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      active: active ?? this.active,
      type: type ?? this.type,
      createdIn: createdIn ?? this.createdIn,
      editedIn: editedIn ?? this.editedIn,
      lastPlay: lastPlay ?? this.lastPlay,
      startIn: startIn ?? this.startIn,
    );
  }
}

final alarmListProvider = StateProvider<List<Alarm>>((ref) => []);
