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
  AnimalType? typeAnimal; // Alterado para AnimalType
  Home? home; // Definido como Home
  List<Service>? services; // Lista de serviços

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
    this.home,
    this.services,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    final homeData =
        map['home'] as Map<String, dynamic>?; // Extraia o mapa de home
    final typeAnimalData = map['typeAnimal']
        as Map<String, dynamic>?; // Extraia o mapa de typeAnimal

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
          : null, // Crie uma instância de AnimalType
      home: homeData != null
          ? Home.fromMap(homeData)
          : null, // Crie uma instância de Home
      services: (map['services'] as List<dynamic>?)
          ?.map((service) => Service.fromMap(service))
          .toList(), // Mapeia a lista de serviços
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
      'typeAnimal':
          typeAnimal?.toMap(), // Converte AnimalType para Map se não for null
      'home': home?.toMap(), // Converte Home para Map se não for null
      'services': services
          ?.map((service) => service.toMap())
          .toList(), // Converte a lista de serviços para Map
    };
  }

  String toJson() => json.encode(toMap());

  factory Animal.fromJson(String source) => Animal.fromMap(json.decode(source));
}
