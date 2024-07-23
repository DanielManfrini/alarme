enum AlarmType { diario, recorrente, desconhecido }

extension AlarmTypeExtension on AlarmType {
  int get id {
    switch (this) {
      case AlarmType.diario:
        return 1;
      case AlarmType.recorrente:
        return 2;
      default:
        return 0;
    }
  }

  String get name {
    switch (this) {
      case AlarmType.diario:
        return 'Diário';
      case AlarmType.recorrente:
        return 'Recorrente';
      default:
        return 'Desconhecido';
    }
  }
}
