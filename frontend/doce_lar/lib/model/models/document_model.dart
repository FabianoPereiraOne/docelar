import 'dart:convert';
import 'dart:io';

class Document {
  int? id;
  String? key;
  File? file;
  String? animalId;
  String? serviceId;
  String? createdAt;

  Document({
    this.id,
    this.key,
    this.file,
    this.animalId,
    this.serviceId,
    this.createdAt,
  });

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      key: map['key'],
      file: map['file'],
      animalId: map['animalId'],
      serviceId: map['serviceId'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'file': file,
      'animalId': animalId,
      'serviceId': serviceId,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source));
}
