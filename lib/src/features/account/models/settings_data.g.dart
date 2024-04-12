// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsDataAdapter extends TypeAdapter<SettingsData> {
  @override
  final int typeId = 8;

  @override
  SettingsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsData(
      priceMistake: fields[0] as bool,
      frontpageNotification: fields[1] as bool,
      percentageNotification: fields[2] as bool,
      percentageThreshold: fields[3] as int,
      numberOfAlerts: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.priceMistake)
      ..writeByte(1)
      ..write(obj.frontpageNotification)
      ..writeByte(2)
      ..write(obj.percentageNotification)
      ..writeByte(3)
      ..write(obj.percentageThreshold)
      ..writeByte(4)
      ..write(obj.numberOfAlerts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
