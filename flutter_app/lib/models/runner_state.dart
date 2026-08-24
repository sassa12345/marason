class RunnerState {
  final String id;
  final String name;
  final String avatar;
  final bool isHost;
  final double lat;
  final double lng;
  final double speedKmH;
  final double distanceMeters;
  final double accuracyMeters;
  final int batteryPercent;
  final bool isOffCourse;
  final double distToCourseMeters;
  final int lastUpdatedTimestamp;

  RunnerState({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isHost,
    required this.lat,
    required this.lng,
    required this.speedKmH,
    required this.distanceMeters,
    required this.accuracyMeters,
    required this.batteryPercent,
    required this.isOffCourse,
    required this.distToCourseMeters,
    required this.lastUpdatedTimestamp,
  });

  String get paceString {
    if (speedKmH < 0.5) return "-'--\"/km";
    final paceMinKm = 60 / speedKmH;
    final mins = paceMinKm.floor();
    final secs = ((paceMinKm - mins) * 60).round();
    return "$mins'${secs.toString().padLeft(2, '0')}\"/km";
  }

  // ギガ節約: ペイロード軽量化マップ構造
  Map<String, dynamic> toCompactMap() => {
        'id': id,
        'name': name,
        'av': avatar,
        'h': isHost ? 1 : 0,
        'la': double.parse(lat.toStringAsFixed(6)),
        'ln': double.parse(lng.toStringAsFixed(6)),
        'sp': double.parse(speedKmH.toStringAsFixed(1)),
        'di': distanceMeters.round(),
        'ac': double.parse(accuracyMeters.toStringAsFixed(1)),
        'ba': batteryPercent,
        'off': isOffCourse ? 1 : 0,
        'offD': distToCourseMeters.round(),
        'ts': lastUpdatedTimestamp,
      };

  factory RunnerState.fromCompactMap(Map<String, dynamic> map) => RunnerState(
        id: map['id'] ?? '',
        name: map['name'] ?? 'ランナー',
        avatar: map['av'] ?? '🏃',
        isHost: (map['h'] ?? 0) == 1,
        lat: (map['la'] as num).toDouble(),
        lng: (map['ln'] as num).toDouble(),
        speedKmH: (map['sp'] as num).toDouble(),
        distanceMeters: (map['di'] as num).toDouble(),
        accuracyMeters: (map['ac'] as num).toDouble(),
        batteryPercent: (map['ba'] as num).toInt(),
        isOffCourse: (map['off'] ?? 0) == 1,
        distToCourseMeters: (map['offD'] as num).toDouble(),
        lastUpdatedTimestamp: (map['ts'] as num? ?? 0).toInt(),
      );
}
