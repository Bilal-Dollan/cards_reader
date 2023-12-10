import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class DataBaseAlreadyOpendExeption implements Exception {}

class UnableToGetDocumentPathException implements Exception {}

class DatabaseIsNotOpen implements Exception {}

const idColumn = 'id';
const nameColumn = 'name';
const companyNameColumn = 'companyName';
const dbName = 'Cards.db';
const cardsTable = 'Cards';
const createCardsTable = '''
    CREATE TABLE IF NOT EXIST "Cards"(
      "id" INTEGER NOT NULL,
      "name" TEXT ,
      "company_name" TEXT ,
      "phone_number" TEXT,
      PRIMARY KEY ("id" AUTOINCREMENT)
      );
''';

class DatabaseCards {
  final int id;
  final String name;
  final String companyName;

  DatabaseCards(
      {required this.id, required this.name, required this.companyName});

  DatabaseCards.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        companyName = map[companyNameColumn] as String;

  @override
  String toString() => 'Card: name: $name , Company name: $companyName';

  @override
  bool operator ==(covariant DatabaseCards other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CardsServices {
  Database? _db;

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
