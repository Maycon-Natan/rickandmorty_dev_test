import 'dart:convert';

import 'package:teste_tecnico_fteam/src/app/features/characters/domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  const CharacterModel(
      {required super.id,
      required super.name,
      required super.status,
      required super.species,
      required super.image});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image
    };
  }

  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    return CharacterModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterModel.fromJson(String source) =>
      CharacterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
