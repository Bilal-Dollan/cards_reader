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

  Future<DatabaseCards> updateCard({
    required DatabaseCards card,
    required String name,
    required String companyName,
    required phoneNumber,
  }) async {
    final db = _getDatabaseOrThrow();
    final currentCard = await getCard(id: card.id);
    final updatedCard = await db.update(cardsTable, {
      nameColumn: name,
      companyNameColumn: companyName,
      phoneNumberColumn: phoneNumber,
    });

    if (updatedCard == 0) {
      throw CouldNotUpdatecard();
    }
    return currentCard;
  }

  Future<Iterable<DatabaseCards>> getAllCards() async {
    final db = _getDatabaseOrThrow();
    final cards = await db.query(cardsTable);
    return cards.map((cardsRow) => DatabaseCards.fromRow(cardsRow));
  }

  Future<int> deleteCards() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(cardsTable);
  }

  Future<DatabaseCards> getCard({required int id}) async {
    final db = _getDatabaseOrThrow();
    final results =
        await db.query(cardsTable, limit: 1, where: 'id = ?', whereArgs: [id]);

    if (results.isEmpty) {
      throw CouldNotFindCard();
    } else {
      return DatabaseCards.fromRow(results.first);
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
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(cardsTable, where: 'id = ?', whereArgs: [id]);

    if (deletedCount != 1) {
      throw CouldNotDeleteCard();
    }
  }

  Future<DatabaseCards> createCard({
    required String name,
    required String companyName,
    required String phoneNumber,
  }) async {
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

    return DatabaseCards(
        id: cardId,
        name: name,
        companyName: companyName,
        phoneNumber: phoneNumber);
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
    } on MissingPlatformDirectoryException {
      UnableToGetDocumentPathException();
    }
  }
}
