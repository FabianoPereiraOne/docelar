import 'dart:convert';

class Procedure {
  int? id;
  String? name;
  String? description;
  String? dosage;
  String? createdAt;
  String? updatedAt;

  Procedure({
    this.id,
    this.name,
    this.description,
    this.dosage,
    this.createdAt,
    this.updatedAt,
  });

  factory Procedure.fromMap(Map<String, dynamic> map) {
    return Procedure(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dosage: map['dosage'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dosage': dosage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory Procedure.fromJson(String source) => Procedure.fromMap(json.decode(source));
}
