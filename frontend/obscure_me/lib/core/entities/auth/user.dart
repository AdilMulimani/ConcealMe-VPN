import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  // final String jwtToken;
  final DateTime? lastLogin;
  final bool isVerified;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpiresAt;
  final bool isResetVerified;
  final String? verificationToken;
  final DateTime? verificationTokenExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    // required this.jwtToken,
    this.lastLogin,
    required this.isVerified,
    this.resetPasswordToken,
    this.resetPasswordExpiresAt,
    required this.isResetVerified,
    this.verificationToken,
    this.verificationTokenExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? jwtToken,
    DateTime? lastLogin,
    bool? isVerified,
    String? resetPasswordToken,
    DateTime? resetPasswordExpiresAt,
    bool? isResetVerified,
    String? verificationToken,
    DateTime? verificationTokenExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      //  jwtToken: jwtToken ?? this.jwtToken,
      lastLogin: lastLogin ?? this.lastLogin,
      isVerified: isVerified ?? this.isVerified,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordExpiresAt:
          resetPasswordExpiresAt ?? this.resetPasswordExpiresAt,
      isResetVerified: isResetVerified ?? this.isResetVerified,
      verificationToken: verificationToken ?? this.verificationToken,
      verificationTokenExpiresAt:
          verificationTokenExpiresAt ?? this.verificationTokenExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    // jwtToken,
    lastLogin,
    isVerified,
    resetPasswordToken,
    resetPasswordExpiresAt,
    isResetVerified,
    verificationToken,
    verificationTokenExpiresAt,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, lastLogin: $lastLogin, isVerified: $isVerified, resetPasswordToken: $resetPasswordToken, resetPasswordExpiresAt: $resetPasswordExpiresAt, isResetVerified: $isResetVerified, verificationToken: $verificationToken, verificationTokenExpiresAt: $verificationTokenExpiresAt, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
