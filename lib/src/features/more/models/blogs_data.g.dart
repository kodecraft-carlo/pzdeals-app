// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blogs_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogDataAdapter extends TypeAdapter<BlogData> {
  @override
  final int typeId = 6;

  @override
  BlogData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogData(
      id: fields[0] as int,
      blogTitle: fields[1] as String,
      blogImage: fields[2] as String,
      blogContent: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BlogData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.blogTitle)
      ..writeByte(2)
      ..write(obj.blogImage)
      ..writeByte(3)
      ..write(obj.blogContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
