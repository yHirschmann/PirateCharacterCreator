
import 'package:flutter/foundation.dart';
import 'package:personality_quizz/models/archetype.dart';
import 'package:personality_quizz/models/character_sheet.dart';
import 'package:personality_quizz/models/question.dart';
import 'package:personality_quizz/models/quizz_config.dart';
import 'package:personality_quizz/models/quizz_state.dart';
import 'package:personality_quizz/models/response.dart';
import 'package:personality_quizz/models/talent.dart';
import 'package:personality_quizz/services/repository/data_repository.dart';

class QuizzController extends ChangeNotifier {
  static const int victoryThreshold = 10;

  int _numberQuestion = 1;

  final DataRepository repository = DataRepository();
  QuizzConfig? quizzConfig;

  final Map<int, int> _score = {};
  List<Archetype> _archetypes = [];
  List<Question> _allQuestions = [];
  List<Question> _remainingQuestions = [];

  QuizzState _state = const QuizzLoading();
  QuizzState get state => _state;

  Future<void> init() async {
    quizzConfig = await repository.loadQuizzConfig();
    _allQuestions = await repository.loadQuestions();
    _archetypes = await repository.loadArchetypes();

    _score.addEntries(_archetypes.map((e) => MapEntry(e.id, 0)));

    startNewQuizz();
  }

  void startNewQuizz(){
    _numberQuestion = 1;
    _score.updateAll((key, value) => 0);
    
    _refillAndShuffleDeck();

    var firstQuestion = _drawNextQuestion();
    _emit(QuizzQuestionning(currentQuestion: firstQuestion, questionNumber: _numberQuestion));
  }

  void answerQuestion(Response response){
    if (_state is! QuizzQuestionning) {
      throw StateError('TODO');
    }

    for (var e in response.effects) {
      _addPoints(e.archetypeId, e.points);
    }

    if(_score.entries.every((e) => e.value < victoryThreshold)){
      _numberQuestion++;
      var question = _drawNextQuestion();
      _emit(QuizzQuestionning(currentQuestion: question, questionNumber: _numberQuestion));
    }
    else{
      var winningIds = _score.entries.where((entry) => entry.value >= victoryThreshold).map((entry) => entry.key).toList();
      var winners = _archetypes.where((arch) => winningIds.contains(arch.id)).toList();
      
      if(winners.length > 1){
        _emit(QuizzTieBreaker(tiedArchetypes: winners));

      }
      else{
        _emit(QuizzCustomization.initial(winners.first));
      }
    }
  }

  void resolveTie(Archetype chosenArchetype){
    if (_state is! QuizzTieBreaker) {
      throw StateError('TODO');
    }

    _emit(QuizzCustomization.initial(chosenArchetype));
  }

  void updateFocusPoint(String focusName, int delta){
    if (_state case final QuizzCustomization current) {

      if(delta > current.remainingFocusPoint){
        throw StateError('Il ne reste pas assez de points de spécialités à répartir.');
      }

      var allocatedFocusPoints = {...current.allocatedFocusPoints};
      var totalPoints = (allocatedFocusPoints[focusName] ?? 1) + delta;

      if(totalPoints < 1 || totalPoints > 5){
        throw StateError('Erreur, le nombre de point pour la spécialité $focusName est incorrecte');
      }
      else{
        allocatedFocusPoints[focusName] = totalPoints;
      }

      _emit(QuizzCustomization(
                allocatedFocusPoints: allocatedFocusPoints, 
                finalArchetype: current.finalArchetype, 
                selectedTalent: current.selectedTalent));
    }
    else{
      throw StateError('TODO');
    }
  }

  void selectTalent(Talent talent){
    if (_state case final QuizzCustomization current) {
      _emit(QuizzCustomization(
              allocatedFocusPoints: current.allocatedFocusPoints,
              finalArchetype: current.finalArchetype, 
              selectedTalent: talent));
    }
    else{
      throw StateError('TODO');
    }
  }

  void validateCharacter(){
    if (_state case final QuizzCustomization current) {
      final selectedTalent = current.selectedTalent;
      if (selectedTalent == null) {
        throw StateError('Aucun talent choisis.');
      }
      
      if(current.remainingFocusPoint > 0){
        throw StateError('Il reste des points de spécialité à répartir.');
      }

      var characterSheet = CharacterSheet(
                            selectedArchetype: current.finalArchetype, 
                            focus: current.allocatedFocusPoints, 
                            selectedTalent: selectedTalent);

      _emit(QuizzSummary(characterSheet: characterSheet));
    }
    else{
      throw StateError('TODO');
    }
  }

  Question _drawNextQuestion() {
    if (_remainingQuestions.isEmpty) {
      _refillAndShuffleDeck();
    }
    // removeLast() retire et renvoie le dernier élément en O(1) (comme Pop() sur une Stack<T>)
    return _remainingQuestions.removeLast();
  }

  void _refillAndShuffleDeck() {
    // L'opérateur '[...liste]' (Spread operator) crée une copie superficielle (ToList() en C#)
    // pour ne pas altérer la liste d'origine
    _remainingQuestions = [..._allQuestions];
    _remainingQuestions.shuffle();
  }

  void _addPoints(int archetypeId, int points) {
    _score[archetypeId] = (_score[archetypeId] ?? 0) + points;
  }

  // Exemple de mécanisme (à adapter dans votre contrôleur)
  void _emit(QuizzState newState) {
    _state = newState;
    notifyListeners(); // Notifie automatiquement l'UI à chaque transition !
  }
}