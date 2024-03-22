// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pzstore_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PZStoreDataAdapter extends TypeAdapter<PZStoreData> {
  @override
  final int typeId = 3;

  @override
  PZStoreData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PZStoreData(
      id: fields[0] as int,
      title: fields[1] as String,
      imageUrl: fields[2] as String,
      tagName: fields[3] as String,
      bodyHtml: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PZStoreData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.tagName)
      ..writeByte(4)
      ..write(obj.bodyHtml);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PZStoreDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
