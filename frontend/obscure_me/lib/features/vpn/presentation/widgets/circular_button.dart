import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  const CircularButton({
    super.key,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30, // Adjust size as needed
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppPalette.primaryColor,
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(3),
            width: 20, // Adjust inner circle size
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.blackColor,
              // Background color
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected
                        ? AppPalette.primaryColor
                        : AppPalette.blackColor,
              ),
              width: isSelected ? 10 : 0,
              height: isSelected ? 10 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
