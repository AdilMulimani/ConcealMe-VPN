import 'dart:convert';

import 'package:obscure_me/features/vpn/domain/entities/vpn.dart';

class VpnModel extends Vpn {
  const VpnModel({
    required super.hostName,
    required super.ip,
    required super.score,
    required super.ping,
    required super.speed,
    required super.countryLong,
    required super.countryShort,
    required super.numVpnSessions,
    required super.upTime,
    required super.totalUsers,
    required super.totalTraffic,
    required super.logType,
    required super.operator,
    required super.message,
    required super.openVpnConfigData,
  });

  factory VpnModel.fromJson(String json) {
    return VpnModel.fromMap(jsonDecode(json));
  }

  factory VpnModel.fromMap(Map<String, dynamic> map) {
    return VpnModel(
      hostName: map['HostName'] ?? '',
      ip: map['IP'] ?? '',
      score: map['Score'] ?? '',
      ping: map['Ping'] ?? '',
      speed: map['Speed'] ?? '',
      countryLong: map['CountryLong'] ?? '',
      countryShort: map['CountryShort'] ?? '',
      numVpnSessions: map['NumVpnSessions'] ?? '',
      upTime: map['Uptime'] ?? '',
      totalUsers: map['TotalUsers'] ?? '',
      totalTraffic: map['TotalTraffic'] ?? '',
      logType: map['LogType'] ?? '',
      operator: map['Operator'] ?? '',
      message: map['Message'] ?? '',
      openVpnConfigData: map['OpenVPN_ConfigData'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'HostName': hostName,
    'IP': ip,
    'Score': score,
    'Ping': ping,
    'Speed': speed,
    'CountryLong': countryLong,
    'CountryShort': countryShort,
    'NumVpnSessions': numVpnSessions,
    'UpTime': upTime,
    'TotalUsers': totalUsers,
    'TotalTraffic': totalTraffic,
    'LogType': logType,
    'Operator': operator,
    'Message': message,
    'OpenVPN_ConfigData': openVpnConfigData,
  };
}
