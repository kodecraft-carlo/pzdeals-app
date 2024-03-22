// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationDataAdapter extends TypeAdapter<NotificationData> {
  @override
  final int typeId = 5;

  @override
  NotificationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationData(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      title: fields[2] as String,
      body: fields[3] as String,
      isRead: fields[4] as bool,
      imageUrl: fields[5] as String,
      data: fields[6] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
