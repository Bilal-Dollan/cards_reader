import 'package:personal_cards_reader/local_database/cards.dart';
import 'package:personal_cards_reader/local_database/boxes.dart';

putData(
    {required String name,
    required String companyName,
    required String phoneNumber}) {
  cardsBox.add(
      Cards(name: name, companyName: companyName, phoneNumber: phoneNumber));
}

deleteData(var key) {
  cardsBox.deleteAt(key);
}
