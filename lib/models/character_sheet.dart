
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
${selectedTalent.name}
- ${selectedTalent.description}

Inventaire:

Histoire du personnage:
//A vous de me raconter l'histoire de votre personnage (courte ou longue).

Informations connus du personnage:
- Vous êtes un pirate engagé depuis peu de temps sur le bateau de Maggie la Rouge.
- Vous connaissez bien un membre de son équipage, pour de bonne ou de mauvaises raisons.
- Vous vous situez dans une partie du globe semblable aux Caraïbes.
- Il existe une drogue très convoité qui s'appelle "Corail".  Sur une prise prolongée, elle transforme le corp en corail
- Vous connaissez des rumeurs sur l'existence de créatures terrestre et marine qui dépassent la raison.
- Dans de rares occasion, il est possible de rencontrer des personnes appartenant à des races non humaines (ex: petites personnes ayant la peau verte et de longues oreilles, hommes-poisson, etc.)
- Vous connaissez la légende des Cinq Calamités. Un équipage sans capitane, qui aurait vendu leurs âme à une déité chtonienne en échange d'une éternité de pillage. Ils vogueraient sur le dos d'un Vaisseau-Baleine volant et faire leurs rencontre serait signe de désastre et de mort.
- Il existe un code des pirate qui définit une ligne de conduite pour tous ceux l'ayant ratifié.
- Code des Pirates:
  ○ Pas de vol entre les membres d'un même équipage
  ○ Droit de vote pour chaque membre pour prendre une décision importante.
  ○ Le partage du butin entre les membres de l'équipage
  ○ La possibilité d'invoquer le pourparlers pour discuter plutôt que de se battre.
''';
  }
}