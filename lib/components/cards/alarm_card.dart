import 'package:flutter/material.dart';
import 'package:flutter_application_1/enums/alarms_enum.dart';

class AlarmCard extends StatelessWidget {
  final int? id;
  final String title;
  final String time;
  final bool status;
  final AlarmType type;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onDelayPressed;
  final void Function(int?) onStatusPressed;

  const AlarmCard({
    super.key,
    this.id,
    required this.title,
    required this.time,
    required this.status,
    required this.type,
    this.onCancelPressed,
    this.onDelayPressed,
    required this.onStatusPressed,
  });

  String _getTime(time){
    if(type == AlarmType.diario){
      return 'Diariamente às: $time';
    }
    return 'A cada $time horas';
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: const Icon(Icons.alarm),
        title: Text(title),
        subtitle: Text(_getTime(time)),
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
