class Question {
  final String text;
  final List<Option> options;

  const Question({required this.text, required this.options});
}

class Option {
  final String text;
  final Map<String, int> profileScores;

  const Option({required this.text, required this.profileScores});
}