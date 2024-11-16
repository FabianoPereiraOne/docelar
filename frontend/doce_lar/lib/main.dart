import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/login_repository.dart';
import 'package:doce_lar/view/screens/about_us.dart';
import 'package:doce_lar/view/screens/list/animal_list_screen.dart';
import 'package:doce_lar/view/screens/list/colaborador_list_screen.dart';
import 'package:doce_lar/view/screens/list/doctor_list_screen.dart';
import 'package:doce_lar/view/screens/home_screen.dart';
import 'package:doce_lar/view/screens/login_screen.dart';
import 'package:doce_lar/view/screens/list/procedure_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) => LoginController(repository: UsuarioRepository())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/procedures': (context) => const ProcedureListScreen(),
        '/doctors': (context) => const DoctorListScreen(),
        '/colaboradores': (context) => const ColaboradorListScreen(),
        '/animais': (context) => const AnimalListScreen(),
        '/about': (context) => const AboutUs(),
      },
    );
  }
}