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
            "Authorization":
                "$token" // Usando o formato correto de Bearer token
          }));

      if (response.statusCode == 200) {
        // Verificar se response.data é um Map
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;
          // log(data.toString());

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

   Future<Home> fetchHomeById(String homeId, String token) async {
    try {
      String endpoint = '$url/homes/$homeId';
     // log('Endpoint da solicitação: $endpoint'); // Log do endpoint

      Response response = await dio.get(endpoint,
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "$token"
          }));

    //  log('Resposta do servidor ao buscar casa por ID: ${response.data}'); // Log da resposta

      if (response.statusCode == 200) {
        // Acesse o campo 'data' da resposta
        final data = response.data['data'];
       // log('Dados recebidos: $data'); // Log dos dados recebidos

        if (data is Map<String, dynamic>) {
          return Home.fromMap(data);
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      } else {
        throw Exception('Falha ao buscar casa: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
       // log('Erro na solicitação: ${e.response?.statusCode} - ${e.response?.statusMessage}');
       // log('Resposta do servidor: ${e.response?.data}');
      } else {
      //  log('Erro na solicitação: ${e.message}');
      }
      throw e;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      throw e;
    }
  }

    Future<void> updateHome(Home home, String token) async {
    try {
      // Defina o endpoint da API
      String endpoint = '$url/homes';


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

      // Faça a requisição PATCH para atualizar a casa
      Response response = await dio.patch(
        endpoint,
        data: homeData, // Envie o mapa de dados como JSON
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

      // Verifique a resposta da API
      if (response.statusCode == 200) {
        log('Casa atualizada com sucesso!');
      } else {
        throw Exception('Falha ao atualizar casa: ${response.statusCode}');
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

  Future<void> deleteHome(String homeId, String token) async {
    try {
      // Inclua o homeId como um parâmetro de consulta na URL
      String endpoint = '$url/homes?id=$homeId';

      Response response = await dio.delete(
        endpoint,
        options: Options(headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "$token"
        }),
      );

      if (response.statusCode == 200) {
        log('Casa excluída com sucesso!');
      } else {
        throw Exception('Falha ao excluir casa: ${response.statusCode}');
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

  Future<void> addHome(Home home, String token) async {
  try {
    // Defina o endpoint da API
    String endpoint = '$url/homes';

    // Crie um mapa de dados com todos os campos necessários
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

    // Faça a requisição POST para adicionar o endereço
    Response response = await dio.post(
      endpoint,
      data: homeData, // Envie o mapa de dados como JSON
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": "$token"
      }),
    );

    // Verifique a resposta da API
    if (response.statusCode == 201) {
      log('Endereço adicionado com sucesso!');
    } else {
      throw Exception('Falha ao adicionar endereço: ${response.statusCode}');
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
