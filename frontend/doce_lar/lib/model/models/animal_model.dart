import 'dart:convert';
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
  int? typeAnimalId;
  String? homeId;
  List<Service>? services; // Adicione esta linha para a lista de serviços

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
    this.typeAnimalId,
    this.homeId,
    this.services, // Adicione esta linha para o construtor
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    final typeAnimal = map['typeAnimal'] ?? {};
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
      typeAnimalId: typeAnimal['id'],
      homeId: map['homeId'],
      services: (map['services'] as List<dynamic>?)?.map((service) => Service.fromMap(service)).toList(), // Mapeia a lista de serviços
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
      'typeAnimalId': typeAnimalId,
      'homeId': homeId,
      'services': services?.map((service) => service.toMap()).toList(), // Converte a lista de serviços para Map
    };
  }

  String toJson() => json.encode(toMap());

  factory Animal.fromJson(String source) => Animal.fromMap(json.decode(source));
}
