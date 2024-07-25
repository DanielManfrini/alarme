import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/alarm_database.dart';
import 'package:flutter_application_1/enums/alarms_enum.dart';
import 'package:flutter_application_1/models/alarm.dart';
import 'package:flutter_application_1/models/types.dart';

class NewAlarmDialog extends StatefulWidget {
  final DateTime initialTime;
  final void Function(Alarm) onSave;

  const NewAlarmDialog(
      {super.key, required this.initialTime, required this.onSave});

  @override
  State<NewAlarmDialog> createState() => _NewAlarmDialogState();
}

class _NewAlarmDialogState extends State<NewAlarmDialog> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _selectedStart = const TimeOfDay(hour: 0, minute: 0);
  TypeModel _selectedType = TypeModel(name: '');
  List<TypeModel> types = [];

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.fromDateTime(widget.initialTime);
    _selectedStart = TimeOfDay.fromDateTime(widget.initialTime);
    _getTypes();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        initialEntryMode: TimePickerEntryMode.inputOnly,
        helpText: 'Selecione o horário',
        cancelText: 'Cancelar',
        confirmText: 'Confirmar',
        hourLabelText: 'Horas',
        minuteLabelText: 'Minutos');
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectStart(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedStart,
        initialEntryMode: TimePickerEntryMode.inputOnly,
        helpText: 'Selecione o horário',
        cancelText: 'Cancelar',
        confirmText: 'Confirmar',
        hourLabelText: 'Horas',
        minuteLabelText: 'Minutos');
    if (picked != null && picked != _selectedStart) {
      setState(() {
        _selectedStart = picked;
      });
    }
  }

  Future<void> _getTypes() async {
    final dbTypes = await AlarmDatabase.instance.getTypes();

    setState(() {
      types = dbTypes;
    });
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
          const SizedBox(height: 10),
          DropdownButtonFormField<TypeModel>(
            hint: const Text('Tipo'),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            onChanged: (TypeModel? newValue) {
              setState(() {
                _selectedType = newValue!;
              });
            },
            items: types.map<DropdownMenuItem<TypeModel>>((TypeModel value) {
              return DropdownMenuItem<TypeModel>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedType.id == AlarmType.recorrente.id
                      ? 'Período de: ${_selectedTime.format(context)} horas'
                      : "Hora selecionada: ${_selectedTime.format(context)}",
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
          const SizedBox(height: 5),
          _selectedType.id == AlarmType.recorrente.id
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Hora de inicio: ${_selectedStart.format(context)}",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () {
                        _selectStart(context);
                      },
                    ),
                  ],
                )
              : Container(),
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
            String name = _titleController.text;
            String time = _selectedTime.format(context);

            DateTime now = DateTime.now();
            String start = DateTime(
              now.year,
              now.month,
              now.day,
              _selectedStart.hour,
              _selectedStart.minute,
            ).toString();

            AlarmType type = AlarmType.values[_selectedType.id ?? 0];

            Alarm newAlarm = Alarm(
                name: name,
                time: time,
                active: true,
                type: type,
                createdIn: DateTime.now().toString(),
                startIn:
                    _selectedType.id == AlarmType.recorrente.id ? start : null);

            widget.onSave(newAlarm);

            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
