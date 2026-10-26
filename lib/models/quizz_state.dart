
import 'package:personality_quizz/models/archetype.dart';
import 'package:personality_quizz/models/character_sheet.dart';
import 'package:personality_quizz/models/question.dart';
import 'package:personality_quizz/models/talent.dart';

/// Classe de base scellée : toutes les sous-classes doivent être dans ce fichier.
/// Le compilateur Dart connaît ainsi la liste exacte et finie de tous les états possibles.
sealed class QuizzState {
  const QuizzState();
}

/// 1. Chargement initial des JSON
class QuizzLoading extends QuizzState {
  const QuizzLoading();
}

/// 2. Phase de questions-réponses
class QuizzQuestionning extends QuizzState{
  final Question currentQuestion;
  final int questionNumber;

  const QuizzQuestionning({
    required this.currentQuestion,
    required this.questionNumber,
  });
}

/// 3. Égalité (>= 12 points sur plusieurs archétypes simultanément)
class QuizzTieBreaker extends QuizzState {
  final List<Archetype> tiedArchetypes;

  const QuizzTieBreaker({required this.tiedArchetypes});
}

/// 4. Révélation de l'archétype, choix du talent et répartition des 11 points
class QuizzCustomization extends QuizzState {
  static const int totalFocusPoints = 11;

  final Archetype finalArchetype;
  final Map<String, int> allocatedFocusPoints;
  final Talent? selectedTalent;

  int get remainingFocusPoint {
    final int usedPoints = allocatedFocusPoints.values.fold(0, (sum, value) => sum + value -1);
    return totalFocusPoints - usedPoints;
  }

  const QuizzCustomization({
    required this.allocatedFocusPoints,
    required this.finalArchetype,
    required this.selectedTalent,
  });

  factory QuizzCustomization.initial(Archetype archetype){
    return QuizzCustomization(
            allocatedFocusPoints: Map.fromEntries(archetype.focus.map((e) => MapEntry(e, 1))), 
            finalArchetype: archetype, 
            selectedTalent: null);
  }
}

/// 5. Fiche finale générée au format texte brut
class QuizzSummary extends QuizzState {
  final CharacterSheet characterSheet;

  const QuizzSummary({
    required this.characterSheet,
  });
}