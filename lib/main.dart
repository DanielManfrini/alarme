import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/components/dialogs/new_alarm_dialog.dart';
import 'package:flutter_application_1/database/alarm_database.dart';
import 'package:flutter_application_1/models/alarm.dart';
import 'package:flutter_application_1/screens/alarm_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(const ProviderScope(child: MyApp()));
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


class MyHomePage extends ConsumerStatefulWidget {

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  @override
  void initState() {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;

    super.initState();
  }

  void _addAlarm(Alarm newAlarm) async {
    newAlarm.createdIn = DateTime.now().toString();

    ref.read(alarmListProvider.notifier).update((state) => [...state, newAlarm]);

    await AlarmDatabase.instance.create(newAlarm);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 78, 196),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(widget.title),
      ),
      body:const Center(child: AlarmScreen()),
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

 // WidgetsFlutterBinding.ensureInitialized();

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // const InitializationSettings initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);

    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // await AndroidAlarmManager.initialize();
