import 'package:equatable/equatable.dart';

class GenreResponse extends Equatable {
  final int id;
  final String name;
  const GenreResponse({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];
}
