import 'dart:developer';
import 'package:dio/dio.dart';

class DeleteRepository {
  final String url = 'https://docelar-pearl.vercel.app';
  // final String url = 'https://docelar-git-backstage-fabianopereiraones-projects.vercel.app/';
  final dio = Dio();


  Future<void> deleteItem({
    required String endpoint,  
    required String itemId,    
    required String token,    
  }) async {
    try {
      // Monta a URL com o itemId
      String fullEndpoint = '$url/$endpoint?id=$itemId';

      // Faz a requisição DELETE
      Response response = await dio.delete(
        fullEndpoint,
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

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
      throw e;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      throw e;
    }
  }

}
