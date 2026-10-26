
import 'package:personality_quizz/models/archetype.dart';
import 'package:personality_quizz/models/talent.dart';

class CharacterSheet {

  final Archetype selectedArchetype;
  final Map<String, int> focus;
  final Talent selectedTalent;
  final List<String> inventory = const [];

  const CharacterSheet({
    required this.selectedArchetype,
    required this.focus,
    required this.selectedTalent,
  });

  int get maxStress => (selectedArchetype.skills['Survive'] ?? 4)* 2;
  

  String getSheetRawSheet(){
    
    return 
    '''Nom:
Archetype: ${selectedArchetype.name}
Description: ${selectedArchetype.description}
Stress: 0/$maxStress

Compétences:
- Analyse: ${selectedArchetype.skills['Study'] ?? 4}
- Bricolage: ${selectedArchetype.skills['Tinker'] ?? 4}
- Combat: ${selectedArchetype.skills['Fight'] ?? 4}
- Déplacement: ${selectedArchetype.skills['Move'] ?? 4}
- Social: ${selectedArchetype.skills['Talk'] ?? 4}
- Survie: ${selectedArchetype.skills['Survive'] ?? 4}

Styles:
- Astuce: ${selectedArchetype.styles['Cleverly'] ?? 4}
- Audace: ${selectedArchetype.styles['Boldly'] ?? 4}
- Brutale: ${selectedArchetype.styles['Forcefully'] ?? 4}
- Discret: ${selectedArchetype.styles['Quietly'] ?? 4}
- Prudent: ${selectedArchetype.styles['Carefully'] ?? 4}
- Vif: ${selectedArchetype.styles['Swiftly'] ?? 4}

Spécialités:
${focus.entries.where((e)=> e.value > 1).map((e) => '- ${e.key}: ${e.value}').join('\n')}

Talent:
${selectedTalent.name} - 
${selectedTalent.description}

Inventaire:

Histoire du personnage:
//A vous de me raconter l'histoire de votre personnage (courte ou longue).
''';
  }
}