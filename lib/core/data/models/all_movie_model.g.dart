// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllMovieModelAdapter extends TypeAdapter<AllMovieModel> {
  @override
  final int typeId = 1;

  @override
  AllMovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllMovieModel(
      page: fields[0] as int,
      results: (fields[1] as List).cast<MovieModel>(),
      totalPages: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AllMovieModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.totalPages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllMovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 2;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      genreIds: (fields[0] as List).cast<int>(),
      id: fields[1] as int,
      popularity: fields[2] as int,
      posterPath: fields[3] as String,
      title: fields[4] as String,
      voteAverage: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.genreIds)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.popularity)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.voteAverage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
