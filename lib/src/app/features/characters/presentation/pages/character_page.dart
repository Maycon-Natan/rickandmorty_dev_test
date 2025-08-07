import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:teste_tecnico_fteam/src/core/DI/dependency_injector.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CharacterPage extends StatefulWidget {
  final CharacterEntity character;
  const CharacterPage({super.key, required this.character});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late CharacterEntity currentCharacter;
  bool isLoadingMore = false;
  late CharactersBloc characterBloc;
  static bool _hasShownSwipeHint = false;
  PageController _pageController = PageController();
  int currentIndex = 0;
  final GlobalKey _tapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    currentCharacter = widget.character;
    characterBloc = injector<CharactersBloc>();
    final initialIndex =
        characterBloc.characters.indexWhere((c) => c.id == widget.character.id);
    _pageController = PageController(initialPage: initialIndex);

    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? 0;
      if (newIndex != currentIndex) {
        setState(() {
          currentIndex = newIndex;
          currentCharacter = characterBloc.characters[currentIndex];
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTutorial();
    });
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "tap",
          keyTarget: _tapKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                bottom: 180,
                left: 0,
                right: 0,
              ),
              child: const Column(
                children: [
                  Text(
                    "Clique ou Arraste para o lado para ver mais personagens",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Icon(Icons.swipe_left, color: Colors.white, size: 30),
                ],
              ),
            ),
          ],
        ),
      ],
      onFinish: () => _showHintOnce(),
      hideSkip: true,
      colorShadow: Colors.grey.shade700,
    ).show(context: context);
  }

  void _showHintOnce() {
    if (!_hasShownSwipeHint) {
      setState(() {
        _hasShownSwipeHint = true;
      });
    }
  }

  void _handleTapOnArea(TapDownDetails details) {
    final width = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    // Se tocou na metade esquerda
    if (dx < width / 2) {
      if (_pageController.page! > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
    // Se tocou na metade direita
    else {
      if (_pageController.page! < characterBloc.characters.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCharacter.name),
        centerTitle: true,
      ),
      body: BlocConsumer(
          listener: (context, state) {
            if (state is GetCharactersFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.exception.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is GetCharactersSuccess) {
              isLoadingMore = false;
            }
          },
          bloc: characterBloc,
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  final metrics = notification.metrics;
                  if (metrics.pixels == metrics.maxScrollExtent &&
                      !isLoadingMore &&
                      !characterBloc.hasReachedEnd) {
                    isLoadingMore = true;
                    characterBloc.add(GetCharactersEvent(
                      params: CharactersParams(
                          page: characterBloc.nextPage.toString()),
                    ));
                  }
                }
                return false;
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: _handleTapOnArea,
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      PageView.builder(
                          itemCount: characterBloc.characters.length,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (value) async {
                            setState(() {
                              currentCharacter =
                                  characterBloc.characters[value];
                            });
                          },
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            final character = characterBloc.characters[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: width * 0.85,
                                    child: Hero(
                                      tag: character.id,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          currentCharacter.image,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Row(
                                      spacing: 15,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 90,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  currentCharacter.status,
                                                  style: TextStyle(
                                                    color: (currentCharacter
                                                                .status ==
                                                            'Alive')
                                                        ? Colors.green
                                                        : (currentCharacter
                                                                    .status ==
                                                                'Dead')
                                                            ? Colors.red
                                                            : (currentCharacter
                                                                        .status ==
                                                                    'unknown')
                                                                ? Colors.yellow
                                                                : Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Specie',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  currentCharacter.species,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      if (!_hasShownSwipeHint)
                        Positioned(
                          right: 16,
                          top: MediaQuery.of(context).size.height / 2 - 70,
                          child: Container(
                            key: _tapKey,
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 25),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
