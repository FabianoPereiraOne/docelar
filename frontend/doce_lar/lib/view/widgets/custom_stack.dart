import 'package:flutter/material.dart';

class CustomStack extends StatelessWidget {
  final Image image;
  final double imageHeight;
  const CustomStack(
      {super.key, required this.imageHeight, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Sizedbox base para stack
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: imageHeight + 1,
        ),
        //Sizedbox para imagem de fundo
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: imageHeight,
          child: image,
        ),
        //posicionamento do container para efeito de sobreposição
        Positioned.fill(
          top: imageHeight - imageHeight * 0.16,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
