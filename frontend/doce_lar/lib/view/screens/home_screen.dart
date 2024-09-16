import 'package:flutter/material.dart';
import 'package:doce_lar/view/widgets/custom_buttom.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/home.png'), // caminho da imagem
                fit: BoxFit.cover, // ajusta a imagem para cobrir o fundo
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black.withOpacity(0.5),
                  //       spreadRadius: 5,
                  //       blurRadius: 10,
                  //       offset: Offset(0, 5),
                  //     ),
                  //   ],
                  //   // color: Color.fromARGB(255, 146, 194, 147),
                  //   borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(50),
                  //     bottomRight: Radius.circular(50),
                  //   ),
                  // ),
                ),
                CustomButtom(onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/colaboradores');
                }, text: "COLABORADORES"),
                CustomButtom(onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/animais');
                }, text: "ANIMAIS"),
                CustomButtom(onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/procedures');
                }, text: "PROCEDIMENTOS"),
                CustomButtom(onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/doctors');
                }, text: "MÉDICOS"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
