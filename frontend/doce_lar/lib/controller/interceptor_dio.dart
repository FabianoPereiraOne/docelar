import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';

class CustomDio extends DioForNative {
  final LoginController loginController;

  CustomDio(this.loginController, BuildContext context) {
    options.baseUrl = "https://docelar-pearl.vercel.app";

    options.connectTimeout = const Duration(seconds: 30);
    options.receiveTimeout = const Duration(seconds: 30);
    options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Access-Control-Allow-Origin": "*",
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
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          TopSnackBar.show(context, 'Sessão expirada, faça login novamente', false);
        }
        return handler.next(error);
      },
    ));
  }
}
