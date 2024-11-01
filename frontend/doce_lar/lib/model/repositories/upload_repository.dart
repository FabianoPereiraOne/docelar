import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Importando o CustomDio
import 'package:doce_lar/model/models/document_model.dart'; // Importando o modelo Document

class UploadRepository {
  final CustomDio dio;

  UploadRepository(this.dio);

  // Método para fazer upload usando apenas o objeto Document com file e animalId preenchidos
  Future<void> uploadDocument(Document document) async {
    if (document.file == null || document.animalId == null) {
      throw Exception('File e animalId são obrigatórios para o upload');
    }

    try {
      String endpoint = '/documents';
      String fileName = document.file!.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(document.file!.path, filename: fileName),
        "animalId": MultipartFile.fromString(document.animalId.toString()),
      });

      Response response = await dio.post(endpoint, data: formData);

      if (response.statusCode == 200) {
        log('Upload realizado com sucesso!');
      } else {
        throw Exception('Falha no upload: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro no upload: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

    Future<List<Document>> fetchDocuments() async {
    try {
      String endpoint = '/documents';
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((doc) => Document.fromMap(doc)).toList();
      } else {
        throw Exception('Falha ao buscar documentos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro ao buscar documentos: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }
}
