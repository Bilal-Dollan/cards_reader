import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_cards_reader/local_database/boxes.dart';
import 'package:personal_cards_reader/local_database/cards.dart';
import 'package:personal_cards_reader/pages/add_card_manualy_view.dart';
import 'package:personal_cards_reader/pages/home_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CardsAdapter());
  cardsBox = await Hive.openBox<Cards>('CardBox');
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  List<Widget> pageList = const [
    Home(),
    FormFields(),
    Home(),
  ];

  onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Card Reader'),
          backgroundColor: Colors.red[50],
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 21,
          ),
        ),
        body: pageList[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Cards list'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          currentIndex: _currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          elevation: 1,
          backgroundColor: Colors.red[50],
        ),
      ),
    );
  }
}
