import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/model/models/user_model.dart';

class UsuarioRepository {
  final String url = 'http://patrick.vps-kinghost.net:7001';

  final dio = Dio();



  Future<Usuario> autenticar(String login, String senha) async {
    log('chegou no repository');
    try {
      // Endpoint para autenticação
      String endpoint = '$url/sign';

      // Corpo da requisição (email como JSON no corpo)
      Map<String, dynamic> body = {
        'email': login,
      };

      // Cabeçalho da requisição (senha como header)
      Options options = Options(headers: {
        'password': senha,
      });

      // Envia a requisição POST
      Response response = await dio.post(
        endpoint,
        data: jsonEncode(body), // Codifica o corpo como JSON
        options: options, // Adiciona o cabeçalho com a senha
      );

      return Usuario.fromMap(response.data);
      // Supondo que o token esteja na resposta como um campo 'token'
    } on DioException catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
  }
}
  //   try {
  //     final response = await dio.get(url + endPoint,
  //         options: Options(headers: {
  //           "Accept": "application/json",
  //           "Access-Control_Allow_Origin": "*",
  //           "Authorization": "Basic {}}",
  //         }));
  //     return Usuario.fromMap(response.data);
  //   } on DioException catch (e, s) {
  //     log(e.toString(), error: e, stackTrace: s);
  //     throw e;
  //   }
  // }
