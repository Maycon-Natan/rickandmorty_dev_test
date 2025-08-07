import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/presentation/pages/character_page.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/presentation/pages/home_page.dart';

import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage(), routes: [
      GoRoute(
          path: 'character',
          builder: (context, state) {
            final character = state.extra as CharacterEntity;
            return CharacterPage(character: character);
          }),
    ]),
  ],
);
