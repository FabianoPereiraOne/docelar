
import 'dart:developer';

import 'package:dio/dio.dart';

class CepService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> buscarEnderecoPorCep(String cep) async {
    final String url = 'https://viacep.com.br/ws/$cep/json/';

    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        if (response.data.containsKey('erro')) {
          return null; // CEP inválido
        }
        return response.data; // Retorna os dados do endereço
      }
      return null;
    } catch (e) {
      log('Erro ao buscar CEP: $e');
      return null;
    }
  }
}
