import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/alarm_clock.dart';
import 'package:flutter_application_1/services/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/widgets/dialogs/new_alarm_dialog.dart';
import 'package:flutter_application_1/database/alarm_database.dart';
import 'package:flutter_application_1/models/alarm.dart';
import 'package:flutter_application_1/screens/alarm_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
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
    // para windows
    // _initWindowsDatabase;

    // _initAlarmInstance();
    _initTimezones();
    _initNotificationsInstance();

    //scheduleNotification();

    super.initState();
  }

  void _initWindowsDatabase() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  void _initTimezones() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Recife'));
  }

  void _initNotificationsInstance() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _addAlarm(Alarm newAlarm) async {
    ref
        .read(alarmListProvider.notifier)
        .update((state) => [...state, newAlarm]);

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
      body: Center(
        child: ElevatedButton(
          key: const ValueKey('RegisterOneShotAlarm'),
          onPressed: () => _alarmCallback(context),
          // () async {
          //   await AndroidAlarmManager.oneShot(
          //     const Duration(seconds: 5),
          //     Random().nextInt(pow(2, 31) as int),
          //     () => _alarmCallback(context),
          //     exact: true,
          //     wakeup: true,
          //   );
          // },
          child: const Text(
            'Schedule OneShot Alarm',
          ),
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

void _alarmCallback(context) {
  print('teste');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AlarmClock()),
  );
}

// import 'package:flutter/material.dart';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

// void main() async {
//   // Inicializa o AndroidAlarmManager.
//   WidgetsFlutterBinding.ensureInitialized();
//   await AndroidAlarmManager.initialize();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Alarm Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Alarm Demo'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             final now = DateTime.now();
//             final alarmTime = now.add(const Duration(seconds: 10));
//             // Verifica se o AlarmManager já está agendado
//             AndroidAlarmManager.cancel(0).then((_) {
//               AndroidAlarmManager.oneShotAt(
//                 alarmTime,
//                 // Unique identifier for the alarm.
//                 0,
//                 _alarmCallback,
//                 exact: true,
//                 wakeup: true,
//               );
//             });
//           },
//           child: const Text('Schedule Alarm'),
//         ),
//       ),
//     );
//   }
// }

// void _alarmCallback() {
//   print('Alarm Fired!');
// }

  // void _initAlarmInstance() async {
  //   AndroidAlarmManager.cancel(0);
  //   await AndroidAlarmManager.initialize();
  // }