import 'package:teste_tecnico_fteam/src/app/features/characters/domain/dtos/character_params.dart';
import 'package:teste_tecnico_fteam/src/core/client_http/client_http.dart';

class CharactersRemoteDatasource {
  final IRestClient _restClient;

  CharactersRemoteDatasource({required IRestClient restClient})
      : _restClient = restClient;

  Future<RestClientResponse> getCharacters(CharactersParams params) =>
      _restClient.get(
        RestClientRequest(
          path: 'https://rickandmortyapi.com/api/character',
          queryParameters: params.toJson(),
        ),
      );
}
