// import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'dart:developer';

import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/view/widgets/custom_input.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;

  final EdgeInsetsGeometry _padding =
      const EdgeInsets.only(top: 24, left: 36, right: 36);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginController>(context);
    login() async {
      log('chegou no login');
      await loginProvider.autenticaUsuario(
          _usernameController.text.trim(), _passwordController.text.trim());
      if (loginProvider.hasData) {
        Navigator.of(context).pushReplacementNamed('/base');
        //Navigator.pushNamed(context, '/home');
      } else {
        AsukaSnackbar.alert('Usuário ou senha inválidos');
      }
    }

      return Scaffold(
        body: SingleChildScrollView(
          //container geral
          child: Form(
            key: formKey,
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                color: Colors.white,
                //coluna geral
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                                0.5), // Cor da sombra com opacidade
                            spreadRadius: 5, // O quanto a sombra se espalha
                            blurRadius: 10, // Quão suave a borda da sombra é
                            offset: Offset(0,
                                5), // Deslocamento horizontal e vertical da sombra
                          ),
                        ],
                        color: Color.fromARGB(255, 146, 194, 147),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      //sombreamento para o container
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 146, 194, 147),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            //container com os campos de login
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 146, 194, 147),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: _padding,
                                      child: CustomInput(
                                          validatorText: 'Informe o usuário',
                                          hintText: 'Usuário',
                                          icon: Icons.person_outlined,
                                          controller: _usernameController)),
                                  Padding(
                                      padding: _padding,
                                      child: CustomInput(
                                          validatorText: 'Informe a senha',
                                          hintText: 'Senha',
                                          icon: Icons.lock_outline,
                                          controller: _passwordController)),
                                  //padding botão de login
                                  Padding(
                                    padding: _padding,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          
                                          // Navigator.of(context).pushReplacementNamed('/base');
                                          if (formKey.currentState != null &&
                                              formKey.currentState!
                                                  .validate()) {
                                            login();
                                            log(loginProvider.token);
                                   
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 78, 159, 61),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Entrar',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 146, 194, 147),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

