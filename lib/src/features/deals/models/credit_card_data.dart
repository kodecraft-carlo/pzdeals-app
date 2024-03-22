import 'package:hive/hive.dart';

part 'credit_card_data.g.dart';

@HiveType(typeId: 1)
class CreditCardDealData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imageAsset;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String sourceType;

  @HiveField(5)
  final String displayType;

  @HiveField(6)
  final bool? isDealExpired;

  @HiveField(7)
  final String? barCodeLink;

  CreditCardDealData({
    required this.id,
    required this.imageAsset,
    this.description = '',
    required this.title,
    required this.sourceType,
    required this.displayType,
    this.isDealExpired = false,
    this.barCodeLink = '',
  });
}
