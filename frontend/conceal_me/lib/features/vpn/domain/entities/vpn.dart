import 'package:equatable/equatable.dart';

class Vpn extends Equatable {
  final String hostName;
  final String ip;

  final String score;

  final String ping;

  final String speed;

  final String countryLong;
  final String countryShort;

  final String numVpnSessions;

  final String upTime;

  final String totalUsers;

  final String totalTraffic;

  final String logType;

  final String operator;

  final String message;

  final String openVpnConfigData;

  const Vpn({
    required this.hostName,
    required this.ip,
    required this.score,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.upTime,
    required this.totalUsers,
    required this.totalTraffic,
    required this.logType,
    required this.operator,
    required this.message,
    required this.openVpnConfigData,
  });

  // Hydrated Bloc compatibility methods
  Map<String, dynamic> toJson() => toMap();

  factory Vpn.fromJson(Map<String, dynamic> json) => Vpn.fromMap(json);

  factory Vpn.fromMap(Map<String, dynamic> map) {
    return Vpn(
      hostName: map['HostName'],
      ip: map['IP'],
      score: map['Score'],
      ping: map['Ping'],
      speed: map['Speed'],
      countryLong: map['CountryLong'],
      countryShort: map['CountryShort'],
      numVpnSessions: map['NumVpnSessions'],
      upTime: map['Uptime'],
      totalUsers: map['TotalUsers'],
      totalTraffic: map['TotalTraffic'],
      logType: map['LogType'],
      operator: map['Operator'],
      message: map['Message'],
      openVpnConfigData: map['OpenVPN_ConfigData'],
    );
  }

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

  @override
  List<Object> get props => [
    hostName,
    ip,
    score,
    ping,
    speed,
    countryLong,
    countryShort,
    numVpnSessions,
    upTime,
    totalUsers,
    totalTraffic,
    logType,
    message,
    openVpnConfigData,
  ];

  @override
  bool? get stringify => true;
}
