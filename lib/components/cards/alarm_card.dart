import 'package:flutter/material.dart';

class Alarm {
  static int _idCounter = 0; // Contador estático para incrementar IDs

  final int id;
  String title;
  String subTitle;
  bool status;

  Alarm(this.title, this.subTitle, this.status) : id = _getNextId();
  static int _getNextId() {
    return _idCounter++;
  }
}

class AlarmCard extends StatelessWidget {
  final int id;
  final String title;
  final String subTitle;
  final bool status;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onDelayPressed;
  final void Function(int) onStatusPressed;

  const AlarmCard({
    super.key,
    required this.id,
    required this.title,
    required this.subTitle,
    required this.status,
    this.onCancelPressed,
    this.onDelayPressed,
    required this.onStatusPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: const Icon(Icons.alarm),
        title: Text(title),
        subtitle: Text(subTitle),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          status
              ? const TextButton(
                  onPressed: null,
                  child: Text('Cancelar'),
                )
              : Container(),
          const SizedBox(width: 8),
          status
              ? const TextButton(
                  onPressed: null,
                  child: Text('Adiar'),
                )
              : Container(),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              onStatusPressed(id);
            },
            child: Text(status ? 'Inativar' : 'Ativar'),
          ),
          const SizedBox(width: 8),
        ],
      ),
    ]);
  }
}
