import 'dart:convert';

class AnimalType {
  int? id;
  String? type;

  AnimalType({
    this.id,
    this.type,
  });

  factory AnimalType.fromMap(Map<String, dynamic> map) {
    return AnimalType(
      id: map['id'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());

  factory AnimalType.fromJson(String source) => AnimalType.fromMap(json.decode(source));
}