import 'package:flutter/material.dart';
import 'package:personality_quizz/screens/quizz_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Création de Personnage', // Titre de l'onglet du navigateur Web
      // debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const QuizzScreen(),
    );
  }
}