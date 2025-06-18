import 'package:flutter/material.dart';

class NetworkComponentCard extends StatelessWidget {
  const NetworkComponentCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  final String title;
  final String subTitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: width * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(subTitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
