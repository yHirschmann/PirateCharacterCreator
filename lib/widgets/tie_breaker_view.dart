import 'package:flutter/material.dart';
import 'package:personality_quizz/models/archetype.dart';
import 'package:personality_quizz/models/quizz_state.dart';

class TieBreakerView extends StatefulWidget {
  final QuizzTieBreaker state;
  final void Function(Archetype) resolveTie;
  final VoidCallback startNewQuizz;

  const TieBreakerView({
    super.key,
    required this.state,
    required this.resolveTie,
    required this.startNewQuizz,
  });

  @override
  State<TieBreakerView> createState() => _TieBreakerViewState();
}

class _TieBreakerViewState extends State<TieBreakerView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentPage < widget.state.tiedArchetypes.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Égalité parfaite ! Choisissez votre voie :',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // 1. Navigation latérale (Gauche - PageView - Droite)
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: _currentPage > 0 ? _goToPrevious : null,
            ),
            Expanded(
              child: SizedBox(
                height: 600,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.state.tiedArchetypes.length,
                  itemBuilder: (context, index) {
                    final archetype = widget.state.tiedArchetypes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 2. Dimensions d'images strictement identiques
                          SizedBox(
                            height: 400,
                            child: Image.asset(
                              'assets/images/${archetype.id}.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, size: 48),
                                ),
                              ),
                            ),
                          ),

                          // 3. Informations textuelles et bouton de validation
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    archetype.name,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),

                                  // 4. Description complète avec défilement interne
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        archetype.description,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () => widget.resolveTie(archetype),
                                      child: Text('Incarner un ${archetype.name}', textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _currentPage < widget.state.tiedArchetypes.length - 1
                  ? _goToNext
                  : null,
            ),
          ],
        ),

        const SizedBox(height: 24),
        TextButton(
          onPressed: widget.startNewQuizz,
          child: const Text('Recommencer le test'),
        ),
      ],
    );
  }
}