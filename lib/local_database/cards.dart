import 'package:hive/hive.dart';

part 'cards.g.dart';

@HiveType(typeId: 1)
class Cards {
  Cards(
      {required this.name,
      required this.companyName,
      required this.phoneNumber});

  @HiveField(0)
  String name;

  @HiveField(1)
  String companyName;

  @HiveField(2)
  String phoneNumber;
}
