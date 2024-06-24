import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/models/user_model.dart';

class ColaboradoresController extends ChangeNotifier {
  final ColaboradoRepository repository;

  var isLoading = false;
  var hasData = false;
  var hasError = false;
  var errorMessage = '';

  List<Usuario> colaboradores = [];

  ColaboradoresController({
    required this.repository,
  });

  void updateState({
    bool isLoading = false,
    bool hasData = false,
    bool hasError = false,
    String errorMessage = '',
  }) {
    this.isLoading = isLoading;
    this.hasData = hasData;
    this.hasError = hasError;
    this.errorMessage = errorMessage;
    notifyListeners();
  }

  Future<void> fetchColaboradores(String token) async {
    log('Fetching colaboradores');
    updateState(isLoading: true);
    try {
      colaboradores = await repository.fetchColaboradores(token);
      updateState(hasData: true);
    } catch (e) {
      updateState(hasError: true, errorMessage: e.toString(), hasData: false);
    }
  }
}
