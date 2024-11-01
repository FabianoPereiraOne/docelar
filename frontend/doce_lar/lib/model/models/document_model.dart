import 'dart:convert';
import 'dart:io';

class Document {
  int? id;
  String? key;
  File? file;
  String? animalId;
  String? serviceId;

  Document({
    this.id,
    this.key,
    this.file,
    this.animalId,
    this.serviceId,
  });

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      key: map['key'],
      file: map['file'],
      animalId: map['animalId'],
      serviceId: map['serviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'file': file,
      'animalId': animalId,
      'serviceId': serviceId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source));
}
