import 'package:flutter/material.dart';
import 'package:obscure_me/core/theme/app_palette.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:ripple_wave/ripple_wave.dart';

class VpnButton extends StatefulWidget {
  const VpnButton({
    super.key,
    required this.onTap,
    required this.stage,
    required this.isConnected,
    required this.hostAddress,
  });

  final VoidCallback onTap;
  final String? stage;
  final bool isConnected;
  final String? hostAddress;

  @override
  State<VpnButton> createState() => _VpnButtonState();
}

class _VpnButtonState extends State<VpnButton> with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.isConnected) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VpnButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected != oldWidget.isConnected) {
      if (widget.isConnected) {
        controller.repeat();
      } else {
        controller.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: RippleWave(
        animationController: controller,
        repeat: false,
        color: widget.isConnected ? AppPalette.primaryColor : Colors.orange,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: widget.isConnected ? Color(0xff219cf3) : Color(0xffffb652),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: widget.isConnected ? Color(0xff74bcf6) : Color(0xfff5ca8a),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.white70,
              ),
              child: Container(
                height: 180,
                width: 180,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new_sharp,
                      color:
                          widget.isConnected
                              ? AppPalette.primaryColor
                              : Colors.orange,
                      size: 60,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.stage?.toString() ??
                          VPNStage.disconnected.toString(),
                      style: TextStyle(
                        color:
                            widget.isConnected
                                ? AppPalette.primaryColor
                                : Colors.orange,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.hostAddress != null
                          ? widget.hostAddress.toString()
                          : '',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
