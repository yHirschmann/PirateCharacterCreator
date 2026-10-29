import 'package:flutter/material.dart';
import 'package:personality_quizz/models/quizz_state.dart';
import 'package:personality_quizz/models/talent.dart';

class CustomizationView extends StatelessWidget {
  const new({super.key, required this.onRestart, required this.onSelectTalent, required this.onUpdateFocus, required this.onValidate, required this.state});

  final QuizzCustomization state;
  final void Function(String focusName, int delta) onUpdateFocus;
  final void Function(Talent talent) onSelectTalent;
  final void Function() onValidate;
  final void Function() onRestart;


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Text(state.finalArchetype.name, style: Theme.of(context).textTheme.displayMedium),
        Text(state.finalArchetype.description, style: Theme.of(context).textTheme.bodyLarge,),
        Image.asset(
          'assets/images/${state.finalArchetype.id}.png', 
          errorBuilder: (context, error, stackTrace) {
            return Text('fail to load: ${state.finalArchetype.name}.png');
          },
        ),
        Text("Points de spécialités restants : ${state.remainingFocusPoint}"),
        for(var focus in state.allocatedFocusPoints.entries)
          Row(
            children: [
              Expanded(
                child: Text(focus.key),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: focus.value > 1
                    ? () => onUpdateFocus(focus.key, -1)
                    : null, // <-- Grise et désactive le bouton si remainingFocusPoint == 0 !
              ),
              Text(focus.value.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: state.remainingFocusPoint > 0 && focus.value < 5
                    ? () => onUpdateFocus(focus.key, 1)
                    : null, // <-- Grise et désactive le bouton si remainingFocusPoint == 0 !
              )
            ],
          ),
        for(var talent in state.finalArchetype.talents)
          Card(
            clipBehavior: .hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () => onSelectTalent(talent),
              child: Column(
                children: [ Row(
                  children: [
                    Text(talent.name, style: Theme.of(context).textTheme.bodyLarge,),
                    if (state.selectedTalent?.id == talent.id)
                      const Icon(Icons.check, color: Colors.green),
                  ],),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(talent.description),
                  ),
                ],
              ),
            ),
          ),
        Row(
          children: [
          OutlinedButton(
            onPressed: state.remainingFocusPoint != 0 || state.selectedTalent == null ? null : onValidate, 
            child: Text('Valider le personnage')
          ),
          OutlinedButton(onPressed: onRestart, child: Text('Recommencer le test')),
        ],),
      ],
    );
  }
}