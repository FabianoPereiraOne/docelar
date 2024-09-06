import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/model/models/procedure_model.dart';

class ProcedureRepository {
  final String url = 'https://docelar-pearl.vercel.app';
  final dio = Dio();

  // Método para buscar procedimentos
  Future<List<Procedure>> fetchProcedures(String token) async {
    try {
      String endpoint = '$url/procedures';
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

  Future<String> addProcedure(Procedure procedure, String token) async {
  try {
    String endpoint = '$url/procedures';

    Map<String, dynamic> procedureData = {
      'name': procedure.name,
      'description': procedure.description,
      'dosage': procedure.dosage,
    };

    Response response = await dio.post(
      endpoint,
      data: procedureData,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    if (response.statusCode == 201) {
      String procedureId = response.data['data']['id'].toString();
      log('Procedimento adicionado com sucesso com ID: $procedureId');
      return procedureId;
    } else {
      throw Exception('Falha ao adicionar procedimento: ${response.statusCode}');
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

Future<void> updateProcedure(Procedure procedure, String token) async {
  try {
    String endpoint = '$url/procedures/${procedure.id}';

    Map<String, dynamic> procedureData = {
      'name': procedure.name,
      'description': procedure.description,
      'dosage': procedure.dosage,
    };

    Response response = await dio.patch(
      endpoint,
      data: procedureData,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    if (response.statusCode == 200) {
      log('Procedimento atualizado com sucesso!');
    } else {
      throw Exception('Falha ao atualizar procedimento: ${response.statusCode}');
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


Future<void> deleteProcedure(int procedureId, String token) async {
  try {
    String endpoint = '$url/procedures/$procedureId';

    Response response = await dio.delete(
      endpoint,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    if (response.statusCode == 200) {
      log('Procedimento excluído com sucesso!');
    } else {
      throw Exception('Falha ao excluir procedimento: ${response.statusCode}');
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
