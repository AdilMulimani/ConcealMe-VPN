part of 'ip_bloc.dart';

sealed class IpState extends Equatable {
  @override
  List<Object?> get props => [];

  const IpState();
}

final class IpInitial extends IpState {}

final class IpLoading extends IpState {}

final class IpFailure extends IpState {
  final String error;

  const IpFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class IpSuccess extends IpState {
  final IpDetails ipDetails;

  const IpSuccess({required this.ipDetails});

  @override
  List<Object> get props => [ipDetails];
}
