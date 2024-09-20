import 'dart:developer';

import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:flutter/material.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:provider/provider.dart';

Future<void> showAddAnimalDialog(
  BuildContext context,
  List<Usuario> colaboradores,
  List<AnimalType> animalTypes,
  Function() onAnimalUpdated,
) async {
  String name = '';
  String? sex;
  bool castrated = false;
  String race = '';
  String linkPhoto = '1';
  AnimalType? selectedAnimalType;
  bool status = true;
  Usuario? selectedColaborador;
  Home? selectedHome;

  List<Home> homes = [];

  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false; // Adiciona a variável de estado de carregamento

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final animalRepository = AnimalRepository(customDio);

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void updateHomes(Usuario? colaborador) {
            if (colaborador != null) {
              homes = colaborador.homes
                      ?.map((homeJson) => Home.fromMap(homeJson))
                      .where((home) => home.status == true)
                      .toList() ??
                  [];

              if (homes.isEmpty) {
                selectedHome = null;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  TopSnackBar.show(
                    context,
                    'O colaborador selecionado não possui lares cadastrados.',
                    false,
                  );
                });
              } else {
                selectedHome = null;
              }
            } else {
              homes = [];
              selectedHome = null;
            }
          }

          List<DropdownMenuItem<Home>> homeItems = [
            const DropdownMenuItem<Home>(
              value: null,
              child: Text(''),
            ),
            ...homes.map((home) {
              return DropdownMenuItem<Home>(
                value: home,
                child: Text('${home.address}, ${home.number}'),
              );
            }),
          ];

          final sexOptions = {
            'Macho': 'M',
            'Fêmea': 'F',
          };

          return AlertDialog(
            title: const Text('Adicionar Novo Animal'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<Usuario>(
                      value: selectedColaborador,
                      decoration: const InputDecoration(
                          labelText: 'Selecione o Colaborador'),
                      items: colaboradores.map((colaborador) {
                        return DropdownMenuItem<Usuario>(
                          value: colaborador,
                          child: Text(colaborador.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedColaborador = value;
                          updateHomes(selectedColaborador);
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Colaborador é obrigatório';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<Home>(
                      value: selectedHome,
                      decoration: const InputDecoration(labelText: 'Lar'),
                      items: homeItems,
                      onChanged: (value) {
                        setState(() {
                          selectedHome = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione um lar';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: sex,
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items: sexOptions.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.value,
                          child: Text(entry.key),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sex = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Sexo é obrigatório';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<AnimalType>(
                      value: selectedAnimalType,
                      decoration:
                          const InputDecoration(labelText: 'Tipo de Animal'),
                      items: animalTypes.map((type) {
                        return DropdownMenuItem<AnimalType>(
                          value: type,
                          child: Text(type.type ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAnimalType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Tipo de Animal é obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Raça'),
                      onChanged: (value) {
                        race = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Raça é obrigatória';
                        }
                        return null;
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Castrado'),
                      value: castrated,
                      onChanged: (value) {
                        setState(() {
                          castrated = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      controller: descriptionController,
                      maxLines: 5,
                      minLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Descrição é obrigatória';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                if (selectedHome == null) {
                                  TopSnackBar.show(context,
                                      'Por favor, selecione um lar', false);
                                  return;
                                }

                                setState(() {
                                  isLoading = true; // Ativa o carregamento
                                });

                                try {
                                  final newAnimal = Animal(
                                    name: name,
                                    description: descriptionController.text,
                                    sex: sex!,
                                    castrated: castrated,
                                    race: race,
                                    linkPhoto: linkPhoto,
                                    typeAnimalId: selectedAnimalType!.id,
                                    status: status,
                                    home: selectedHome,
                                  );

                                  await animalRepository.addAnimal(newAnimal);

                                  Navigator.of(context).pop();
                                  onAnimalUpdated();
                                  TopSnackBar.show(context,
                                      'Animal adicionado com sucesso', true);
                                } catch (e) {
                                  log(e.toString());
                                } finally {
                                  setState(() {
                                    isLoading =
                                        false; // Desativa o carregamento
                                  });
                                }
                              }
                            },
                      child: const Text('Adicionar'),
                    ),
            ],
          );
        },
      );
    },
  );
}
