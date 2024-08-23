import 'dart:convert';

class Home {
  String? id;
  String? cep;
  String? state;
  String? city;
  String? district;
  String? address;
  String? number;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? collaboratorId;

  Home({
    this.id,
    this.cep,
    this.state,
    this.city,
    this.district,
    this.address,
    this.number,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.collaboratorId,
  });

  factory Home.fromMap(Map<String, dynamic> map) {
    return Home(
      id: map['id'],
      cep: map['cep'],
      state: map['state'],
      city: map['city'],
      district: map['district'],
      address: map['address'],
      number: map['number'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      collaboratorId: map['collaboratorId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cep': cep,
      'state': state,
      'city': city,
      'district': district,
      'address': address,
      'number': number,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'collaboratorId': collaboratorId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Home.fromJson(String source) => Home.fromMap(json.decode(source));
}
