import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Importando o CustomDio
import 'package:doce_lar/model/models/procedure_model.dart';

class ProcedureRepository {
  final CustomDio dio; // Usando o CustomDio

  // O construtor agora recebe uma instância do CustomDio
  ProcedureRepository(this.dio);

  // Método para buscar procedimentos
  Future<List<Procedure>> fetchProcedures() async {
    try {
      String endpoint = '/procedures'; // Não precisa da URL completa, o CustomDio já gerencia isso
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;
          // log(data.toString());

          if (data.containsKey('data') && data['data'] is List) {
            // Mapeia os dados para uma lista de procedimentos
            return (data['data'] as List)
                .map<Procedure>((e) => Procedure.fromMap(e as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception('Formato de resposta inesperado');
          }
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar procedimentos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para adicionar um procedimento
  Future<String> addProcedure(Procedure procedure) async {
    try {
      String endpoint = '/procedures';

      Map<String, dynamic> procedureData = {
        'name': procedure.name,
        'description': procedure.description,
        'dosage': procedure.dosage,
      };

      Response response = await dio.post(
        endpoint,
        data: procedureData,
      );

      if (response.statusCode == 201) {
        String procedureId = response.data['data']['id'].toString();
        log('Procedimento adicionado com sucesso com ID: $procedureId');
        return procedureId;
      } else {
        throw Exception('Falha ao adicionar procedimento: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para atualizar um procedimento
  Future<void> updateProcedure(Procedure procedure) async {
    try {
      String endpoint = '/procedures';


      Map<String, dynamic> procedureData = {
        'id': procedure.id,
        'name': procedure.name,
        'description': procedure.description,
        'dosage': procedure.dosage,
      };

      Response response = await dio.patch(
        endpoint,
        data: procedureData,
      );

      if (response.statusCode == 200) {
        log('Procedimento atualizado com sucesso!');
      } else {
        throw Exception('Falha ao atualizar procedimento: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      rethrow;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }

  // Método para excluir um procedimento
  Future<void> deleteProcedure(int procedureId) async {
    try {
      String endpoint = '/procedures/$procedureId';

      Response response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        log('Procedimento excluído com sucesso!');
      } else {
        throw Exception('Falha ao excluir procedimento: ${response.statusCode}');
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
