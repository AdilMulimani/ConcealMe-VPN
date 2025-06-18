import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String backendUrl = dotenv.env['BACKEND_URL']!;
  static final String jwtKey = 'JWT_TOKEN_KEY';

  static final String userIdKey = 'USER_ID_KEY';
}
