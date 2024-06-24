import 'dart:convert';

class Usuario {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? type;
  bool? statusAccount;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? homes;
  String? authorization; // novo campo para o token de autorização

  Usuario({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.type,
    this.statusAccount,
    this.createdAt,
    this.updatedAt,
    this.homes,
    this.authorization, // inicializando o novo campo
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      type: map['type'],
      statusAccount: map['statusAccount'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      homes: map['homes'],
      authorization: map['authorization'], // atribuindo o valor do token de autorização
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
      'statusAccount': statusAccount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'homes': homes,
      'authorization': authorization, // incluindo o token de autorização no mapa
    };
  }
}
