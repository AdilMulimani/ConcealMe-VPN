import 'package:hive_flutter/hive_flutter.dart';

part 'vpn_history.g.dart';

@HiveType(typeId: 0)
class VpnHistory extends HiveObject {
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String country;

  @HiveField(3)
  final String duration;

  @HiveField(4)
  final int bytesIn;

  @HiveField(5)
  final int bytesOut;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime lastUpdatedAt;

  VpnHistory({
    required this.id,
    required this.country,
    required this.duration,
    required this.bytesIn,
    required this.bytesOut,
    required this.createdAt,
    required this.lastUpdatedAt,
  });
  @override
  String toString() {
    return 'VpnHistory{country: $country, duration: $duration, bytesIn: $bytesIn, bytesOut: $bytesOut, createdAt: $createdAt, lastUpdatedAt: $lastUpdatedAt}';
  }
}
