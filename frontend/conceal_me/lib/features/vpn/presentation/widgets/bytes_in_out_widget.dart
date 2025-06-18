import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class BytesInOutWidget extends StatelessWidget {
  const BytesInOutWidget({super.key, required this.isConnected,required this.status});
  final bool isConnected;
  final VpnStatus? status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16.0,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isConnected ? Colors.blueAccent : Colors.orangeAccent,
            shape: BoxShape.rectangle,
          ),
          child: Row(
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.download),
              Text(
                isConnected
                    ? '${((int.tryParse(status!.byteIn!)! / 1000)).toInt()} KB'
                    : '0 Kb',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isConnected ? Colors.blueAccent : Colors.orangeAccent,
            shape: BoxShape.rectangle,
          ),
          child: Row(
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.upload),
              Text(
                isConnected
                    ? '${((int.tryParse(status!.byteOut!)! / 1000)).toInt()} KB'
                    : '0 KB',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
