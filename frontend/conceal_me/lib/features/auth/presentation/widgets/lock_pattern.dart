import 'package:better_pattern_lock/better_pattern_lock.dart' as lock;
import 'package:flutter/material.dart';

class LockPattern extends StatelessWidget {
  const LockPattern({super.key, required this.onEntered});
  final void Function(List<int>) onEntered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: lock.PatternLock(
        width: 3,
        height: 3,
        onEntered: onEntered,
        animationDuration: const Duration(milliseconds: 100),
        animationCurve: Curves.easeInOut,
        enableFeedback: true,
        drawLineToPointer: true,
        cellActiveArea: const lock.PatternLockCellActiveArea(
          dimension: .5, // Slightly larger touch area
          units: lock.PatternLockCellAreaUnits.relative,
          shape: lock.PatternLockCellAreaShape.circle,
        ),
        linkPainter: lock.PatternLockLinkPainter.color(
          color: Colors.blueAccent, // Smooth blue line
          width: 10,
        ),
        cellBuilder: (ctx, ind, anim) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  anim == 1
                      ? Colors
                          .blueAccent // Active cell color
                      : Colors.transparent, // Default cell color
              border: Border.all(
                width: 2.0,
                color: anim == 1 ? Colors.blueAccent : Colors.white54,
              ),
              boxShadow:
                  anim == 1
                      ? [
                        BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                      : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      anim == 1
                          ? const LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
