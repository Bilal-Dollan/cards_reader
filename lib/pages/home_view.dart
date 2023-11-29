import 'package:flutter/material.dart';
import 'package:personal_cards_reader/custom_widget/add_card.dart';
import 'package:personal_cards_reader/custom_widget/cards_list.dart';
import 'package:personal_cards_reader/local_database/boxes.dart';
import 'package:personal_cards_reader/local_database/cards.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddCard(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              'Saved Cards',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
            ),
          ),
          ListView.builder(
            itemCount: itemCount(cardsBox.length),
            itemBuilder: (context, index) {
              Cards listView = cardsBox.getAt(index);
              return CardList(
                  personName: listView.name, companyName: listView.companyName);
            },
            shrinkWrap: true,
            reverse: true,
          ),
        ],
      ),
    );
  }
}

int itemCount(int dataLength) {
  int itemCount;
  dataLength < 5 ? itemCount = dataLength : itemCount = 5;
  return itemCount;
}
