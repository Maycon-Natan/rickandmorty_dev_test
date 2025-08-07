import 'package:teste_tecnico_fteam/src/app/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/data/models/character_model.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/repositories/characters_repository_interface.dart';
import 'package:teste_tecnico_fteam/src/core/client_http/client_http.dart';
import 'package:teste_tecnico_fteam/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

class CharactersRepositoryImpl implements ICharactersRepository {
  final CharactersRemoteDatasource _charactersRemoteDatasource;

  CharactersRepositoryImpl(
      {required CharactersRemoteDatasource charactersRemoteDatasource})
      : _charactersRemoteDatasource = charactersRemoteDatasource;

  @override
  AsyncResult<List<CharacterEntity>> getCharacters(
      CharactersParams params) async {
    try {
      final response = await _charactersRemoteDatasource.getCharacters(params);
      final results = response.data['results'];
      if (results == null) {
        return const Success(<CharacterEntity>[]);
      }
      final characters = (results as List<dynamic>)
          .map((item) => CharacterModel.fromMap(item as Map<String, dynamic>))
          .toList();
      return Success(characters);
    } on RestClientException catch (e) {
      return Failure(DefaultException(message: e.message));
    } catch (e) {
      return Failure(
        DefaultException(message: 'Erro inesperado: ${e.toString()}'),
      );
    }
  }
}
