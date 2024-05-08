// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDealcardDataAdapter extends TypeAdapter<ProductDealcardData> {
  @override
  final int typeId = 0;

  @override
  ProductDealcardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDealcardData(
      productId: fields[0] as int,
      productName: fields[1] as String,
      price: fields[2] as dynamic,
      storeAssetImage: fields[3] as String,
      oldPrice: fields[4] as dynamic,
      imageAsset: fields[5] as String,
      discountPercentage: fields[6] as dynamic,
      assetSourceType: fields[7] as String,
      isProductNoPrice: fields[8] as bool?,
      isProductExpired: fields[9] as bool?,
      productDealDescription: fields[10] as String?,
      barcodeLink: fields[11] as String?,
      tagDealDescription: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDealcardData obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.storeAssetImage)
      ..writeByte(4)
      ..write(obj.oldPrice)
      ..writeByte(5)
      ..write(obj.imageAsset)
      ..writeByte(6)
      ..write(obj.discountPercentage)
      ..writeByte(7)
      ..write(obj.assetSourceType)
      ..writeByte(8)
      ..write(obj.isProductNoPrice)
      ..writeByte(9)
      ..write(obj.isProductExpired)
      ..writeByte(10)
      ..write(obj.productDealDescription)
      ..writeByte(11)
      ..write(obj.barcodeLink)
      ..writeByte(12)
      ..write(obj.tagDealDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDealcardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
