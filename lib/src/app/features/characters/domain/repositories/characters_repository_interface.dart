import 'package:result_dart/result_dart.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';

abstract interface class ICharactersRepository {
  AsyncResult<List<CharacterEntity>> getCharacters(CharactersParams params);
}
