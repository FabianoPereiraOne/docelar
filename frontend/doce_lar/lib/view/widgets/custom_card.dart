import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,  // Aumentei a altura para acomodar mais informações
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 2, 240, 41),
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
      child: Center(
        child: ListTile(
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                email,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                phone,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
