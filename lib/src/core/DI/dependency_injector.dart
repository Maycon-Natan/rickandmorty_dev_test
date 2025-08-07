import 'package:teste_tecnico_fteam/src/app/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/data/repositories/character_repository_impl.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/repositories/characters_repository_interface.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/usecases/characters_usecase.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:teste_tecnico_fteam/src/core/client_http/dio/rest_client_dio_impl.dart';

import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

void setupDependencyInjector() {
  injector.registerFactory<RestClientDioImpl>(() {
    final instance = RestClientDioImpl(dio: DioFactory.dio());

    return instance;
  });

  injector.registerLazySingleton<CharactersRemoteDatasource>(() {
    return CharactersRemoteDatasource(
        restClient: injector<RestClientDioImpl>());
  });

  injector.registerLazySingleton<ICharactersRepository>(
    () => CharactersRepositoryImpl(
      charactersRemoteDatasource: injector<CharactersRemoteDatasource>(),
    ),
  );

  injector.registerLazySingleton(
    () => CharactersBloc(
      charactersUsecase: CharactersUsecase(
          charactersRepository: injector<ICharactersRepository>()),
    ),
  );
}
