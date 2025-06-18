import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:obscure_me/features/ip/data/models/ip_details_model.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';

abstract interface class IpRemoteDataSource {
  Future<IpDetailsModel> getIpDetails();
}

class IpRemoteDataSourceImpl implements IpRemoteDataSource {
  @override
  Future<IpDetailsModel> getIpDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.backendUrl}/ip/'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final ipDetails = IpDetailsModel.fromMap(
          jsonDecode(response.body)['result'],
        );
        return ipDetails;
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
      // final response = await http.get(
      //   Uri.parse('http://ip-api.com/json/'),
      //   headers: {'Content-Type': 'application/json'},
      // );
      // if (response.statusCode == 200) {
      //   final ipDetails = IpDetailsModel.fromMap(jsonDecode(response.body));
      //   return ipDetails;
      // } else {
      //   throw ServerException(message: jsonDecode(response.body)['error']);
      // }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
