// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VpnHistoryAdapter extends TypeAdapter<VpnHistory> {
  @override
  final int typeId = 0;

  @override
  VpnHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VpnHistory(
      id: fields[1] as String,
      country: fields[2] as String,
      duration: fields[3] as String,
      bytesIn: fields[4] as int,
      bytesOut: fields[5] as int,
      createdAt: fields[6] as DateTime,
      lastUpdatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VpnHistory obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.bytesIn)
      ..writeByte(5)
      ..write(obj.bytesOut)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastUpdatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VpnHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
