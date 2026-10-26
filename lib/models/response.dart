
import 'package:personality_quizz/models/effect.dart';

class Response {
  final String id;
  final String text;
  final List<Effect> effects;

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
      id: json["id"] as String, 
      text: json["texte"] as String, 
      effects: (json["effects"] as List<dynamic>).map((item) => Effect.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  const Response({
    required this.id,
    required this.text,
    required this.effects,
  });
}