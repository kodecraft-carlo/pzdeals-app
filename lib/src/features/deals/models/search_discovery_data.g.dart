// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_discovery_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchDiscoveryDataAdapter extends TypeAdapter<SearchDiscoveryData> {
  @override
  final int typeId = 9;

  @override
  SearchDiscoveryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchDiscoveryData(
      title: fields[0] as String,
      imageAsset: fields[1] as String,
      assetSourceType: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchDiscoveryData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.imageAsset)
      ..writeByte(2)
      ..write(obj.assetSourceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchDiscoveryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
