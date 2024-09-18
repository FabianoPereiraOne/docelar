import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/view/screens/dialog/add/endereco_dialog.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

Future<void> showColaboradorDialog(
    BuildContext context, Function() onColaboradorUpdate) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String selectedUserType = 'USER';
  final loginProvider = Provider.of<LoginController>(context, listen: false);

  Future<bool> isEmailInUse(String email) async {
    final colaboradorRepository = ColaboradorRepository();
    try {
      final colaboradores = await colaboradorRepository.fetchColaboradores(loginProvider.token);
      return colaboradores.any((colaborador) => colaborador.email == email);
    } catch (e) {
      TopSnackBar.show(context, 'Erro ao verificar e-mail', false);
      return false;
    }
  }

  Future<void> handleSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      final email = emailController.text;
      if (await isEmailInUse(email)) {
        TopSnackBar.show(context, 'Email em uso', false);
        return;
      }

      String formattedName = capitalizeWords(nameController.text);

      Usuario newColaborador = Usuario(
        name: formattedName,
        email: email,
        phone: phoneController.text,
        type: selectedUserType,
        statusAccount: true,
      );
      final colaboradorRepository = ColaboradorRepository();

      try {
        final String colaboradorId = await colaboradorRepository.addPartner(
          newColaborador,
          loginProvider.token,
          passwordController.text,
        );
        onColaboradorUpdate();
        Navigator.of(context).pop();
        TopSnackBar.show(context, 'Colaborador adicionado com sucesso!', true);
        showEnderecoDialog(context, colaboradorId, onColaboradorUpdate);
      } catch (e) {
        TopSnackBar.show(context, 'Erro ao adicionar colaborador', false);
      }
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Adicionar Colaborador'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Email inválido';
                    }
                    // Aqui não faremos a verificação assíncrona
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (value.length < 15) {
                      return 'Número de telefone inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (value != passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedUserType,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Usuário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  items: <String>['USER', 'ADMIN'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedUserType = newValue ?? 'USER';
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await handleSubmit();
            },
            child: const Text('Próximo'),
          ),
        ],
      );
    },
  );
}

String capitalizeWords(String input) {
  if (input.isEmpty) {
    return '';
  }
  return input.split(' ').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
