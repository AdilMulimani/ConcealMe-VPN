import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_speed_meter/internet_speed_meter.dart';
import 'package:obscure_me/core/common/widgets/toast.dart';
import 'package:obscure_me/core/theme/app_palette.dart';
import 'package:obscure_me/features/vpn/presentation/widgets/bytes_in_out_widget.dart';
import 'package:obscure_me/features/vpn/presentation/widgets/change_location_button.dart';
import 'package:obscure_me/features/vpn/presentation/widgets/vpn_button.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/hive/models/vpn_history.dart';
import '../../domain/entities/vpn.dart';
import '../blocs/vpn_bloc/vpn_bloc.dart';

var uuid = Uuid();

class VpnHomePage extends StatefulWidget {
  const VpnHomePage({super.key});

  @override
  State<VpnHomePage> createState() => _VpnHomePageState();
}

class _VpnHomePageState extends State<VpnHomePage> {
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool granted = false;

  InternetSpeedMeter internetSpeedMeterPlugin = InternetSpeedMeter();

  bool toggleVpnButton = false;
  String defaultVpnUsername = 'vpn';
  String defaultVpnPassword = 'vpn';
  DateTime? createdAt;

  double uploadSpeed = 0.0;

  double downloadSpeed = 0.0;

  String _ip = 'Unknown IP';

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getIpAddress() async {
    try {
      var ipAddress = IpAddress(type: RequestType.text);
      dynamic result = await ipAddress.getIpAddress();
      if (mounted) {
        setState(() {
          _ip = result.toString();
        });
      }
    } on IpAddressException catch (exception) {
      if (mounted) {
        setState(() {
          _ip = 'Unknown IP';
        });
      }
      //print(exception.message);
    }
  }

