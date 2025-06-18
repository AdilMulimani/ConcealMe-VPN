import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/ip_details_model.dart';

abstract interface class IpLocalDataSource {
  IpDetailsModel getLocalIpDetails();

  void uploadLocalIpDetails({required IpDetailsModel ipDetails});
}

class IpLocalDataSourceImpl implements IpLocalDataSource {
  final Box box;
  const IpLocalDataSourceImpl({required this.box});

  @override
  IpDetailsModel getLocalIpDetails() {
    final Map<String, dynamic> jsonLocalIpDetails = jsonDecode(
      box.get('local_ip_details') ?? '{}',
    );
    IpDetailsModel localIpDetails = IpDetailsModel.fromMap(jsonLocalIpDetails);
    return localIpDetails;
  }

  @override
  void uploadLocalIpDetails({required IpDetailsModel ipDetails}) {
    box.clear();
    final jsonIpDetails = jsonEncode(ipDetails);
    box.put('local_ip_details', jsonIpDetails);
  }
}
