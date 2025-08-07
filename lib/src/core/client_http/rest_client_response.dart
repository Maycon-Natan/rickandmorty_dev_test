import 'package:teste_tecnico_fteam/src/core/client_http/client_http.dart';

class RestClientResponse implements RestClientHttpMessage {
  dynamic data;
  int? statusCode;
  String? message;
  RestClientRequest request;

  RestClientResponse({
    this.data,
    this.statusCode,
    this.message,
    required this.request,
  });
}
