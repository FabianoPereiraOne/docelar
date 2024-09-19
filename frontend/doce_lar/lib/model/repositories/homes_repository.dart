import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Importando o CustomDio
import 'package:doce_lar/model/models/homes_model.dart';

class HomeRepository {
  final CustomDio dio; // Usando o CustomDio

  // O construtor agora recebe uma instância do CustomDio
  HomeRepository(this.dio);

  // Método para buscar casas
  Future<List<Home>> fetchHomes() async {
    try {
      String endpoint = '/homes';  // Não precisa da URL completa, pois o CustomDio já gerencia isso
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;

          if (data.containsKey('data') && data['data'] is List) {
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
      log('Erro ao buscar casas: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<Home> fetchHomeById(String homeId) async {
    try {
      String endpoint = '/homes/$homeId';
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          return Home.fromMap(data);
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar casa: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro ao buscar casa: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateHome(Home home) async {
    try {
      String endpoint = '/homes';

      Map<String, dynamic> homeData = {
        'id': home.id,
        'cep': home.cep,
        'state': home.state,
        'city': home.city,
        'district': home.district,
        'address': home.address,
        'number': home.number,
        'status': home.status,
      };

      Response response = await dio.patch(
        endpoint,
        data: homeData,
      );

      if (response.statusCode == 200) {
        log('Casa atualizada com sucesso!');
      } else {
        throw Exception('Falha ao atualizar casa: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro ao atualizar casa: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteHome(String homeId) async {
    try {
      String endpoint = '/homes?id=$homeId';

      Response response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        log('Casa excluída com sucesso!');
      } else {
        throw Exception('Falha ao excluir casa: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro ao excluir casa: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> addHome(Home home) async {
    try {
      String endpoint = '/homes';

      Map<String, dynamic> homeData = {
        'collaboratorId': home.collaboratorId,
        'cep': home.cep,
        'state': home.state,
        'city': home.city,
        'district': home.district,
        'address': home.address,
        'number': home.number,
        'status': home.status,
      };

      Response response = await dio.post(endpoint, data: homeData);

      if (response.statusCode == 201) {
        log('Endereço adicionado com sucesso!');
      } else {
        throw Exception('Falha ao adicionar endereço: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro ao adicionar endereço: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }
}
