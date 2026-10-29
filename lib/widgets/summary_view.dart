import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personality_quizz/models/quizz_state.dart';

class SummaryView extends StatelessWidget {
  const new({super.key, required this.onRestart, required this.state});

  final QuizzSummary state;
  final void Function() onRestart;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SelectableText(state.characterSheet.getSheetRawSheet()),
        ),
        IconButton(
          onPressed: () async { 
            await Clipboard.setData(ClipboardData(text: state.characterSheet.getSheetRawSheet()));
            final snackBar = SnackBar(
              backgroundColor: Colors.lightGreen,
              content: const Text('Votre fiche à été copié !'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }, 
          icon: Icon(Icons.copy),
        ),
        OutlinedButton(onPressed: onRestart, child: Text('Recommencer le test')),
      ],
    );
  }
}