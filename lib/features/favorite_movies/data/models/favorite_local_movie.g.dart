// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_local_movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteLocalMovieAdapter extends TypeAdapter<FavoriteLocalMovie> {
  @override
  final int typeId = 4;

  @override
  FavoriteLocalMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteLocalMovie(
      movieId: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteLocalMovie obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.movieId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteLocalMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
