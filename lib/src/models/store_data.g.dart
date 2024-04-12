// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreDataAdapter extends TypeAdapter<StoreData> {
  @override
  final int typeId = 4;

  @override
  StoreData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreData(
      storeName: fields[1] as String,
      storeAssetImage: fields[2] as String,
      assetSourceType: fields[3] as String,
      id: fields[0] as int,
      handle: fields[4] as String,
      storeBody: fields[5] as String?,
      tagName: fields[6] as String?,
      appStoreImg: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StoreData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.storeName)
      ..writeByte(2)
      ..write(obj.storeAssetImage)
      ..writeByte(3)
      ..write(obj.assetSourceType)
      ..writeByte(4)
      ..write(obj.handle)
      ..writeByte(5)
      ..write(obj.storeBody)
      ..writeByte(6)
      ..write(obj.tagName)
      ..writeByte(7)
      ..write(obj.appStoreImg);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
