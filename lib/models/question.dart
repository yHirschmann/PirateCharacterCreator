
import 'package:personality_quizz/models/response.dart';

class Question{
    
    final int id;
    final String question;
    final List<Response> responses;

    factory Question.fromJson(Map<String, dynamic> json){
      return Question(
        id: int.parse(json["id"] as String),
        question: json["question"] as String, 
        responses: (json["responses"] as List<dynamic>).map((item) => Response.fromJson(item as Map<String, dynamic>)).toList(),
      );
    }

    const Question({
        required this.id,
        required this.question,
        required this.responses,
    });
}