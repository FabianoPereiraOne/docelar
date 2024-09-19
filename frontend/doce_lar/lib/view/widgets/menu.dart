import 'package:flutter/material.dart';


class Menu extends StatefulWidget {
  final void Function(int) onTabTapped;
  final int currentIndex;

  const Menu({super.key, required this.onTabTapped, required this.currentIndex});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 20,
      currentIndex: widget.currentIndex,
      items: _itens(),
      elevation: 10,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromARGB(255, 30, 81, 40),
      unselectedItemColor: const Color.fromARGB(255, 78, 159, 61),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: widget.onTabTapped,
    );
  }

  List<BottomNavigationBarItem> _itens() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
        backgroundColor: Colors.white,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Perfil',
        backgroundColor: Colors.white,
      ),
    ];
  }
}
