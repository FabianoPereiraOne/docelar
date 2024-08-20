import 'dart:convert';

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
  String? homeId;

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
    this.homeId,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
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
      homeId: map['homeId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Animal.fromJson(String source) => Animal.fromMap(json.decode(source));

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
      'homeId': homeId,
    };
  }
}
