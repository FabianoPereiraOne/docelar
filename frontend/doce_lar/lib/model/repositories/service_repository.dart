import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Importando o CustomDio
import 'package:doce_lar/model/models/service_model.dart';

class ServiceRepository {
  final CustomDio dio;

  // O construtor agora recebe uma instância do CustomDio
  ServiceRepository(this.dio);

  // Método para buscar serviços
  Future<List<Service>> fetchServices() async {
    try {
      String endpoint = '/services'; // URL simplificada
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;

          if (data.containsKey('data') && data['data'] is List) {
            return (data['data'] as List)
                .map<Service>((e) => Service.fromMap(e as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception('Formato de resposta inesperado');
          }
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar serviços: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para adicionar um serviço
  Future<void> addService(Service service) async {
    try {
      String endpoint = '/services';
      Map<String, dynamic> serviceData = {
        'description': service.description,
        'animalId': service.animal!.id, // Inclua o objeto Animal aqui
        'doctors': service.doctors?.map((doc) => {'id': doc.id}).toList(),
        'procedures': service.procedures?.map((proc) => {'id': proc.id}).toList(),
      };

      Response response = await dio.post(endpoint, data: serviceData);

      if (response.statusCode == 201) {
        log('Serviço adicionado com sucesso!');
      } else {
        throw Exception('Falha ao adicionar serviço: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para atualizar um serviço
  Future<void> updateService(Service service) async {
    try {
      String endpoint = '/services/${service.id}'; // Adicionando o ID do serviço ao endpoint
      Map<String, dynamic> serviceData = service.toMap();

      Response response = await dio.patch(endpoint, data: serviceData);

      if (response.statusCode == 200) {
        log('Serviço atualizado com sucesso!');
      } else {
        throw Exception('Falha ao atualizar serviço: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para deletar um serviço
  Future<void> deleteService(String serviceId) async {
    try {
      String endpoint = '/services/$serviceId'; // Usando serviceId no endpoint

      Response response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        log('Serviço excluído com sucesso!');
      } else {
        throw Exception('Falha ao excluir serviço: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para buscar serviço por ID
  Future<Service> getServiceById(String id) async {
    try {
      String endpoint = '/services/$id'; // Ajuste o endpoint conforme necessário
      Response response = await dio.get(endpoint);

      log('Resposta da API para serviço por ID: ${response.data}'); // Log adicional

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          final data = responseData['data'];
          return Service.fromMap(data); // Certifique-se de que o método fromMap existe em Service
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar serviço: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }
}
