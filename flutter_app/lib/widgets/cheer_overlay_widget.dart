import 'package:flutter/material.dart';
import '../models/cheer_message.dart';

class CheerOverlayWidget extends StatelessWidget {
  final CheerMessage? latestCheer;
  final VoidCallback onDismiss;

  const CheerOverlayWidget({
    super.key,
    required this.latestCheer,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (latestCheer == null) return const SizedBox.shrink();

    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade900, Colors.pink.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.pinkAccent, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.pinkAccent,
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Text("📢", style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossCrossAxisAlignment: CrossAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${latestCheer!.senderName} さんからの応援！",
                      style: const TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latestCheer!.messageText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
