// service_model.dart

import 'dart:convert';

class Service {
  String? id;
  String? description;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? animalId;

  Service({
    this.id,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.animalId,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      description: map['description'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      animalId: map['animalId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'animalId': animalId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) => Service.fromMap(json.decode(source));
}
