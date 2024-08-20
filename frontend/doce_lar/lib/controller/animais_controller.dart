import 'dart:developer';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:flutter/material.dart';
import 'package:doce_lar/model/models/animal_model.dart';

class AnimalController extends ChangeNotifier {
  final AnimalRepository repository;

  var isLoading = false;
  var hasData = false;
  var hasError = false;
  var errorMessage = '';

  List<Animal> animals = [];

  AnimalController({
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

  Future<void> fetchAnimals(String token) async {
    log('Fetching animals');
    updateState(isLoading: true);
    try {
      animals = await repository.fetchAnimais(token);
      updateState(hasData: true);
    } catch (e) {
      updateState(hasError: true, errorMessage: e.toString(), hasData: false);
    }
  }
}
