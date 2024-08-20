import 'dart:developer';

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/view/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginController>(context);
    return Scaffold(
      body: SingleChildScrollView(
        //container geral
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
                        color: Colors.black
                            .withOpacity(0.5), // Cor da sombra com opacidade
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
                CustomButtom(onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/colaboradores');
                }, text: "COLABORADORES"),
                CustomButtom(onPressed: (){}, text: "LARES"),
                CustomButtom(onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/animais');
                }, text: "ANIMAIS"),
                CustomButtom(onPressed: (){}, text: "text"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
