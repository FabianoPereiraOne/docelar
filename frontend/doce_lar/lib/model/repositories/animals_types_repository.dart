import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';

class AnimalTypeRepository {
  final String url = 'https://docelar-pearl.vercel.app';
  final dio = Dio();

  // Método para buscar tipos de animais
  Future<List<AnimalType>> fetchAnimalTypes(String token) async {
    try {
      String endpoint = '$url/types-animals';
      Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

      if (response.statusCode == 200) {
        log('Resposta da API: ${response.data}');
        
        if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
          List<dynamic> data = response.data['data'];

          // Mapeia os dados para uma lista de tipos de animais, ignorando os campos desnecessários
          return data.map((e) {
            final animalType = AnimalType.fromMap(e as Map<String, dynamic>);
            return AnimalType(
              id: animalType.id,
              type: animalType.type,
            );
          }).toList();
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar tipos de animais: ${response.statusCode}');
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


Future<AnimalType> fetchAnimalTypeById(int id, String token) async {
  try {
    String endpoint = '$url/types-animals/$id';
    Response response = await dio.get(
      endpoint,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    log('Resposta da API para tipo de animal por ID: ${response.data}'); // Log adicional

    if (response.statusCode == 200) {
      // Verifique a estrutura da resposta e mapeie corretamente
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        final data = responseData['data'];
        return AnimalType.fromMap(data);
      } else {
        throw Exception('Formato de resposta inesperado');
      }
    } else {
      throw Exception('Falha ao buscar tipo de animal: ${response.statusCode}');
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