import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cards/alarm_card.dart';
import 'package:flutter_application_1/database/alarm_database.dart';
import 'package:flutter_application_1/models/alarm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmScreen extends ConsumerStatefulWidget {
  const AlarmScreen({super.key});

  @override
  ConsumerState<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends ConsumerState<AlarmScreen> {
  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final dbAlarms = await AlarmDatabase.instance.readAllAlarms();

    ref.read(alarmListProvider.notifier).update((state) => state = dbAlarms);
  }

  void _inactiveAlarm(int? id) async {
    final alarms = ref.watch(alarmListProvider);

    Alarm editedAlarm = alarms.where((alarm) => alarm.id == id).first;

    editedAlarm.editedIn = DateTime.now().toString();
    editedAlarm.active = false;

    ref.read(alarmListProvider.notifier).update((state) {
      return state.map((alarm) {
        return alarm.id == id ? editedAlarm : alarm;
      }).toList();
    });

    await AlarmDatabase.instance.update(editedAlarm);
  }

  void _activeAlarm(int? id) async {
    final alarms = ref.watch(alarmListProvider);

    Alarm editedAlarm = alarms.where((alarm) => alarm.id == id).first;

    editedAlarm.editedIn = DateTime.now().toString();
    editedAlarm.active = true;

    ref.read(alarmListProvider.notifier).update((state) {
      return state.map((alarm) {
        return alarm.id == id ? editedAlarm : alarm;
      }).toList();
    });

    await AlarmDatabase.instance.update(editedAlarm);
  }

  List<Widget> _buildActiveAlarmCards() {
    final alarms = ref.watch(alarmListProvider);
    return alarms.where((alarm) => alarm.active).map((alarm) {
      return AlarmCard(
        id: alarm.id,
        title: alarm.name,
        time: alarm.time,
        status: alarm.active,
        type: alarm.type,
        onCancelPressed: null,
        onDelayPressed: null,
        onStatusPressed: _inactiveAlarm,
      );
    }).toList();
  }

  List<Widget> _buildInactiveAlarmCards() {
    final alarms = ref.watch(alarmListProvider);
    return alarms.where((alarm) => !alarm.active).map((alarm) {
      return AlarmCard(
        id: alarm.id,
        title: alarm.name,
        time: alarm.time,
        status: alarm.active,
        type: alarm.type,
        onCancelPressed: null,
        onDelayPressed: null,
        onStatusPressed: _activeAlarm,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card.filled(
          elevation: 1,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const ListTile(
              title: Text('Alarmes Ativos'),
            ),
            ListBody(
              children: <Widget>[
                Card(child: Column(children: _buildActiveAlarmCards())),
              ],
            )
          ]),
        ),
        const SizedBox(width: 45),
        Card.filled(
          elevation: 1,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const ListTile(
              title: Text('Alarmes Inativos'),
            ),
            ListBody(
              children: <Widget>[
                Card(child: Column(children: _buildInactiveAlarmCards())),
              ],
            )
          ]),
        ),
      ],
    );
  }
}
