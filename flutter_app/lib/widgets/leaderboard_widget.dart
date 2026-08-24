import 'package:flutter/material.dart';
import '../models/runner_state.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<RunnerState> runners;
  final String currentRunnerId;

  const LeaderboardWidget({
    super.key,
    required this.runners,
    required this.currentRunnerId,
  });

  @override
  Widget build(BuildContext context) {
    // 走行距離順にソート
    final sortedRunners = List<RunnerState>.from(runners)
      ..sort((a, b) => b.distanceMeters.compareTo(a.distanceMeters));

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                "リアルタイム順位表 (全ランナー)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: sortedRunners.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white12, height: 1),
              itemBuilder: (context, index) {
                final runner = sortedRunners[index];
                final isMe = runner.id == currentRunnerId;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.cyanAccent.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // 順位バッジ
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey.shade400
                                  : index == 2
                                      ? Colors.brown.shade400
                                      : Colors.blueGrey.shade800,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(runner.avatar, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  runner.name,
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.cyanAccent
                                        : Colors.white,
                                    fontWeight: isMe
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                if (runner.isHost)
                                  Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "HOST",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              "ペース: ${runner.paceString} | 電池: ${runner.batteryPercent}%",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAlignment.end,
                        children: [
                          Text(
                            "${(runner.distanceMeters / 1000).toStringAsFixed(2)} km",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (runner.isOffCourse)
                            const Text(
                              "脱線中",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 10),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
