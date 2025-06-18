import 'dart:convert';

import 'package:conceal_me/features/ip/domain/entities/ip_details.dart';

class IpDetailsModel extends IpDetails {
  const IpDetailsModel({
    required super.status,
    required super.country,
    required super.countryCode,
    required super.region,
    required super.regionName,
    required super.city,
    required super.zip,
    required super.lat,
    required super.lon,
    required super.timezone,
    required super.isp,
    required super.org,
    required super.as,
    required super.query,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'regionName': regionName,
      'city': city,
      'zip': zip,
      'lat': lat,
      'lon': lon,
      'timezone': timezone,
      'isp': isp,
      'org': org,
      'as': as,
      'query': query,
    };
  }

  @override
  factory IpDetailsModel.initial() {
    return IpDetailsModel(
      status: 'Unknown',
      country: 'Unknown',
      countryCode: 'Unknown',
      region: 'Unknown',
      regionName: 'Unknown',
      city: 'Unknown',
      zip: 'Not available',
      lat: 0,
      lon: 0,
      timezone: 'Not available',
      isp: 'Unknown',
      org: 'Unknown',
      as: 'Unknown',
      query: 'Not available',
    );
  }

  @override
  IpDetailsModel copyWith({
    String? status,
    String? country,
    String? countryCode,
    String? region,
    String? regionName,
    String? city,
    String? zip,
    double? lat,
    double? lon,
    String? timezone,
    String? isp,
    String? org,
    String? as,
    String? query,
  }) {
    return IpDetailsModel(
      status: status ?? this.status,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      regionName: regionName ?? this.regionName,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      timezone: timezone ?? this.timezone,
      isp: isp ?? this.isp,
      org: org ?? this.org,
      as: as ?? this.as,
      query: query ?? this.query,
    );
  }

  factory IpDetailsModel.fromJson(String json) {
    return IpDetailsModel.fromMap(jsonDecode(json));
  }

  factory IpDetailsModel.fromMap(Map<String, dynamic> map) {
    return IpDetailsModel(
      status: map['status'] ?? '',
      country: map['country'] ?? '',
      countryCode: map['countryCode'] ?? '',
      region: map['region'] ?? '',
      regionName: map['regionName'] ?? '',
      city: map['city'] ?? '',
      zip: map['zip'] ?? '------',
      lat: map['lat'] ?? '',
      lon: map['lon'] ?? '',
      timezone: map['timezone'] ?? 'Not available',
      isp: map['isp'] ?? 'Unknown',
      org: map['org'] ?? 'Unknown',
      as: map['as'] ?? 'Unknown',
      query: map['query'] ?? 'Not available',
    );
  }
}
