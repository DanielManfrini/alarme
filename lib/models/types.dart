class TypeModel {
  int? id;
  String name;

  TypeModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
    };
  }

  static TypeModel fromMap(Map<String, dynamic> map) {
    return TypeModel(
      id: map['Id'],
      name: map['Name'],
    );
  }
}
