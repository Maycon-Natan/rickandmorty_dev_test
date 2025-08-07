import 'package:flutter/material.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';
import 'package:teste_tecnico_fteam/src/app/features/characters/domain/usecases/characters_usecase.dart';
import 'package:teste_tecnico_fteam/src/core/errors/errors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_dart/result_dart.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharactersUsecase _charactersUsecase;
  List<CharacterEntity> characters = [];
  int page = 0;
  int get nextPage => page + 1;
  bool hasReachedEnd = false;

  CharactersBloc({required CharactersUsecase charactersUsecase})
      : _charactersUsecase = charactersUsecase,
        super(CharactersInitial()) {
    on<GetCharactersEvent>(_getCharactersRequested);
  }

  void _getCharactersRequested(
      GetCharactersEvent event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());
    final newState = await _charactersUsecase
        .call(event.params) //
        .fold(
          GetCharactersSuccess.new,
          (exception) =>
              GetCharactersFailure(exception: exception as BaseException),
        );

    if (newState is GetCharactersSuccess) {
      if (newState.charactersResponse.isEmpty) {
        hasReachedEnd = true;
      }
      for (var character in newState.charactersResponse) {
        if (!characters.any((c) => c.id == character.id)) {
          characters.add(character);
        }
      }
      page++;
    }

    emit(newState);
  }
}
