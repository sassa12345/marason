import 'package:flutter/material.dart';
import '../models/runner_state.dart';

class RunnerHudWidget extends StatelessWidget {
  final RunnerState me;
  final bool isOffCourse;
  final String navInstruction;

  const RunnerHudWidget({
    super.key,
    required this.me,
    required this.isOffCourse,
    required this.navInstruction,
  });

  @override
  Widget build(BuildContext context) {
    final themeBg = isOffCourse
        ? Colors.red.shade900.withOpacity(0.9)
        : Colors.black.withOpacity(0.85);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOffCourse ? Colors.redAccent : Colors.cyanAccent.shade400,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isOffCourse
                ? Colors.red.withOpacity(0.5)
                : Colors.cyan.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 走行案内プロンプト
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isOffCourse ? Colors.redAccent : Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isOffCourse ? Icons.warning_rounded : Icons.navigation,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    navInstruction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // HUD主要数値 (ペース, 距離, バッテリー)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHudItem("ペース", me.paceString, Colors.amberAccent),
              _buildHudItem(
                  "走行距離",
                  "${(me.distanceMeters / 1000).toStringAsFixed(2)} km",
                  Colors.cyanAccent),
              _buildHudItem("速度", "${me.speedKmH.toStringAsFixed(1)} km/h",
                  Colors.greenAccent),
              _buildHudItem(
                  "電池", "${me.batteryPercent}%", Colors.lightGreenAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHudItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
