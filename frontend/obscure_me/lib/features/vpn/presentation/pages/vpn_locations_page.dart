import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:obscure_me/core/common/widgets/custom_loading_indicator.dart';
import 'package:obscure_me/core/theme/app_palette.dart';
import 'package:obscure_me/features/vpn/presentation/widgets/network_bars_widget.dart';

import '../../domain/entities/vpn.dart';
import '../blocs/filtered_vpn_bloc/filtered_vpn_bloc.dart';
import '../blocs/vpn_bloc/vpn_bloc.dart';
import '../blocs/vpn_list_bloc/vpn_list_bloc.dart';
import '../blocs/vpn_search_bloc/vpn_search_bloc.dart';

class VpnLocationsPage extends StatefulWidget {
  const VpnLocationsPage({super.key});

  @override
  State<VpnLocationsPage> createState() => _VpnLocationsPageState();
}

class _VpnLocationsPageState extends State<VpnLocationsPage> {
  var formatter = NumberFormat('#,##0');
  final TextEditingController searchEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final vpnListState = context.read<VpnListBloc>().state;
    if (vpnListState is VpnListFetched) {
      // Reset to unfiltered list when coming back to the page
      context.read<FilteredVpnBloc>().add(
        CalculateFilteredVpnEvent(filteredVpnServers: vpnListState.servers),
      );

      // Also clear the previous search term
      context.read<VpnSearchBloc>().add(SetSearchTermEvent(newSearchTerm: ''));
      searchEditingController.clear();
    } else {
      context.read<VpnListBloc>().add(
        FetchVpnListEvent(refreshServerList: false),
      );
    }
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  List<Vpn> setFilteredVpnServers(List<Vpn> servers, String searchTerm) {
    if (searchTerm.isNotEmpty) {
      return servers
          .where(
            (Vpn server) => server.countryLong.toLowerCase().contains(
              searchTerm.toLowerCase(),
            ),
          )
          .toList();
    }
    return servers;
  }

  @override
  Widget build(BuildContext context) {
    final filteredServers =
        context.watch<FilteredVpnBloc>().state.filteredVpnServers;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Available VPN Servers",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.darkBlueBackgroundColor,
        foregroundColor: AppPalette.whiteColor,
        onPressed: () {
          context.read<VpnListBloc>().add(
            FetchVpnListEvent(refreshServerList: true),
          );
        },
        child: const Icon(CupertinoIcons.refresh_thick),
      ),
      body: BlocConsumer<VpnListBloc, VpnListState>(
        listener: (context, state) {
          if (state is VpnListFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }

          if (state is VpnListFetched) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Servers fetched successfully')),
            );

            // Update FilteredVpnBloc on fetch
            final searchTerm = context.read<VpnSearchBloc>().state.searchTerm;
            final filteredServers = setFilteredVpnServers(
              state.servers,
              searchTerm,
            );
            context.read<FilteredVpnBloc>().add(
              CalculateFilteredVpnEvent(filteredVpnServers: filteredServers),
            );
          }
        },
        builder: (context, state) {
          if (state is VpnListLoading) {
            return const Center(child: CustomLoadingIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    controller: searchEditingController,
                    onChanged: (String? newSearchTerm) {
                      if (newSearchTerm != null) {
                        context.read<VpnSearchBloc>().add(
                          SetSearchTermEvent(newSearchTerm: newSearchTerm),
                        );

                        final vpnListState = context.read<VpnListBloc>().state;
                        if (vpnListState is VpnListFetched) {
                          final filtered = setFilteredVpnServers(
                            vpnListState.servers,
                            newSearchTerm,
                          );
                          context.read<FilteredVpnBloc>().add(
                            CalculateFilteredVpnEvent(
                              filteredVpnServers: filtered,
                            ),
                          );
                        }
                      }
                    },
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: AppPalette.darkBlueBackgroundColor,
                      filled: true,
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(CupertinoIcons.search),
                    ),
                  ),
                ),
                Expanded(
                  child:
                      filteredServers.isNotEmpty
                          ? ListView.builder(
                            itemCount: filteredServers.length,
                            itemBuilder: (context, index) {
                              final Vpn server = filteredServers[index];
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  padding: const EdgeInsets.all(24.0),
                                  decoration: BoxDecoration(
                                    color: AppPalette.darkBlueBackgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CountryFlag.fromCountryCode(
                                        server.countryShort,
                                        shape: RoundedRectangle(8.0),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              server.countryLong,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${formatter.format(int.parse(server.totalUsers))} online',
                                            ),
                                          ],
                                        ),
                                      ),
                                      NetworkSpeedBars(speed: server.speed),
                                      IconButton(
                                        onPressed: () {
                                          context.read<VpnBloc>().add(
                                            VpnSelectVpn(server: server),
                                          );
                                          context.pop(server);
                                        },
                                        icon: Icon(
                                          Icons.navigate_next_rounded,
                                          size: 30,
                                          color: AppPalette.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                          : const Center(
                            child: Text("No VPN servers available"),
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
