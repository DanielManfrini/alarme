import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cards/alarm_card.dart';
import 'package:flutter_application_1/components/dialogs/new_alarm_dialog.dart';
import 'package:flutter_application_1/database/alarm_database.dart';
import 'package:flutter_application_1/models/alarm.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Initialize FFI
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Alarmes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final dbAlarms = await AlarmDatabase.instance.readAllAlarms();
    setState(() {
      alarms = dbAlarms;
    });
  }

  void _addAlarm(Alarm newAlarm) async {
    newAlarm.createdIn = DateTime.now().toString();

    setState(() {
      alarms.add(newAlarm);
    });

    await AlarmDatabase.instance.create(newAlarm);
  }

  void _inactiveAlarm(int? id) async {
    Alarm editedAlarm = alarms.where((alarm) => alarm.id == id).first;

    editedAlarm.editedIn = DateTime.now().toString();
    editedAlarm.active = false;

    setState(() {
      alarms.where((alarm) => alarm.id == id).first.active = editedAlarm.active;
      alarms.where((alarm) => alarm.id == id).first.editedIn = editedAlarm.editedIn;
    });

    print(editedAlarm.toMap());

    await AlarmDatabase.instance.update(editedAlarm);
  }

  void _activeAlarm(int? id) async {
    Alarm editedAlarm = alarms.where((alarm) => alarm.id == id).first;

    editedAlarm.editedIn = DateTime.now().toString();
    editedAlarm.active = true;

    setState(() {
      alarms.where((alarm) => alarm.id == id).first.active = editedAlarm.active;
      alarms.where((alarm) => alarm.id == id).first.editedIn = editedAlarm.editedIn;
    });

    await AlarmDatabase.instance.update(editedAlarm);
  }

  List<Widget> _buildActiveAlarmCards() {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 78, 196),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 78, 196),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return NewAlarmDialog(
                  initialTime: DateTime.now(), onSave: _addAlarm);
            },
          );
        },
        tooltip: 'Cadastrar',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// void _addAlarm(Alarm newAlarm) {
//     setState(() {
//       alarms.add(newAlarm);
//     });
//   }

//   void _inactiveAlarm(int id) {
//     setState(() {
//       alarms.where((alarm) => alarm.id == id).first.status = false;
//     });
//   }

//   void _activeAlarm(int id) {
//     setState(() {
//       alarms.where((alarm) => alarm.id == id).first.status = true;
//     });
//   }

//   void _removeAlarm(int index) {
//     setState(() {
//       alarms.removeAt(index);
//     });
//   }

// Container(
//   padding: const EdgeInsets.all(16.0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       Expanded(
//         child: Container(
//           padding: const EdgeInsets.all(8.0),
//           child: const TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Nome',
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 16.0),
//       Expanded(
//         child: Container(
//           padding: const EdgeInsets.all(8.0),
//           child: const TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Sobrenome',
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),