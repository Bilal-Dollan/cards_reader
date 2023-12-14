import 'dart:async';

import 'package:personal_cards_reader/sevices/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

const idColumn = 'id';
const nameColumn = 'name';
const companyNameColumn = 'companyName';
const phoneNumberColumn = 'phoneNumber';
const dbName = 'Cards.db';
const cardsTable = 'Cards';
const createCardsTable = '''
    CREATE TABLE IF NOT EXIST "Cards"(
      "id" INTEGER NOT NULL,
      "name" TEXT  ,
      "company_name" TEXT ,
      "phone_number" TEXT UNIQUE,
      PRIMARY KEY ("id" AUTOINCREMENT)
      );
''';

class DatabaseCards {
  final int id;
  final String name;
  final String companyName;
  final String phoneNumber;

  DatabaseCards(
      {required this.id,
      required this.name,
      required this.companyName,
      required this.phoneNumber});

  DatabaseCards.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        companyName = map[companyNameColumn] as String,
        phoneNumber = map[phoneNumberColumn] as String;

  @override
  String toString() => 'Card: name: $name , Company name: $companyName';

  @override
  bool operator ==(covariant DatabaseCards other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CardsServices {
  Database? _db;

  List<DatabaseCards> _cards = [];
  final _cardsStreamController =
      StreamController<List<DatabaseCards>>.broadcast();

  Future<void> _cacheCards() async {
    final allCards = await getAllCards();
    _cards = allCards.toList();
    _cardsStreamController.add(_cards);
  }

  Future<DatabaseCards> updateCard({
    required DatabaseCards card,
    required String name,
    required String companyName,
    required phoneNumber,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getCard(id: card.id);
    final updateCount = await db.update(cardsTable, {
      nameColumn: name,
      companyNameColumn: companyName,
      phoneNumberColumn: phoneNumber,
    });

    if (updateCount == 0) {
      throw CouldNotUpdatecard();
    } else {
      final updatedCard = await getCard(id: card.id);
      _cards.removeWhere((card) => card.id == updatedCard.id);
      _cards.add(updatedCard);
      _cardsStreamController.add(_cards);
      return updatedCard;
    }
  }

  Future<Iterable<DatabaseCards>> getAllCards() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final cards = await db.query(cardsTable);
    return cards.map((cardsRow) => DatabaseCards.fromRow(cardsRow));
  }

  Future<int> deleteallCards() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCard = await db.delete(cardsTable);
    _cards = [];
    _cardsStreamController.add(_cards);
    return deletedCard;
  }

  Future<DatabaseCards> getCard({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      cardsTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) {
      throw CouldNotFindCard();
    } else {
      final result = DatabaseCards.fromRow(results.first);
      _cards.removeWhere((card) => card.id == id);
      _cards.add(result);
      _cardsStreamController.add(_cards);
      return result;
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> deletCard({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(cardsTable, where: 'id = ?', whereArgs: [id]);

    if (deletedCount != 1) {
      throw CouldNotDeleteCard();
    } else {
      _cards.removeWhere((card) => card.id == id);
      _cardsStreamController.add(_cards);
    }
  }

  Future<DatabaseCards> createCard({
    required String name,
    required String companyName,
    required String phoneNumber,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(cardsTable,
        limit: 1,
        where: 'name = ?' 'companyName = ?' 'phoneNumber = ?',
        whereArgs: [name, companyName, phoneNumber]);
    if (results.isNotEmpty) {
      throw CardAlreadyExists();
    }

    final cardId = await db.insert(cardsTable, {
      nameColumn: name,
      companyNameColumn: companyName,
      phoneNumberColumn: phoneNumber,
    });

    final cardCreated = DatabaseCards(
        id: cardId,
        name: name,
        companyName: companyName,
        phoneNumber: phoneNumber);

    _cards.add(cardCreated);
    _cardsStreamController.add(_cards);
    return cardCreated;
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DataBaseAlreadyOpendExeption {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpendExeption();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createCardsTable);
      await _cacheCards();
    } on MissingPlatformDirectoryException {
      UnableToGetDocumentPathException();
    }
  }
}
