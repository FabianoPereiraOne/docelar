import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/model/models/user_model.dart';

class ColaboradorRepository {
  final String url = 'https://docelar-pearl.vercel.app';

  final dio = Dio();

  // Novo método para buscar colaboradores
  Future<List<Usuario>> fetchColaboradores(String token) async {
    try {
      String endpoint = '$url/collaborators';
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
          // log(data.toString());

          if (data.containsKey('data') && data['data'] is List) {
            // Mapeia os dados para uma lista de usuários
            return (data['data'] as List)
                .map<Usuario>((e) => Usuario.fromMap(e as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception('Formato de resposta inesperado');
          }
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar colaboradores: ${response.statusCode}');
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

Future<String> addPartner(Usuario partner, String token, String password) async {
  try {
    // Defina o endpoint da API
    String endpoint = '$url/collaborators';

    // Crie um mapa de dados com todos os campos necessários
    Map<String, dynamic> partnerData = {
      'name': partner.name,
      'email': partner.email,
      'phone': partner.phone,
      'type': partner.type,
      'statusAccount': partner.statusAccount,
      'homes': partner.homes, // se necessário
    };

    // Faça a requisição POST para adicionar o parceiro
    Response response = await dio.post(
      endpoint,
      data: partnerData, // Envie o mapa de dados como JSON
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token",
        "Password": password
      }),
    );

    // Verifique a resposta da API
    if (response.statusCode == 201) {
      // Extrair o ID do colaborador da resposta
      String colaboradorId = response.data['data']['id'];
      log('Parceiro adicionado com sucesso com ID: $colaboradorId');
      return colaboradorId;
    } else {
      throw Exception('Falha ao adicionar parceiro: ${response.statusCode}');
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

Future<void> updateColaborador(Usuario colaborador, String token, String? password) async {
  try {
    // Defina o endpoint da API
    String endpoint = '$url/collaborators';

    // Crie um mapa de dados com todos os campos necessários
    Map<String, dynamic> colaboradorData = {
      'id': colaborador.id,
      'name': colaborador.name,
      'phone': colaborador.phone,
      'role': colaborador.type,
      'statusAccount': colaborador.statusAccount,
    };

    // Faça a requisição PATCH para atualizar o colaborador
    Response response = await dio.patch(
      endpoint,
      data: colaboradorData, // Envie o mapa de dados como JSON
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token",
        "Password": password
      }),
    );

    // Verifique a resposta da API
    if (response.statusCode == 200) {
      log('Colaborador atualizado com sucesso!');
    } else {
      throw Exception('Falha ao atualizar colaborador: ${response.statusCode}');
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

Future<void> deleteColaborador(String colaboradorId, String token) async {
  try {
    // Defina o endpoint da API
    String endpoint = '$url/collaborators?id=$colaboradorId';

    Response response = await dio.delete(
      endpoint,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    if (response.statusCode == 200) {
      log('Colaborador excluído com sucesso!');
    } else {
      throw Exception('Falha ao excluir colaborador: ${response.statusCode}');
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

Future<Usuario> fetchColaboradorById(String id, String token) async {
  try {
    String endpoint = '$url/collaborators/$id';
    Response response = await dio.get(
      endpoint,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    log('Resposta da API para colaborador por ID: ${response.data}'); // Log adicional

    if (response.statusCode == 200) {
      // Verifique a estrutura da resposta e mapeie corretamente
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        final data = responseData['data'];
        return Usuario.fromMap(data);
      } else {
        throw Exception('Formato de resposta inesperado');
      }
    } else {
      throw Exception('Falha ao buscar colaborador: ${response.statusCode}');
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
