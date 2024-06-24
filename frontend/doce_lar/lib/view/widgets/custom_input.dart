import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';


class CustomInput extends StatelessWidget {
  final String hintText;
  final String validatorText;
  final IconData icon;
  final TextEditingController controller;

  const CustomInput({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller, required this.validatorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 2.0,
            offset: const Offset(2.0, 4.0),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: TextFormField(   
              obscureText: hintText == 'Senha' ? true : false,          
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 60, bottom: 10),
              ),
              validator: Validatorless.multiple(
                    [Validatorless.required('Informe um usuario')]),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 224, 224, 224),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.grey.shade700,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
