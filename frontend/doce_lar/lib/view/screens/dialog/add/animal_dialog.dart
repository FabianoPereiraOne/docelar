
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
  String? sex; // Alterado para ser nullable
  bool castrated = false;
  String race = '';
  String linkPhoto = '1';
  int? typeAnimalId;
  bool status = true; // status será sempre true e não pode ser alterado
  final descriptionController = TextEditingController();
  Usuario? selectedColaborador;
  
  // Lista local de lares, inicializada quando o colaborador é selecionado
  List<Home> homes = [];

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                      decoration: const InputDecoration(labelText: 'Selecione o Colaborador'),
                      items: colaboradores.map((colaborador) {
                        return DropdownMenuItem(
                          value: colaborador,
                          child: Text(colaborador.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedColaborador = value;
                          homes = selectedColaborador?.homes?.map((homeJson) => Home.fromMap(homeJson)).toList() ?? [];
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Colaborador é obrigatório';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: sex,
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items: const [
                        DropdownMenuItem(value: 'M', child: Text('Macho')),
                        DropdownMenuItem(value: 'F', child: Text('Fêmea')),
                      ],
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
                    DropdownButtonFormField<int>(
                      value: typeAnimalId,
                      decoration: const InputDecoration(labelText: 'Tipo de Animal'),
                      items: animalTypes.map((type) {
                        return DropdownMenuItem(
                          value: type.id,
                          child: Text(type.type ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          typeAnimalId = value;
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
                    // TextField(
                    //   decoration: const InputDecoration(labelText: 'Link da Foto'),
                    //   onChanged: (value) {
                    //     linkPhoto = value;
                    //   },
                    // ),
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
              ElevatedButton(
                child: const Text('Continuar'),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    if (homes.isEmpty) {
                      TopSnackBar.show(context, 'Colaborador selecionado não possui lares cadastrados.', false);
                      return;
                    }
                    Navigator.of(context).pop();
                    await showSelectHomeDialog(
                      context,
                      name: name,
                      sex: sex!,
                      castrated: castrated,
                      race: race,
                      linkPhoto: linkPhoto,
                      typeAnimalId: typeAnimalId!,
                      status: status,
                      description: descriptionController.text,
                      homes: homes,
                      callback: onAnimalUpdated,
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}


Future<void> showSelectHomeDialog(
  BuildContext context, {
  required String name,
  required String sex,
  required bool castrated,
  required String race,
  required String linkPhoto,
  required int typeAnimalId,
  required bool status,
  required String description,
  required List<Home> homes,
  required Function() callback,
}) async {
  Home? selectedHome;

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Lar do Animal'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Home>(
                      value: selectedHome,
                      decoration: const InputDecoration(labelText: 'Selecione o Lar'),
                      items: homes.map((home) {
                        return DropdownMenuItem<Home>(
                          value: home,
                          child: Text('${home.address}, ${home.number}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHome = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um lar';
                        }
                        return null;
                      },
                    ),
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
              ElevatedButton(
                child: const Text('Concluir'),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    if (selectedHome == null) {
                      TopSnackBar.show(context, 'Por favor, selecione um lar', false);
                      return;
                    }

                    final loginProvider = Provider.of<LoginController>(context, listen: false);
                    final animalRepository = AnimalRepository();

                    try {
                      final newAnimal = Animal(
                        name: name,
                        description: description,
                        sex: sex,
                        castrated: castrated,
                        race: race,
                        linkPhoto: linkPhoto,
                        typeAnimalId: typeAnimalId,
                        status: status,
                        homeId: selectedHome!.id,
                      );

                      await animalRepository.addAnimal(newAnimal, loginProvider.token);

                      Navigator.of(context).pop();
                      callback();
                      TopSnackBar.show(context, 'Animal adicionado com sucesso', true);
                    } catch (e) {
                      TopSnackBar.show(context, 'Erro ao adicionar animal', false);
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
