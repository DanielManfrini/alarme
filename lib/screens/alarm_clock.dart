import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AlarmClock extends StatefulWidget {
  const AlarmClock({super.key});

  @override
  State<AlarmClock> createState() => _AlarmClockstate();
}

class _AlarmClockstate extends State<AlarmClock> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioPlayer.play(AssetSource('audio/alarm_clock.mp3'));
  }

  void _stopMusic() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  child: const Center(
                      child: Text(
                    "22:22",
                    selectionColor: Color.fromARGB(255, 0, 0, 0),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 64),
                  )))),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
                onPressed: () => {_stopMusic(), Navigator.pop(context)},
                child: const Text('Encerrar')),
          )
        ],
      ),
    ));
  }
}
