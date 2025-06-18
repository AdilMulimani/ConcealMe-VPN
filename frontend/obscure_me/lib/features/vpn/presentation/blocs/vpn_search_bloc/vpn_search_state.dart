part of 'vpn_search_bloc.dart';

 class VpnSearchState extends Equatable {
   final String searchTerm;

  const VpnSearchState({
    required this.searchTerm,
  });

  factory VpnSearchState.initial() {
    return const VpnSearchState(searchTerm: '');
  }


  @override
  List<Object> get props => [searchTerm];

  @override
  String toString() => 'VpnSearchState(searchTerm: $searchTerm)';

   VpnSearchState copyWith({String? searchTerm}) {
     return VpnSearchState(searchTerm: searchTerm ?? this.searchTerm,);
   }
 }
