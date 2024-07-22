import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cards/alarm_card.dart';
import 'package:flutter_application_1/components/dialogs/new_alarm_dialog.dart';
import 'package:flutter_application_1/enums/alarms_enum.dart';

void main() {
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
  final List<Alarm> alarms = [
    Alarm('Antibiótico', '12', true, AlarmType.recorrente),
    Alarm('Vitaminas', '8:00', false, AlarmType.diario),
    Alarm('Exercícios', '14:00', true, AlarmType.diario),
  ];

  void _addAlarm(Alarm newAlarm) {
    setState(() {
      alarms.add(newAlarm);
    });
  }

  void _inactiveAlarm(int id) {
    setState(() {
      alarms.where((alarm) => alarm.id == id).first.status = false;
    });
  }

  void _activeAlarm(int id) {
    setState(() {
      alarms.where((alarm) => alarm.id == id).first.status = true;
    });
  }

  void _removeAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
  }

  List<Widget> _buildActiveAlarmCards() {
    return alarms.where((alarm) => alarm.status).map((alarm) {
      return AlarmCard(
        id: alarm.id,
        title: alarm.title,
        time: alarm.time,
        status: alarm.status,
        type: alarm.type,
        onCancelPressed: null,
        onDelayPressed: null,
        onStatusPressed: _inactiveAlarm,
      );
    }).toList();
  }

  List<Widget> _buildInactiveAlarmCards() {
    return alarms.where((alarm) => !alarm.status).map((alarm) {
      return AlarmCard(
        id: alarm.id,
        title: alarm.title,
        time: alarm.time,
        status: alarm.status,
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