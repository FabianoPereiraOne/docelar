import 'package:flutter/material.dart';
import 'package:doce_lar/view/widgets/custom_buttom.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/controller/login_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginController>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/home.png'), // caminho da imagem
                fit: BoxFit.cover, // ajusta a imagem para cobrir o fundo
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                ),
                // Botão "Animais" visível apenas para usuários do tipo USER
                if (loginProvider.usuario.type == "USER")
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/animais');
                    },
                    text: "ANIMAIS",
                  ),
                // Outros botões visíveis apenas para outros tipos de usuários
                if (loginProvider.usuario.type != "USER") ...[
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/colaboradores');
                    },
                    text: "COLABORADORES",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/animais');
                    },
                    text: "ANIMAIS",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/procedures');
                    },
                    text: "PROCEDIMENTOS",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/doctors');
                    },
                    text: "MÉDICOS",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/teste');
                    },
                    text: "UPLOAD",
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
