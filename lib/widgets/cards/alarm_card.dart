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
  final void Function(int?) onDeletePressed;

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
    required this.onDeletePressed,
  });

  String _getTime(time) {
    if (type == AlarmType.diario) {
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
        trailing: PopupMenuButton<String>(
          tooltip: 'Opções',
          onSelected: (String result) {
            if (result == 'edit') {
            } else if (result == 'status') {
              onStatusPressed(id);
            } else if (result == 'delete') {
              onDeletePressed(id);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Editar'),
            ),
            PopupMenuItem<String>(
              value: 'status',
              child: Text(status ? 'Inativar' : 'Ativar'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Deletar'),
            ),
          ],
        ),
      ),
      Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child:  Row(
            children: [
              Text(
                status ? 'Ativo' : 'inativo',
                textAlign: TextAlign.left,
              ),
              const SizedBox(width: 45)
            ],
          )),
      const Divider(
        indent: 15,
        endIndent: 15,
      ),
    ]);
  }
}
