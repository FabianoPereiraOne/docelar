import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Importando o CustomDio

class UploadRepository {
  final CustomDio dio; // Usando o CustomDio

  // O construtor agora recebe uma instância do CustomDio
  UploadRepository(this.dio);

  // Método para fazer upload de imagem
  Future<void> uploadImage(File imageFile) async {
    try {
      String endpoint = '/upload';
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
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
}
