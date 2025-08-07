part of 'characters_bloc.dart';

abstract class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object> get props => [];
}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class GetCharactersSuccess extends CharactersState {
  final List<CharacterEntity> charactersResponse;

  const GetCharactersSuccess(this.charactersResponse);

  @override
  List<Object> get props => [charactersResponse];
}

class GetCharactersFailure extends CharactersState {
  final BaseException exception;

  const GetCharactersFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
