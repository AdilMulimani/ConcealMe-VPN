import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:obscure_me/core/constants/constants.dart';
import 'package:obscure_me/core/utils/jwt.dart';
import 'package:obscure_me/features/auth/data/datasources/auth_local_data_source.dart';

import '../../../../core/entities/auth/user.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/remote_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRemoteRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
  });
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final User user = await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      // Save the token
      await authLocalDataSource.saveToken(authResponse.token);
      debugPrint("Token:");
      debugPrint(await authLocalDataSource.getToken('JWT_TOKEN_KEY'));
      return right(authResponse.user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> emailVerification({
    required String verificationToken,
  }) async {
    try {
      final User user = await authRemoteDataSource.emailVerification(
        verificationToken: verificationToken,
      );
      return right(user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPasswordWithEmail({
    required String email,
  }) async {
    try {
      final String message = await authRemoteDataSource.forgotPasswordWithEmail(
        email: email,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resetPasswordVerification({
    required String resetPasswordToken,
  }) async {
    try {
      final message = await authRemoteDataSource.resetPasswordVerification(
        resetPasswordToken: resetPasswordToken,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String password,
    required String resetPasswordToken,
  }) async {
    try {
      final message = await authRemoteDataSource.resetPassword(
        password: password,
        resetPasswordToken: resetPasswordToken,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      String key = Constants.jwtKey;
      final savedToken = await authLocalDataSource.getToken(key);
      debugPrint('Saved token = $savedToken');
      if (savedToken == null) {
        return left(Failure('No token saved.'));
      } else if (isTokenExpired(savedToken)) {
        await authLocalDataSource.deleteToken(key);
        return left(Failure('Session expired, please login again.'));
      }
      final user = await authRemoteDataSource.getCurrentUser(token: savedToken);
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
