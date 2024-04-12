// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KeywordDataAdapter extends TypeAdapter<KeywordData> {
  @override
  final int typeId = 7;

  @override
  KeywordData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeywordData(
      keyword: fields[1] as String,
      id: fields[0] as int,
      imageUrl: fields[2] as String,
      datecreated: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KeywordData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.keyword)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.datecreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeywordDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
