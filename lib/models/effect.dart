
class Effect {
  final int archetypeId;
  final String name;
  final int points;

  factory Effect.fromJson(Map<String, dynamic> json){
    return Effect(
      archetypeId: int.parse(json["archetype_id"]),
      name: json["name"] as String,
      points: json["points"] as int,
    );
  }

  const Effect({
    required this.archetypeId,
    required this.name,
    required this.points,
  });
}