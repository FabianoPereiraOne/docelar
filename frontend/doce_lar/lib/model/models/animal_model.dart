import 'dart:convert';
import 'package:doce_lar/model/models/animal_type_model.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'service_model.dart'; // Importe o modelo Service

class Animal {
  String? id;
  String? name;
  String? description;
  String? sex;
  bool? castrated;
  String? race;
  String? linkPhoto;
  String? dateExit;
  bool? status;
  String? createdAt;
  String? updatedAt;
  AnimalType? typeAnimal; // Objeto completo para atualização
  int? typeAnimalId; // ID do tipo de animal para criação
  Home? home;
  List<Service>? services;

  Animal({
    this.id,
    this.name,
    this.description,
    this.sex,
    this.castrated,
    this.race,
    this.linkPhoto,
    this.dateExit,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.typeAnimal,
    this.typeAnimalId,
    this.home,
    this.services,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    final homeData = map['home'] as Map<String, dynamic>?;
    final typeAnimalData = map['typeAnimal'] as Map<String, dynamic>?;

    return Animal(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      sex: map['sex'],
      castrated: map['castrated'],
      race: map['race'],
      linkPhoto: map['linkPhoto'],
      dateExit: map['dateExit'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      typeAnimal: typeAnimalData != null
          ? AnimalType.fromMap(typeAnimalData)
          : null,
      typeAnimalId: map['typeAnimalId'], // ID do tipo de animal
      home: homeData != null ? Home.fromMap(homeData) : null,
      services: (map['services'] as List<dynamic>?)
          ?.map((service) => Service.fromMap(service))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sex': sex,
      'castrated': castrated,
      'race': race,
      'linkPhoto': linkPhoto,
      'dateExit': dateExit,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'typeAnimal': typeAnimal?.toMap(), // Para atualização
      'typeAnimalId': typeAnimalId, // Para criação
      'home': home?.toMap(),
      'services': services?.map((service) => service.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Animal.fromJson(String source) => Animal.fromMap(json.decode(source));
}