  @override
  void initState() {
    super.initState();
    getIpAddress();
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = raw;
        });
      },
    );
    engine.initialize(
      groupIdentifier: 'group.com.laskarmedia.vpn',
      providerBundleIdentifier:
          'id.laskarmedia.openvpnFlutterExample.VPNExtension',
      localizedDescription: "VPN by Adil",
      lastStage: (stage) {
        setState(() {
          this.stage = stage.name;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    if (mounted) {
      engine.requestPermissionAndroid().then((value) {
        setState(() {
          granted = value;
        });
      });
    }
  }

  Future<void> initPlatformState(Vpn? server) async {
    if (server == null) return;
    try {
      engine.connect(
        server.openVpnConfigData,
        server.countryLong,
        username: defaultVpnUsername,
        password: defaultVpnPassword,
        certIsRequired: false,
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> changeLocation(VpnState state) async {
    if (engine.initialized && await engine.isConnected()) {
      engine.disconnect();
      await getIpAddress();
      if (mounted) {
        if (state is VpnConnected) {
          context.read<VpnBloc>().add(VpnDisconnect(server: state.server));
        }
        await context.push('${AppRoutes.vpnHome}${AppRoutes.vpnLocation}');
      }
    } else {
      if (mounted) {
        await context.push('${AppRoutes.vpnHome}${AppRoutes.vpnLocation}');
      }
    }
  }

  Future<void> toggleVpnConnection(VpnState state) async {
    debugPrint('Vpn Button Clicked');
    debugPrint('CheckPoint 1');
    // 1. Request permission if not granted
    if (!granted) {
      granted = await engine.requestPermissionAndroid();
      setState(() {}); // Refresh UI
      if (!granted) return;
    }
    debugPrint('CheckPoint 2');
    final engineConnected = await engine.isConnected();
    debugPrint('Engine Connected = $engineConnected');

    // 2. Get selected server from state
    Vpn? selectedServer;
    if (state is VpnSelect ||
        state is VpnDisconnected ||
        state is VpnConnected) {
      selectedServer = (state as dynamic).server;
    }
    debugPrint('CheckPoint 3');

    // 3. Show error if no location selected
    if (selectedServer == null) {
      showToast(
        type: ToastificationType.error,
        description: 'Select a Location',
      );
      return;
    }
    debugPrint('CheckPoint 4');

    // 4. If not connected, connect to VPN
    if (!engineConnected) {
      debugPrint('CheckPoint 5');
      setState(() {
        createdAt = DateTime.now();
      });
      if (engine.initialized) {
        debugPrint('CheckPoint 6');

        // await initPlatformState(selectedServer);
        //  if (server == null) return;
        // Await the connection attempt
        try {
          debugPrint("Attempting to connect to VPN...");
          engine.connect(
            selectedServer.openVpnConfigData,
            selectedServer.countryLong,
            username: defaultVpnUsername,
            password: defaultVpnPassword,
            certIsRequired: true,
          );
          // // Add a small delay to allow connection to establish
          // await Future.delayed(Duration(seconds: 5));
          // debugPrint('Value returned $value');
          //
          // // After connect() completes, check connection status
          // debugPrint('CheckPoint 7');
          // bool engineConnectedNow = await engine.isConnected();
          // debugPrint("Is connected = $engineConnectedNow");
          //
          // if (engineConnectedNow) {
          //   debugPrint("Executed");
          //   context.read<VpnBloc>().add(VpnConnect(server: selectedServer!));
          //   setState(() {
          //     toggleVpnButton = true;
          //   });
          //}

          // Poll connection status
          int attempts = 0;
          while (attempts < 20) {
            // Try for up to 30 seconds
            await Future.delayed(Duration(seconds: 1));
            bool engineConnectedNow = await engine.isConnected();
            debugPrint(
              "Connection check attempt ${attempts + 1}: $engineConnectedNow",
            );

            if (engineConnectedNow) {
              // Connection established, update UI
              await getIpAddress();
              context.read<VpnBloc>().add(VpnConnect(server: selectedServer));
              setState(() {
                toggleVpnButton = true;
              });
              break;
            }
            attempts++;
          }

          // Handle case where connection never establishes
          if (attempts >= 20) {
            engine.disconnect();
            await getIpAddress();
            showToast(
              type: ToastificationType.error,
              description: 'VPN connection timed out',
            );
          }
        } catch (e, stackTrace) {
          debugPrint("VPN Connect Error: $e");
          debugPrint("StackTrace: $stackTrace");
          showToast(
            type: ToastificationType.error,
            description: 'VPN connection failed: $e',
          );
        }
      }
    }
    // 5. If already connected, disconnect and store history
    else {
      final int bytesIn = int.tryParse(status?.byteIn ?? '0') ?? 0;
      final int bytesOut = int.tryParse(status?.byteOut ?? '0') ?? 0;
      final String country = selectedServer.countryShort;
      final String duration = status?.duration ?? '00:00';

      engine.disconnect();

      if (mounted) {
        context.read<VpnBloc>().add(VpnDisconnect(server: selectedServer));
      }

      // Save to Hive
      createdAt ??= DateTime.now();
      final historyBox = Hive.box<VpnHistory>('vpnHistoryBox');
      final history = VpnHistory(
        id: uuid.v4(),
        country: country,
        duration: duration,
        bytesIn: bytesIn,
        bytesOut: bytesOut,
        createdAt: createdAt!,
        lastUpdatedAt: DateTime.now(),
      );
      await historyBox.add(history);

      await getIpAddress();

      setState(() {
        toggleVpnButton = false;
        // Reset connection time
        createdAt = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = stage?.compareTo('connected') == 0;
    return Scaffold(
      body: BlocConsumer<VpnBloc, VpnState>(
        listener: (context, state) {
          if (state is VpnSelect) {
            showToast(
              type: ToastificationType.success,
              description: '${state.server.countryLong} selected',
            );
          }
          if (state is VpnConnected) {
            showToast(
              type: ToastificationType.success,
              description: '${state.server.countryLong} connected',
            );
          }
        },
        builder: (context, state) {
          if (state is VpnSelect) {
            debugPrint('Selected Server = ${state.server.countryLong}');
          }
          if (state is VpnConnected) {
            debugPrint('Connected Server = ${state.server.countryLong}');
          }
          return SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // World Map Image
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 64.0),
                //   child: Image.asset(
                //     width: double.infinity,
                //     'assets/images/disconnected_map.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                // Main content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 2.0,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            '${AppRoutes.vpnHome}${AppRoutes.vpnHistory}',
                          );
                        },
                        child: Text('Vpn History'),
                      ),
                      // Change Location Button
                      ChangeLocationButton(
                        onPressed: () => changeLocation(state),
                        isConnected: isConnected,
                      ),
                      // Country Text
                      switch (state) {
                        VpnInitial() => Text(
                          'No Location Selected',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color:
                                isConnected
                                    ? AppPalette.primaryColor
                                    : Colors.orange,
                          ),
                        ),
                        VpnLoading() => Text(
                          'No Location Selected',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color:
                                isConnected
                                    ? AppPalette.primaryColor
                                    : Colors.orange,
                          ),
                        ),
                        VpnSelect() => Text(
                          state.server.countryLong,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color:
                                isConnected
                                    ? AppPalette.primaryColor
                                    : Colors.orange,
                          ),
                        ),
                        VpnConnected() => Text(
                          state.server.countryLong,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color:
                                isConnected
                                    ? AppPalette.primaryColor
                                    : Colors.orange,
                          ),
                        ),
                        VpnDisconnected() => Text(
                          state.server.countryLong,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color:
                                isConnected
                                    ? AppPalette.primaryColor
                                    : Colors.orange,
                          ),
                        ),
                      },
                      // Vpn Connection Duration
                      Text(
                        isConnected ? '${status?.duration}' : '00:00',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color:
                              isConnected
                                  ? AppPalette.primaryColor
                                  : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom container pinned
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(48.0),
                          topRight: Radius.circular(48.0),
                        ),
                      ),
                      color:
                          isConnected ? AppPalette.primaryColor : Colors.orange,
                    ),
                    padding: EdgeInsets.all(32),
                    child: Column(
                      spacing: 16.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //  SizedBox(height: 24),
                        // VPN Button
                        VpnButton(
                          onTap: () => toggleVpnConnection(state),
                          hostAddress: _ip,
                          stage: stage,
                          isConnected: stage?.compareTo('connected') == 0,
                        ),
                        // Upload and Download
                        BytesInOutWidget(
                          isConnected: isConnected,
                          status: status,
                        ),
                      ],
                    ),
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
