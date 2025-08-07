import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/repositories/characters_repository_interface.dart';
import 'package:teste_tecnico_fteam/src/core/interfaces/usecase_interface.dart';
import 'package:result_dart/result_dart.dart';

class CharactersUsecase
    implements UseCase<List<CharacterEntity>, CharactersParams> {
  final ICharactersRepository _charactersRepository;

  CharactersUsecase({required ICharactersRepository charactersRepository})
      : _charactersRepository = charactersRepository;

  @override
  AsyncResult<List<CharacterEntity>> call(CharactersParams params) async {
    return await _charactersRepository.getCharacters(params);
  }
}
