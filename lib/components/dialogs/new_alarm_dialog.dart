import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cards/alarm_card.dart';
import 'package:flutter_application_1/enums/alarms_enum.dart';

class NewAlarmDialog extends StatefulWidget {
  final DateTime initialTime;
  final void Function(Alarm) onSave;

  const NewAlarmDialog({super.key, required this.initialTime ,required this.onSave});

  @override
  _NewAlarmDialogState createState() => _NewAlarmDialogState();
}

class _NewAlarmDialogState extends State<NewAlarmDialog> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.fromDateTime(widget.initialTime);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Alarme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Hora selecionada: ${_selectedTime.format(context)}",
                ),
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () {
                  _selectTime(context);
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            String title = _titleController.text;
            String time = _selectedTime.format(context);
            AlarmType type = AlarmType.diario;
            
            Alarm newAlarm = Alarm(
              title,
              time,
              true,
              type,
            );
            
            widget.onSave(newAlarm);
            
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
