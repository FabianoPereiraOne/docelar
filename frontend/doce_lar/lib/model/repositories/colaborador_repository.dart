import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart'; // Import do CustomDio
import 'package:doce_lar/model/models/user_model.dart';

class ColaboradorRepository {
  final CustomDio dio;

  ColaboradorRepository(this.dio);

  // Método para buscar colaboradores
  Future<List<Usuario>> fetchColaboradores() async {
    try {
      String endpoint = '/collaborators';
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;

          if (data.containsKey('data') && data['data'] is List) {
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
      log(e.toString());
      rethrow;
    }
  }

  Future<String> addPartner(Usuario partner, String password) async {
    try {
      String endpoint = '/collaborators';
      Map<String, dynamic> partnerData = {
        'name': partner.name,
        'email': partner.email,
        'phone': partner.phone,
        'type': partner.type,
        'statusAccount': partner.statusAccount,
        'homes': partner.homes,
      };

      Response response = await dio.post(
        endpoint,
        data: partnerData,
        options: Options(headers: {
          "Password": password,
        }),
      );

      if (response.statusCode == 201) {
        String colaboradorId = response.data['data']['id'];
        log('Parceiro adicionado com sucesso com ID: $colaboradorId');
        return colaboradorId;
      } else {
        throw Exception('Falha ao adicionar parceiro: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateColaborador(Usuario colaborador, String? password) async {
    try {
      String endpoint = '/collaborators';
      Map<String, dynamic> colaboradorData = {
        'id': colaborador.id,
        'name': colaborador.name,
        'phone': colaborador.phone,
        'type': colaborador.type,
        'statusAccount': colaborador.statusAccount,
      };

      Response response = await dio.patch(
        endpoint,
        data: colaboradorData,
        options: Options(headers: {
          if (password != null) "Password": password, // Header condicional
        }),
      );

      if (response.statusCode == 200) {
        log('Colaborador atualizado com sucesso!');
      } else {
        throw Exception('Falha ao atualizar colaborador: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  Future<Usuario> fetchColaboradorById(String id) async {
    try {
      String endpoint = '/collaborators/$id';
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
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
      log(e.toString());
      rethrow;
    }
  }
}
