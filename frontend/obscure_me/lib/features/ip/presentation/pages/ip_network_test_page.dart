import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:obscure_me/core/common/widgets/custom_loading_indicator.dart';
import 'package:obscure_me/core/common/widgets/toast.dart';
import 'package:obscure_me/core/routes/app_routes.dart';
import 'package:obscure_me/features/ip/presentation/widgets/network_test_card.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../vpn/presentation/blocs/vpn_bloc/vpn_bloc.dart';
import '../blocs/ip_bloc/ip_bloc.dart';

class IpNetworkTestPage extends StatefulWidget {
  const IpNetworkTestPage({super.key});

  @override
  State<IpNetworkTestPage> createState() => _IpNetworkTestPageState();
}

class _IpNetworkTestPageState extends State<IpNetworkTestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IpBloc>().add(FetchIpDetails());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IpBloc, IpState>(
          listener: (context, state) {
            if (state is IpFailure) {
              showToast(
                type: ToastificationType.error,
                description: state.error,
              );
            }
          },
        ),
        BlocListener<VpnBloc, VpnState>(
          listener: (context, state) {
            if (state is VpnDisconnected || state is VpnConnected) {
              context.read<IpBloc>().add(FetchIpDetails());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('Network Test Page')),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppPalette.darkBlueBackgroundColor,
          foregroundColor: AppPalette.whiteColor,
          onPressed: () {
            context.read<IpBloc>().add(FetchIpDetails());
          },
          child: const Icon(CupertinoIcons.refresh_thick),
        ),
        body: BlocBuilder<IpBloc, IpState>(
          builder: (context, state) {
            if (state is IpLoading) {
              return Center(child: CustomLoadingIndicator());
            }

            if (state is IpSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 8.0,
                  children: [
                    NetworkTestCard(
                      icon: CupertinoIcons.location_solid,
                      iconColor: Colors.blueAccent,
                      suffixButton: SizedBox.shrink(),
                      title: 'IP Address',
                      value: state.ipDetails.query,
                    ),
                    NetworkTestCard(
                      icon: CupertinoIcons.building_2_fill,
                      iconColor: Colors.amber,
                      suffixButton: SizedBox.shrink(),
                      title: 'Internet Provider',
                      value: state.ipDetails.isp,
                    ),
                    NetworkTestCard(
                      icon: CupertinoIcons.location_fill,
                      iconColor: Colors.redAccent,
                      suffixButton: IconButton(
                        onPressed: () {
                          Map<String, dynamic> globalPositionMap = {
                            'location': state.ipDetails.country,
                            'lat': state.ipDetails.lat,
                            'lon': state.ipDetails.lon,
                          };
                          context.push(
                            '${AppRoutes.ipNetworkTest}${AppRoutes.globalPosition}',
                            extra: globalPositionMap,
                          );
                        },
                        icon: Icon(CupertinoIcons.globe),
                      ),
                      title: 'Location',
                      value: state.ipDetails.country,
                    ),
                    NetworkTestCard(
                      icon: CupertinoIcons.pin_fill,
                      iconColor: Colors.green,
                      suffixButton: SizedBox.shrink(),
                      title: 'Pin Code',
                      value: state.ipDetails.zip,
                    ),
                    NetworkTestCard(
                      icon: CupertinoIcons.time_solid,
                      iconColor: Colors.deepPurpleAccent,
                      suffixButton: SizedBox.shrink(),
                      title: 'Time Zone',
                      value: state.ipDetails.timezone,
                    ),
                    NetworkTestCard(
                      icon: Icons.speed_rounded,
                      iconColor: Colors.greenAccent,
                      title: 'Speed Test',
                      value: 'Measure Network Performance',
                      suffixButton: IconButton(
                        onPressed: () {
                          // To-do: handle speed test navigation
                          context.push('${AppRoutes.ipNetworkTest}${AppRoutes.speedTest}');
                        },
                        icon: Icon(Icons.play_arrow_rounded),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text('Ip Details Not Available'));
          },
        ),
      ),
    );
  }
}
