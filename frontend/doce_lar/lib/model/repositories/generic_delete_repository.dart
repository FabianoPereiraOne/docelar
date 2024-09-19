import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Importando o CustomDio

class DeleteRepository {
  final CustomDio dio;

  // O construtor agora recebe uma instância do CustomDio
  DeleteRepository(this.dio);

  Future<void> deleteItem({
    required String endpoint,  
    required String itemId,    
  }) async {
    try {
      // Monta a URL com o itemId
      String fullEndpoint = '/$endpoint?id=$itemId';

      // Faz a requisição DELETE
      Response response = await dio.delete(fullEndpoint);

      if (response.statusCode == 200) {
        log('$endpoint excluído com sucesso!');
      } else {
        throw Exception('Falha ao excluir $endpoint: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        log('Resposta do servidor: ${e.response?.data}');
      } else {
        log('Erro na solicitação: ${e.message}');
      }
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }
}
