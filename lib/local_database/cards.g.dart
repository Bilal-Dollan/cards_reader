// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardsAdapter extends TypeAdapter<Cards> {
  @override
  final int typeId = 1;

  @override
  Cards read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cards(
      name: fields[0] as String,
      companyName: fields[1] as String,
      phoneNumber: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cards obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
