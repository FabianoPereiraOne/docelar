import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/model/models/homes_model.dart';


class HomeRepository {
  final String url = 'https://docelar-pearl.vercel.app';
  final dio = Dio();

  // Método para buscar casas
  Future<List<Home>> fetchHomes(String token) async {
    try {
      String endpoint = '$url/homes';
      Response response = await dio.get(endpoint,
          options: Options(headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Authorization": "$token" // Usando o formato correto de Bearer token
          })
      );

      if (response.statusCode == 200) {
        // Verificar se response.data é um Map
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;
          log(data.toString());

          if (data.containsKey('data') && data['data'] is List) {
            // Mapeia os dados para uma lista de casas
            return (data['data'] as List)
                .map<Home>((e) => Home.fromMap(e as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception('Formato de resposta inesperado');
          }
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar casas: ${response.statusCode}');
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
