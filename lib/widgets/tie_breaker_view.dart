import 'package:flutter/material.dart';
import 'package:personality_quizz/models/archetype.dart';
import 'package:personality_quizz/models/quizz_state.dart';

class TieBreakerView extends StatelessWidget {
  const new({super.key, required this.resolveTie, required this.startNewQuizz, required this.state});

  final QuizzTieBreaker state;
  final void Function(Archetype) resolveTie;
  final void Function() startNewQuizz;


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Text("Vos réponses vous permettent de choisir. Que souhaitez vous incarner ?"),
        for(var archetype in state.tiedArchetypes)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16), 
              child: 
                Column(
                  children: [
                    Text(archetype.name),
                    Text(archetype.description),
                    OutlinedButton(onPressed: () => resolveTie(archetype), child: Text('Incarner ${archetype.name}'))
                  ],
                ),
            ),
          ),
        OutlinedButton(onPressed: () => startNewQuizz, child: Text('Recommencer'),),
      ],
    );
  }
}