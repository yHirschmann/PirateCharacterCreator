
class QuizzConfig{

  final String title;
  final String style;
  final int totalQuestions;
  final int totalResponses;
  final int recommendedQuestionsperSession;
  final String tieHandling;
  final Map<String, int> equilibragePerArchetype;
  
  factory QuizzConfig.fromJson(Map<String, dynamic> json){
    return QuizzConfig(
      title: json["title"] as String, 
      style: json["style"] as String, 
      totalQuestions: json["total_questions"] as int, 
      totalResponses: json["total_reponses"] as int,
      recommendedQuestionsperSession: json["recommended_questions_per_session"] as int, 
      tieHandling: json["tie_handling"] as String, 
      equilibragePerArchetype: json["equilibrage_par_archetype"] as Map<String, int>
    );
  }
  
  const QuizzConfig({
    required this.title,
    required this.style,
    required this.totalQuestions,
    required this.totalResponses,
    required this.recommendedQuestionsperSession,
    required this.tieHandling,
    required this.equilibragePerArchetype,
  });
  
}