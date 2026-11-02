import 'package:flutter/material.dart';
import 'package:personality_quizz/models/quizz_state.dart';
import 'package:personality_quizz/models/response.dart';

class QuestionView extends StatelessWidget {
  const new({super.key, required this.state, required this.onAnswerSelected});

  final QuizzQuestionning state;
  final void Function(Response) onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text('Question n°${state.questionNumber}'),
          Text(state.currentQuestion.question, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.justify,),
          for(var response in state.currentQuestion.responses)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(response.text, style: Theme.of(context).textTheme.bodyMedium),
                onPressed:() => onAnswerSelected(response),
              ),
            ),
        ],
    );
  }
}