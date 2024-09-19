import 'package:doce_lar/view/screens/home_screen.dart';
import 'package:doce_lar/view/screens/building_screen.dart';
import 'package:doce_lar/view/widgets/menu.dart';
import 'package:flutter/material.dart';


class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> { 

  int _indiceAtual = 0;
  final List<Widget> _telas = [
    const HomeScreen(),
    const EmDesenvolvimentoScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: Menu(
        currentIndex: _indiceAtual,
        onTabTapped: onTabTapped,
      ),
    );
  }

  
  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

}