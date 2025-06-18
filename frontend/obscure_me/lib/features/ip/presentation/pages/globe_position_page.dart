import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';

class GlobePositionPage extends StatefulWidget {
  const GlobePositionPage({super.key});

  @override
  State<GlobePositionPage> createState() => _GlobePositionPageState();
}

class _GlobePositionPageState extends State<GlobePositionPage> {
  late FlutterEarthGlobeController _controller;
  bool _initialized = false;

  double zoom = 1;

  @override
  void initState() {
    super.initState();
    _controller = FlutterEarthGlobeController(
      zoom: zoom,
      rotationSpeed: 0.1,
      isZoomEnabled: true,
      maxZoom: 2,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/images/2k_stars.jpg').image,
      surface: Image.asset('assets/images/2k_earth-day.jpg').image,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final position = GoRouterState.of(context).extra as Map<String, dynamic>;
      _controller.addPoint(
        Point(
          id: '1',
          coordinates: GlobeCoordinates(position['lat'], position['lon']),
          label: position['location'],
          isLabelVisible: true,
          labelBuilder: (context, point, isHovering, isVisible) {
            return AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppPalette.darkBlueBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    point.label ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
          style: PointStyle(color: AppPalette.redColor, size: 6),
        ),
      );
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Location')),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterEarthGlobe(
              controller: _controller,
              radius: 80,
              onZoomChanged: (newZoom) {
                setState(() {
                  zoom = newZoom;
                });
              },
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                spacing: 2.0,
                children: [
                  FloatingActionButton(
                    backgroundColor: AppPalette.darkBlueBackgroundColor,
                    heroTag: 'zoom_in',
                    onPressed: () {
                      _controller.setZoom(zoom + 0.1);
                      setState(() {
                        zoom = zoom + 0.1;
                      });
                    },
                    mini: true,
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    backgroundColor: AppPalette.darkBlueBackgroundColor,
                    heroTag: 'zoom_out',
                    onPressed: () {
                      _controller.setZoom(zoom - 0.1);
                      setState(() {
                        zoom = zoom - 0.1;
                      });
                    },
                    mini: true,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
