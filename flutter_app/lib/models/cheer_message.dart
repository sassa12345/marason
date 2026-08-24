class CheerMessage {
  final String id;
  final String senderName;
  final String targetRunnerId;
  final String messageText;
  final String audioEffect; // 'cheer', 'applause', 'horn', 'whistle'
  final int timestamp;

  CheerMessage({
    required this.id,
    required this.senderName,
    required this.targetRunnerId,
    required this.messageText,
    required this.audioEffect,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderName': senderName,
        'targetRunnerId': targetRunnerId,
        'messageText': messageText,
        'audioEffect': audioEffect,
        'timestamp': timestamp,
      };

  factory CheerMessage.fromMap(Map<String, dynamic> map) => CheerMessage(
        id: map['id'] ?? '',
        senderName: map['senderName'] ?? '応援者',
        targetRunnerId: map['targetRunnerId'] ?? '',
        messageText: map['messageText'] ?? '',
        audioEffect: map['audioEffect'] ?? 'cheer',
        timestamp: (map['timestamp'] as num? ?? 0).toInt(),
      );
}
