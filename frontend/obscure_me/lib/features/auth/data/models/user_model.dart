import 'dart:convert';

import '../../../../core/entities/auth/user.dart';

//UserDTO = User Data Transfer Object
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.lastLogin,
    required super.isVerified,
    super.resetPasswordToken,
    super.resetPasswordExpiresAt,
    required super.isResetVerified,
    super.verificationToken,
    super.verificationTokenExpiresAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(String json) {
    return UserModel.fromMap(jsonDecode(json));
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      lastLogin:
          map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
      isVerified: map['isVerified'] ?? false,
      verificationToken: map['verificationToken'],
      verificationTokenExpiresAt:
          map['verificationTokenExpiresAt'] != null
              ? DateTime.parse(map['verificationTokenExpiresAt'])
              : null,
      isResetVerified: map['isResetVerified'] ?? false,
      resetPasswordToken: map['resetPasswordToken'],
      resetPasswordExpiresAt:
          map['resetPasswordExpiresAt'] != null
              ? DateTime.parse(map['resetPasswordExpiresAt'])
              : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
