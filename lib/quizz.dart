import 'package:flutter/material.dart';
import 'model.dart';
import 'question_widget.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  final Map<String, int> _scores = {};

  // Exemple de données locales (normalement chargées depuis un Repository/JSON)
  final List<Question> _questions = const [
    Question(
      text: "Comment préférez-vous passer votre week-end ?",
      options: [
        Option(text: "En lisant un livre au calme", profileScores: {'analyste': 2, 'artiste': 1}),
        Option(text: "En faisant de l'escalade ou du sport", profileScores: {'action': 2}),
        Option(text: "En organisant une fête avec des amis", profileScores: {'social': 2}),
      ],
    ),
    Question(
      text: "Face à un problème complexe, quelle est votre première réaction ?",
      options: [
        Option(text: "Analyser toutes les données avant d'agir", profileScores: {'analyste': 2}),
        Option(text: "Faire confiance à votre instinct créatif", profileScores: {'artiste': 2}),
        Option(text: "Demander l'avis de votre entourage", profileScores: {'social': 2}),
      ],
    ),
  ];

  void _selectOption(Option option) {
    // Mise à jour des scores
    option.profileScores.forEach((profile, points) {
      _scores[profile] = (_scores[profile] ?? 0) + points;
    });

    // Passage à la question suivante ou affichage du résultat
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    // Identification du profil gagnant
    String topProfile = 'Inconnu';
    int maxScore = -1;

    _scores.forEach((profile, score) {
      if (score > maxScore) {
        maxScore = score;
        topProfile = profile;
      }
    });

    // Navigation vers la page de résultat
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(profileResult: topProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final double progress = (_currentQuestionIndex + 1) / _questions.length;

    return PopScope(
      canPop: false, // Empêche de quitter accidentellement en cours de quiz
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _showExitConfirmationDialog();
        if (shouldLeave == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // En-tête de la question
              QuestionHeader(questionText: currentQuestion.text),
              const SizedBox(height: 32),
              // Liste des options
              Expanded(
                child: ListView.separated(
                  itemCount: currentQuestion.options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final option = currentQuestion.options[index];
                    return OptionTile(
                      optionText: option.text,
                      onTap: () => _selectOption(option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter le quiz ?'),
        content: const Text('Toute votre progression sera perdue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }
}