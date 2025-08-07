import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:teste_tecnico_fteam/src/core/DI/dependency_injector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final characterBloc = injector<CharactersBloc>();
  List<CharacterEntity> characters = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    characterBloc.add(GetCharactersEvent(
      params: CharactersParams(page: page.toString()),
    ));
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          isLoading = true;
          page++;
          characterBloc.add(GetCharactersEvent(
            params: CharactersParams(page: page.toString()),
          ));
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          'Rick and Morty',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CharactersBloc, CharactersState>(
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
              characters += state.charactersResponse;
              isLoading = false;
            }
          },
          bloc: characterBloc,
          builder: (context, state) {
            if (state is CharactersLoading) {
              const CircularProgressIndicator();
            }
            if (characters.isEmpty && state is! CharactersLoading) {
              return const Center(
                child: Text('Nenhum personagem encontrado',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount:
                          isLoading ? characters.length + 2 : characters.length,
                      shrinkWrap: true,
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.8),
                      itemBuilder: (context, index) {
                        if (index < characters.length) {
                          final character = characters[index];
                          return InkWell(
                            onTap: () {
                              context.go('/character', extra: character);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: Hero(
                                      tag: character.id,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12)),
                                          child: SizedBox.expand(
                                            child: Image.network(
                                              character.image,
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
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    character.name,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
