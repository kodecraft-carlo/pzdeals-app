// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionDataAdapter extends TypeAdapter<CollectionData> {
  @override
  final int typeId = 2;

  @override
  CollectionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionData(
      id: fields[3] as int,
      title: fields[0] as String,
      imageAsset: fields[1] as String,
      assetSourceType: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CollectionData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.imageAsset)
      ..writeByte(2)
      ..write(obj.assetSourceType)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
