class OptionModel {
  final String text;
  final Map<String, int> scores;

  OptionModel({
    required this.text,
    required this.scores,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      text: json['text'] as String,
      // Conversion explicite du Map dynamic vers Map<String, int>
      scores: Map<String, int>.from(json['scores'] as Map),
    );
  }
}

class QuestionModel {
  final String text;
  final List<OptionModel> options;

  QuestionModel({
    required this.text,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      text: json['text'] as String,
      // On convertit la liste JSON en liste d'objets OptionModel
      options: (json['options'] as List<dynamic>)
          .map((optionJson) => OptionModel.fromJson(optionJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizModel {
  final String id;
  final String title;
  final List<QuestionModel> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((questionJson) => QuestionModel.fromJson(questionJson as Map<String, dynamic>))
          .toList(),
    );
  }
}