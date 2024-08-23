import 'dart:convert';

class Doctor {
  String? id;
  String? name;
  String? crmv;
  String? expertise;
  String? phone;
  String? socialReason;
  String? cep;
  String? state;
  String? city;
  String? district;
  String? address;
  String? number;
  String? openHours;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Doctor({
    this.id,
    this.name,
    this.crmv,
    this.expertise,
    this.phone,
    this.socialReason,
    this.cep,
    this.state,
    this.city,
    this.district,
    this.address,
    this.number,
    this.openHours,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      crmv: map['crmv'],
      expertise: map['expertise'],
      phone: map['phone'],
      socialReason: map['socialReason'],
      cep: map['cep'],
      state: map['state'],
      city: map['city'],
      district: map['district'],
      address: map['address'],
      number: map['number'],
      openHours: map['openHours'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'crmv': crmv,
      'expertise': expertise,
      'phone': phone,
      'socialReason': socialReason,
      'cep': cep,
      'state': state,
      'city': city,
      'district': district,
      'address': address,
      'number': number,
      'openHours': openHours,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
