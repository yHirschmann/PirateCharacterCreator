import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:personality_quizz/models/archetype.dart';
import 'package:personality_quizz/models/question.dart';
import 'package:personality_quizz/models/quizz_config.dart';

class DataRepository {

  Future<List<Archetype>> loadArchetypes() async {
    // 1. Lecture du fichier texte depuis les assets
    final String jsonString = await rootBundle.loadString('assets/data/Archetypes.json');
    
    // 2. Décodage de la chaîne JSON (la racine de Archetypes.json est une Liste)
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    
    // 3. Mapping vers nos objets Dart
    return jsonList
        .map((json) => Archetype.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Question>> loadQuestions() async {
    // 1. Lecture du fichier texte depuis les assets
    final String jsonString = await rootBundle.loadString('assets/data/Questionnaire.json');
    
    // 2. Décodage de la chaîne JSON (la racine de Questionnaire.json est un objet)
    final Map<String, dynamic> jsonList = jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> questionsList = jsonList["questions"] as List<dynamic>;
    
    // 3. Mapping vers nos objets Dart
    return questionsList
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<QuizzConfig> loadQuizzConfig() async {
    // 1. Lecture du fichier texte depuis les assets
    final String jsonString = await rootBundle.loadString('assets/data/Questionnaire.json');

    // 2. Décodage de la chaîne JSON (la racine de Questionnaire.json est un objet)
    final Map<String, dynamic> rootMap = jsonDecode(jsonString) as Map<String, dynamic>;

    // 2. "quizz_config" est un objet unique, pas une liste
    return QuizzConfig.fromJson(rootMap["quizz_config"] as Map<String, dynamic>);
  }
}