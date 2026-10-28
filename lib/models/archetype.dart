
import 'package:personality_quizz/models/talent.dart';

/// Classe correspondant au archétypes de personnages
class Archetype {

  //Identifiant unique de l'archétype 
  final int id ;

  //Nom de l'archétype
  final String name;

  //description courte de l'archétype
  final String description;

  //Liste des compétences et de leurs valeurs de l'archétype
  final Map<String, int> skills;

  //Liste des styles et de leurs valeurs de l'archétype
  final Map<String, int> styles;

  //Liste des spécialités disponible pour l'archétype
  final List<String> focus;

  //Liste des talents disponible pour l'archétype
  final List<Talent> talents;

  factory Archetype.fromJson(Map<String, dynamic> json){
    return Archetype(
      id: int.parse(json["id"] as String),
      name: json["Name"] as String,
      description: json["Description"] as String,
      focus: List<String>.from(json["Focus"] as List<dynamic>),
      skills: (json["Skill"] as Map<String, dynamic>).map(
  (key, value) => MapEntry(key, _parseStat(value)),
      ),
      styles: (json["Styles"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, _parseStat(value)),
      ),
      talents: (json["Talent"] as List<dynamic>).map((item) => Talent.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  static int _parseStat(Object? value){
    final int bonus = int.tryParse(value?.toString() ?? '') ?? 0;
    return 4 + bonus;
  }

  const Archetype({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.focus, 
    required this.skills, 
    required this.styles, 
    required this.talents
  });
}
