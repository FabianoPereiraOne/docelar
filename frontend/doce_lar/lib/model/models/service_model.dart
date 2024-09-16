import 'dart:convert';

import 'package:doce_lar/model/models/animal_model.dart'; // Adicione o import para o modelo Animal
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/procedure_model.dart';

class Service {
  String? id;
  String? description;
  bool? status;
  String? createdAt;
  String? updatedAt;
  Animal? animal; // Adicione o objeto Animal
  List<Doctor>? doctors;
  List<Procedure>? procedures;

  Service({
    this.id,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.animal,
    this.doctors,
    this.procedures,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      description: map['description'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      animal: map['animal'] != null ? Animal.fromMap(map['animal']) : null, // Converta para Animal
      doctors: map['doctors'] != null
          ? List<Doctor>.from(map['doctors'].map((x) => Doctor.fromMap(x)))
          : null,
      procedures: map['procedures'] != null
          ? List<Procedure>.from(map['procedures'].map((x) => Procedure.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'animal': animal?.toMap(), // Converta o Animal para Map
      'doctors': doctors?.map((doc) => doc.toMap()).toList(),
      'procedures': procedures?.map((proc) => proc.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) => Service.fromMap(json.decode(source));
}
