import 'package:teste_tecnico_fteam/routes.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:teste_tecnico_fteam/src/core/DI/dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => injector<CharactersBloc>())
      ],
      child: MaterialApp.router(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
