
class Talent{
  final int id;
  final String name;
  final String description;

  factory Talent.fromJson(Map<String, dynamic> json){
    return Talent(
      id: int.parse(json["id"] as String),
      name: json["Name"] as String,
      description:  json["Description"] as String,
    );
  }

  const Talent({
    required this.id, 
    required this.name, 
    required this.description
  });
}