import 'package:flutter/material.dart';

/// Affichage de la question
class QuestionHeader extends StatelessWidget {
  final String questionText;

  const QuestionHeader({super.key, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        questionText,
        key: ValueKey(questionText),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Bouton d'option cliquable
class OptionTile extends StatelessWidget {
  final String optionText;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.optionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Text(
            optionText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}