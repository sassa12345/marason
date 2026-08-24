class BatteryOptimizerService {
  /// パケット通信データ量を最小化するため、位置情報JSONのプロパティ名を極限短縮化
  static int calculatePacketSavingsBytes({
    required int rawCount,
    required int optimizedCount,
  }) {
    // 通常のJSON (約 320 bytes / パケット) vs 省電力・極短縮JSON (約 85 bytes / パケット)
    const normalSize = 320;
    const optimizedSize = 85;
    return (rawCount * normalSize) - (optimizedCount * optimizedSize);
  }

  /// ディスプレイ消費電力を抑えるOLED / Amoled真のブラックテーマ判定
  static bool isOledFriendly(int batteryPercent) {
    return batteryPercent <= 20;
  }
}
