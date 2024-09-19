import 'dart:developer';

import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/login_repository.dart';
import 'package:flutter/material.dart';


class LoginController extends ChangeNotifier {
  final UsuarioRepository repository;

  var isLoading = false;
  var hasData = false;
  var hasError = false;
  var errorMessage = '';

  Usuario usuario = Usuario();
  String token = '';

  LoginController({
    required this.repository,
  });

  void updateState(
      {bool isLoading = false,
      bool hasData = false,
      bool hasError = false,
      String errorMessage = ''}) {
    this.isLoading = isLoading;
    this.hasData = hasData;
    this.hasError = hasError;
    this.errorMessage = errorMessage;
    notifyListeners();
  }

 


  Future<void> autenticaUsuario(String login, String senha) async {
    log('chegou no autenticaUsuario');
    try {
      final response = await repository.autenticar(login, senha);
      log('voltou para controller');
      usuario = response;
      token = response.authorization!;
      // log('$token');
      updateState(hasData: true);
    } catch (e) {
      updateState(hasError: true, errorMessage: e.toString(), hasData: false);
      //  throw '$e.toString()';
      // log(e.toString());
    }
  }
}
