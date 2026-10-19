import 'package:flutter/material.dart';
import 'package:test_app/Old/PersonalityProfile.dart';
import 'package:test_app/Old/quizz.dart';

class ResultPage extends StatelessWidget {
  final String profileResult;

  const ResultPage({
    super.key,
    required this.profileResult,
  });

  // Mapper simple pour associer le code du profil à ses détails d'affichage.
  // En production, ces données sont idéalement chargées depuis un Repository/JSON.
  PersonalityProfile _getProfileDetails(String profileKey) {
    switch (profileKey) {
      case 'analyste':
        return const PersonalityProfile(
          title: "L'Analyste",
          description:
              "Vous êtes une personne méthodique, réfléchie et observatrice. Vous privilégiez la logique, la précision et l'analyse approfondie avant de prendre une décision.",
          icon: Icons.analytics_outlined,
          color: Colors.blue,
        );
      case 'artiste':
        return const PersonalityProfile(
          title: "L'Artiste",
          description:
              "Vous êtes guidé par votre intuition, votre créativité et votre sensibilité. Vous exprimez vos idées de manière originale et sortez souvent des sentiers battus.",
          icon: Icons.palette_outlined,
          color: Colors.purple,
        );
      case 'social':
        return const PersonalityProfile(
          title: "Le Connecteur",
          description:
              "Vous êtes empathique, chaleureux et tourné vers les autres. Vous vous épanouissez dans les échanges humains, la collaboration et le partage.",
          icon: Icons.people_outline,
          color: Colors.green,
        );
      case 'action':
        return const PersonalityProfile(
          title: "Le Bâtisseur",
          description:
              "Dynamique et pragmatique, vous aimez passer rapidement à l'action. Vous relevez les défis avec énergie et préférez les résultats concrets aux longs discours.",
          icon: Icons.bolt_outlined,
          color: Colors.orange,
        );
      default:
        return const PersonalityProfile(
          title: "Profil Inconnu",
          description: "Impossible de déterminer précisément votre profil.",
          icon: Icons.help_outline,
          color: Colors.grey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _getProfileDetails(profileResult);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat du Quiz'),
        automaticallyImplyLeading: false, // Empêche le retour arrière direct
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Carte mettant en valeur le profil obtenu
              ResultCard(profile: profile),
              const Spacer(),
              // Actions : Recommencer ou Quitter
              ElevatedButton.icon(
                onPressed: () {
                  // Recommencer le quiz en remplaçant la page actuelle par une nouvelle QuizPage
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const QuizPage(), // Assure-toi d'importer QuizPage
                    ),
                  );
                },
                icon: const Icon(Icons.replay),
                label: const Text('Recommencer le quiz'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // Retourner à la racine (écran d'accueil)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Retour à l'accueil"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final PersonalityProfile profile;

  const ResultCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: profile.color.withOpacity(0.15),
              child: Icon(
                profile.icon,
                size: 44,
                color: profile.color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Votre profil est :',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: profile.color,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              profile.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}