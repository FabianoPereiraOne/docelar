import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/model/models/animal_model.dart';

class AnimalRepository {
  final CustomDio dio;

  AnimalRepository(this.dio); // Aceitando o CustomDio no construtor

  // Método para buscar animais
  Future<List<Animal>> fetchAnimais() async {
    try {
      String endpoint = 'animals'; // Endpoint relativo
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;

          if (data.containsKey('data') && data['data'] is List) {
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

  // Método para adicionar um animal
  Future<void> addAnimal(Animal animal) async {
    try {
      String endpoint = 'animals'; // Endpoint relativo
      Map<String, dynamic> animalData = {
        'name': animal.name,
        'description': animal.description,
        'sex': animal.sex,
        'castrated': animal.castrated,
        'race': animal.race,
        'typeAnimalId': animal.typeAnimalId,
        'homeId': animal.home?.id, // Certifique-se de que este ID é válido
      };

      Response response = await dio.post(
        endpoint,
        data: animalData,
      );

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

  // Método para atualizar um animal
  Future<void> updateAnimal(Animal animal) async {
    try {
      String endpoint = 'animals'; // Endpoint relativo
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

      Response response = await dio.patch(
        endpoint,
        data: animalData,
      );

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

  // Método para excluir um animal
  Future<void> deleteAnimal(String animalId) async {
    try {
      String endpoint = 'animals?id=$animalId'; // Endpoint relativo

      Response response = await dio.delete(
        endpoint,
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
