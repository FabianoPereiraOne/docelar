import 'dart:convert';

class Procedure {
  int? id;
  String? name;
  String? description;
  String? dosage;

  Procedure({
    this.id,
    this.name,
    this.description,
    this.dosage,
  });

  factory Procedure.fromMap(Map<String, dynamic> map) {
    return Procedure(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dosage: map['dosage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dosage': dosage,
    };
  }

  String toJson() => json.encode(toMap());

  factory Procedure.fromJson(String source) => Procedure.fromMap(json.decode(source));
}
