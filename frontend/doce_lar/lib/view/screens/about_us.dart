  import 'package:flutter/material.dart';

  class AboutUs extends StatelessWidget {
    const AboutUs({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/patinhas.png'), // caminho da imagem
                  fit: BoxFit.fill, // ajusta a imagem para cobrir o fundo
                  opacity: 0.5, // opacidade da imagem
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 30, left: 40, right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre nós',
                      style:
                          TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'O Aplicativo Doce Lar nasceu de um projeto integrador da faculdade, cujo objetivo é impactar positivamente uma instituição sem fins lucrativos utilizando a tecnologia. Ao escolher o Projeto Doce Lar, uma instituição dedicada ao resgate de animais, identificamos uma necessidade crítica: o controle das informações dos animais, que era realizado apenas por planilhas. Após conversas com os líderes da instituição, desenvolvemos um planejamento detalhado e apresentamos uma solução mobile, que hoje facilita o trabalho e a gestão do Projeto Doce Lar.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Agradecemos especialmente aos professores Patrick Vinicius e Henrique Bianor pela mentoria durante o desenvolvimento deste projeto, assim como a Jeff e Nany, do Projeto Doce Lar, pela confiança e pela oportunidade de colaborar com essa causa.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 40), // Espaço entre as seções
                    Text(
                      'Participantes',
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // Lista de participantes
                    ParticipantItem(
                      imagePath:
                          'images/maira.jpeg',
                      name: 'Maíra Rodrigues Barbosa',
                      role: 'Product Owner',
                    ),
                    ParticipantItem(
                      imagePath:
                          'images/willian.jpeg',
                      name: 'Willian Viana Valente',
                      role: 'Scrum Master',
                    ),
                    ParticipantItem(
                      imagePath:
                          'images/vinicius.webp', 
                      name: 'Vinicius de Morais G. Duarte',
                      role: 'Desenvolvedor Front-end',
                    ),
                    ParticipantItem(
                      imagePath:
                          'images/fabiano.jpeg', 
                      name: 'Fabiano Pereira Santos',
                      role: 'Desenvolvedor Back-end',
                    ),
                    ParticipantItem(
                      imagePath:
                          'images/eshilley.jpeg', 
                      name: 'Eshilley Gomes Zanatti',
                      role: 'Designer',
                    ),
                    ParticipantItem(
                      imagePath:
                          'images/gabriel.jpeg', 
                      name: 'Gabriel Rodrigues dos Santos',
                      role: 'Desenvolvedor Front-end e Tester',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }


class ParticipantItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;

  const ParticipantItem({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 30, // Tamanho da foto
          ),
          const SizedBox(width: 16),
          Expanded( // Para expandir o espaço de texto e permitir a quebra de linha
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.visible, // Configuração para visualizar o texto longo
                ),
                Text(
                  role,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
