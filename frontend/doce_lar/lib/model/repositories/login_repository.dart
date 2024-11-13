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
    String endpoint = '$url/sign';
    Map<String, dynamic> body = {'email': login};
    Options options = Options(headers: {'password': senha});

    Response response = await dio.post(
      endpoint,
      data: jsonEncode(body),
      options: options,
    );

    // Acessando diretamente 'data' e 'authorization' da resposta
    var userData = response.data['data']; // Acessa os dados do usuário dentro de 'data'
    String authorization = response.data['authorization']; // Acessa o token de autorização diretamente

    // Mapeando os dados do usuário e atribuindo o token
    Usuario usuario = Usuario.fromMap(userData);
    usuario.authorization = authorization; // Atribuindo o token ao usuário

    return usuario;
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
