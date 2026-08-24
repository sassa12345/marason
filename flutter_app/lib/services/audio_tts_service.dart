class AudioTtsService {
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  /// 音声ナビゲーション読み上げ (コース脱線・給水所・ペース報告)
  Future<void> speakText(String messageText) async {
    if (_isMuted) return;
    // FlutterTTSライブラリ連携呼出
    // flutterTts.speak(messageText);
    print("[TTS Speech Alert]: $messageText");
  }

  /// 応援メッセージ読み上げ & 効果音再生
  Future<void> playCheerWithAudio({
    required String senderName,
    required String messageText,
    required String audioEffect,
  }) async {
    if (_isMuted) return;

    final fullSpeechText = "$senderNameさんからの応援メッセージ。「$messageText」";
    await speakText(fullSpeechText);
  }
}
