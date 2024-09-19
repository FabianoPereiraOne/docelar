import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:doce_lar/controller/login_controller.dart';

class CustomDio extends DioForNative {
  final LoginController loginController;

  CustomDio(this.loginController) {
    options.baseUrl = "https://docelar-pearl.vercel.app/api"; // Definindo o baseUrl

    options.connectTimeout = const Duration(seconds: 30);
    options.receiveTimeout = const Duration(seconds: 30);
    options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {

        String token = loginController.token;
        if (token.isNotEmpty) {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
       onError: (DioException error, handler) async {
        if (error.response != null && error.response!.statusCode == 498) {
          loginController.token = '';
          log('token inválido pelo interceptor');
        }
        return handler.next(error);
      },
    ));
  }
}
