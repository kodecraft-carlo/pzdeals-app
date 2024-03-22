// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreditCardDealDataAdapter extends TypeAdapter<CreditCardDealData> {
  @override
  final int typeId = 1;

  @override
  CreditCardDealData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreditCardDealData(
      id: fields[0] as String,
      imageAsset: fields[1] as String,
      description: fields[2] as String?,
      title: fields[3] as String,
      sourceType: fields[4] as String,
      displayType: fields[5] as String,
      isDealExpired: fields[6] as bool?,
      barCodeLink: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CreditCardDealData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageAsset)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.sourceType)
      ..writeByte(5)
      ..write(obj.displayType)
      ..writeByte(6)
      ..write(obj.isDealExpired)
      ..writeByte(7)
      ..write(obj.barCodeLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditCardDealDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
