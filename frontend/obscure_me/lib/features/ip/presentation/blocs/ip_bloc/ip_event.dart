part of 'ip_bloc.dart';

sealed class IpEvent extends Equatable {
  @override
  List<Object> get props => [];

  const IpEvent();
}

class FetchIpDetails extends IpEvent {
  const FetchIpDetails();
}
