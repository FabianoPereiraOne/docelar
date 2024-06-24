import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButtom({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 78, 159, 61),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final EdgeInsetsGeometry _padding =
        const EdgeInsets.only(top: 24, left: 36, right: 36);

    return Padding(
      padding: _padding,
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
