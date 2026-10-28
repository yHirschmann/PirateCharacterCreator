import 'package:flutter/material.dart';
import 'package:personality_quizz/models/quizz_state.dart';
import 'package:personality_quizz/services/quizz_controller.dart';

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
          child: ListenableBuilder(
            listenable: _quizzController,
            builder: (BuildContext context, Widget? child){ 
              return switch(_quizzController.state){
                QuizzLoading() => const CircularProgressIndicator(),
                QuizzQuestionning() && final state => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.currentQuestion.question),
                    for(var response in state.currentQuestion.responses)
                      ElevatedButton(
                        child: Text(response.text),
                        onPressed:() => _quizzController.answerQuestion(response),
                      ),
                  ]
                ),
                QuizzTieBreaker() && final state  => Text('État atteint : Tie'),
                QuizzCustomization() && final state  => Text('État atteint : Customization'),
                QuizzSummary() && final state => Text('État atteint : Summary'),
              };
            }
          ),
        ),
    );
  }
}