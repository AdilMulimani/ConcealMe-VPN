import 'package:equatable/equatable.dart';

class IpDetails extends Equatable {
  const IpDetails({
    required this.status,
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.as,
    required this.query,
  });

  final String status;
  final String country;
  final String countryCode;
  final String region;
  final String regionName;
  final String city;
  final String zip;
  final double lat;
  final double lon;
  final String timezone;
  final String isp;
  final String org;
  final String as;
  final String query;

  factory IpDetails.initial() {
    return IpDetails(
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

  IpDetails copyWith({
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
    return IpDetails(
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

  factory IpDetails.fromMap(Map<String, dynamic> map) {
    return IpDetails(
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

  @override
  List<Object> get props => [
    status,
    country,
    countryCode,
    region,
    regionName,
    city,
    zip,
    lat,
    lon,
    timezone,
    isp,
    org,
    query,
  ];

  @override
  String toString() {
    return 'IpDetails{status: $status, country: $country, countryCode: $countryCode, region: $region, regionName: $regionName, city: $city, zip: $zip, lat: $lat, lon: $lon, timezone: $timezone, isp: $isp, org: $org, as: $as, query: $query}';
  }
}
