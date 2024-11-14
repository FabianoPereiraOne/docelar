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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/home.png'), // caminho da imagem
            fit: BoxFit.cover, // ajusta a imagem para cobrir o fundo
          ),
        ),
        child: Column(
          children: [
            Expanded(
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
                    text: "Animais",
                  ),
                // Outros botões visíveis apenas para outros tipos de usuários
                if (loginProvider.usuario.type != "USER") ...[
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/colaboradores');
                    },
                    text: "Colaboradores",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/animais');
                    },
                    text: "Animais",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/procedures');
                    },
                    text: "Procedimentos",
                  ),
                  CustomButtom(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/doctors');
                    },
                    text: "Médicos",
                  ),
                ],
              ],
            ),
          ),
        ),
            ),
            // Botão "Sobre Nós" fixado na parte inferior da tela
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CustomButtom(
                onPressed: () {
                  Navigator.of(context).pushNamed('/about');
                },
                text: "Sobre Nós",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
