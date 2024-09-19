import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';

class AnimalTypeRepository {
  
  final CustomDio dio;

  AnimalTypeRepository(this.dio);

  // Método para buscar tipos de animais
  Future<List<AnimalType>> fetchAnimalTypes() async {
    try {
      String endpoint = '/types-animals';
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        // log('Resposta da API: ${response.data}');
        
        if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
          List<dynamic> data = response.data['data'];       
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
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }


Future<AnimalType> fetchAnimalTypeById(int id) async {
  try {
    String endpoint = '/types-animals/$id';
    Response response = await dio.get(endpoint);

    // log('Resposta da API para tipo de animal por ID: ${response.data}'); // Log adicional

    if (response.statusCode == 200) {
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
    rethrow;
  } catch (e, s) {
    log(e.toString(), error: e, stackTrace: s);
    rethrow;
  }
}
}