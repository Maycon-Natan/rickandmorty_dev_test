// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
  });

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, status: $status, species: $species, image: $image)';
  }

  @override
  List<Object?> get props => [id, name, status, species, image];
}
