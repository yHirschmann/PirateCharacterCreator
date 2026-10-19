import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizz de Personnalité',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizScreen(),
    );
  }
}

// ==========================================
// 1. MODÈLES DE DONNÉES
// ==========================================

class Profile {
  final String id;
  final String name;
  final String description;

  Profile({required this.id, required this.name, required this.description});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }
}

class Option {
  final String code;
  final String label;
  final Map<String, int> scores;

  Option({required this.code, required this.label, required this.scores});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      code: json['code'],
      label: json['label'],
      scores: Map<String, int>.from(json['scores']),
    );
  }
}

class Question {
  final int id;
  final String text;
  final List<Option> options;

  Question({required this.id, required this.text, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List;
    List<Option> optionsList = list.map((i) => Option.fromJson(i)).toList();
    
    return Question(
      id: json['id'],
      text: json['question'],
      options: optionsList,
    );
  }
}

// ==========================================
// 2. ÉCRAN DU QUESTIONNAIRE
// ==========================================

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  List<Profile> _profiles = [];
  
  // Conserve les scores de chaque profil
  final Map<String, int> _scores = {};
  
  int _currentQuestionIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Chargement des fichiers JSON
  Future<void> _loadData() async {
    try {
      // Chargement des profils
      final profileString = await rootBundle.loadString('assets/profile.json');
      final List<dynamic> profileJson = json.decode(profileString);
      _profiles = profileJson.map((p) => Profile.fromJson(p)).toList();

      // Initialisation de la map des scores dans l'ordre de la liste pour gérer les égalités
      for (var profile in _profiles) {
        _scores[profile.id] = 0;
      }

      // Chargement du quizz
      final quizzString = await rootBundle.loadString('assets/quizz.json');
      final List<dynamic> quizzJson = json.decode(quizzString);
      _questions = quizzJson.map((q) => Question.fromJson(q)).toList();

      // ==========================================
      // NOUVEAUTÉ : Mélanger les questions
      // ==========================================
      _questions.shuffle(); 

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des données: $e');
    }
  }

  void _answerQuestion(Option selectedOption) {
    // 1. Ajouter les points aux profils
    selectedOption.scores.forEach((profileId, points) {
      if (_scores.containsKey(profileId)) {
        _scores[profileId] = _scores[profileId]! + points;
      } else {
        _scores[profileId] = points; // Au cas où un profil n'est pas dans profile.json
      }
    });

    setState(() {
      _currentQuestionIndex++;
    });

    _checkEndCondition();
  }

  void _checkEndCondition() {
    int questionsAnswered = _currentQuestionIndex;
    
    // On cherche si un score a atteint 10
    bool hasReached10 = _scores.values.any((score) => score >= 10);
    bool hasReachedMinimumQuestions = questionsAnswered >= 5;
    bool isOutOfQuestions = _currentQuestionIndex >= _questions.length;

    // Conditions d'arrêt : 
    // - Plus de 5 questions répondues ET un score à 10
    // - OU on n'a plus de questions du tout
    if ((hasReachedMinimumQuestions && hasReached10) || isOutOfQuestions) {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    // Trouver le profil gagnant (Le premier profil avec le score le plus haut en cas d'égalité)
    String winnerId = _scores.keys.first;
    int maxScore = -1;

    // Vu que _scores a été initialisé dans l'ordre de la liste _profiles,
    // on respectera naturellement la règle de "prendre le premier en cas d'égalité"
    _scores.forEach((id, score) {
      if (score > maxScore) {
        maxScore = score;
        winnerId = id;
      }
    });

    // Récupération de l'objet Profil complet
    Profile winningProfile = _profiles.firstWhere(
      (p) => p.id == winnerId,
      orElse: () => Profile(id: 'Inconnu', name: 'Inconnu', description: 'Profil non trouvé.'),
    );

    // Navigation vers la page de résultat
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(profile: winningProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Aucune question trouvée.")),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: currentQuestion.options.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = currentQuestion.options[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () => _answerQuestion(option),
                    child: Text(
                      option.label,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. ÉCRAN DE RÉSULTAT
// ==========================================

class ResultScreen extends StatelessWidget {
  final Profile profile;

  const ResultScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre Personnalité'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vous êtes :',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 16),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                profile.description,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // Relancer le test
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                },
                child: const Text('Recommencer le test'),
              )
            ],
          ),
        ),
      ),
    );
  }
}