import 'package:flutter/material.dart';
import 'package:personality_quizz/models/quizz_state.dart';
import 'package:personality_quizz/services/quizz_controller.dart';
import 'package:personality_quizz/widgets/customization_view.dart';
import 'package:personality_quizz/widgets/question_view.dart';
import 'package:personality_quizz/widgets/summary_view.dart';
import 'package:personality_quizz/widgets/tie_breaker_view.dart';

///Classe de rendue visuel 
class QuizzScreen extends StatefulWidget {
  const QuizzScreen({super.key});

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

///Classe d'état de [QuizzScreen]
class _QuizzScreenState extends State<QuizzScreen> {

  final QuizzController _quizzController = QuizzController();

  @override
  void initState() {
    super.initState();
    _quizzController.init();
  }

  @override
  void dispose() {
    _quizzController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: 
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650), // 2. Largeur max sur PC (sur mobile < 650px, prend 100%)
              child: SingleChildScrollView( // 3. Permet de scroller si l'écran est trop court
                padding: const EdgeInsets.all(24.0),
                child: ListenableBuilder(
                  listenable: _quizzController,
                  builder: (BuildContext context, Widget? child){ 
                    return switch(_quizzController.state){
                      QuizzLoading() => const CircularProgressIndicator(),
                      QuizzQuestionning() && final state => QuestionView(state: state, onAnswerSelected: (response) => _quizzController.answerQuestion(response),),
                      QuizzTieBreaker() && final state  => TieBreakerView(resolveTie: (archetype) => _quizzController.resolveTie(archetype),startNewQuizz: () => _quizzController.startNewQuizz(), state: state,),
                      QuizzCustomization() && final state  => CustomizationView(
                                                                onRestart: () => _quizzController.startNewQuizz(), 
                                                                onSelectTalent: (talent) => _quizzController.selectTalent(talent), 
                                                                onUpdateFocus: (focusName, delta) => _quizzController.updateFocusPoint(focusName, delta), 
                                                                onValidate: () => _quizzController.validateCharacter(), 
                                                                state: state,),
                      QuizzSummary() && final state => SummaryView(onRestart: () => _quizzController.startNewQuizz(), state: state,),
                    };
                  }
                ),
              ),
            ),
        ),
      );
  }
}