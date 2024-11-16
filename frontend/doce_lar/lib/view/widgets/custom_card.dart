import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String info1;
  final String info2;
  final VoidCallback onTap;
  final String? image;

  const CustomCard({
    super.key,
    required this.title,
    required this.info1,
    required this.info2,
    required this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110, // Altura ajustada para acomodar mais informações
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 144, 171, 76),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 2.0,
              offset: const Offset(2.0, 4.0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Coluna para as informações do animal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      info1,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      info2,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            // Coluna para a imagem do animal (se houver)
            if (image != null && image!.isNotEmpty) // Exibe imagem se estiver disponível
              Padding(
                padding: const EdgeInsets.only(top:8, left: 8, right: 20, bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'http://patrick.vps-kinghost.net:7001$image',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              const SizedBox(width: 80), // Se não houver imagem, ocupa o espaço
          ],
        ),
      ),
    );
  }
}
