import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/model/models/animal_model.dart';

class AnimalRepository {
  final String url = 'https://docelar-pearl.vercel.app';

  final dio = Dio();

  // Novo método para buscar animais
  Future<List<Animal>> fetchAnimais(String token) async {
    try {
      String endpoint = '$url/animals';
      Response response = await dio.get(endpoint,
          options: Options(headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Authorization": "$token"
          }));

      if (response.statusCode == 200) {
        // Verificar se response.data é um Map
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;
          //log(data.toString());

          if (data.containsKey('data') && data['data'] is List) {
            // Mapeia os dados para uma lista de animais
            return (data['data'] as List)
                .map<Animal>((e) => Animal.fromMap(e as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception('Formato de resposta inesperado');
          }
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar animais: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        //  log('Resposta do servidor: ${e.response?.data}');
      } else {
        // log('Erro na solicitação: ${e.message}');
      }
      throw e;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      throw e;
    }
  }

  Future<void> addAnimal(Animal animal, String token) async {
    try {
      // Defina o endpoint da API
      String endpoint = '$url/animals';

      // Crie um mapa de dados com todos os campos necessários, incluindo homeId
    Map<String, dynamic> animalData = {
      'name': animal.name,
      'description': animal.description,
      'sex': animal.sex,
      'castrated': animal.castrated,
      'race': animal.race,
      'typeAnimalId': animal.typeAnimalId,
      'homeId': animal.home?.id, // Certifique-se de que este ID é válido
    };

      // Faça a requisição POST para adicionar o animal
      Response response = await dio.post(
        endpoint,
        data: animalData, // Envie o mapa de dados como JSON
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

      // Verifique a resposta da API
      if (response.statusCode == 201) {
        log('Animal adicionado com sucesso!');
      } else {
        throw Exception('Falha ao adicionar animal: ${response.statusCode}');
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

  Future<void> updateAnimal(Animal animal, String token) async {
    try {
      // Defina o endpoint da API
      String endpoint = '$url/animals';

      // Crie um mapa de dados com todos os campos necessários, incluindo o ID
      Map<String, dynamic> animalData = {
        'id': animal.id,
        'name': animal.name,
        'description': animal.description,
        'sex': animal.sex,
        'castrated': animal.castrated,
        'race': animal.race,
        'linkPhoto': animal.linkPhoto,
        'typeAnimalId': animal.typeAnimalId,
        'status': animal.status,
        'home': animal.home,
        'dateExit': animal.dateExit,
      };

      log(DateTime.now().toIso8601String());

      // Faça a requisição PATCH para atualizar o animal
      Response response = await dio.patch(
        endpoint,
        data: animalData, // Envie o mapa de dados como JSON
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

      // Verifique a resposta da API
      if (response.statusCode == 200) {
        log('Animal atualizado com sucesso!');
      } else {
        throw Exception('Falha ao atualizar animal: ${response.statusCode}');
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

  Future<void> deleteAnimal(String animalId, String token) async {
    try {
      // Inclua o animalId como um parâmetro de consulta na URL
      String endpoint = '$url/animals?id=$animalId';

      Response response = await dio.delete(
        endpoint,
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

      if (response.statusCode == 200) {
        log('Animal excluído com sucesso!');
      } else {
        throw Exception('Falha ao excluir animal: ${response.statusCode}');
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
