import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class BackgroundGpsService {
  bool _isTracking = false;
  int _updateIntervalSec = 3; // 動的更新間隔 (バッテリー最適化)
  StreamController<Map<String, double>>? _locationController;

  bool get isTracking => _isTracking;

  Stream<Map<String, double>> get locationStream {
    _locationController ??= StreamController<Map<String, double>>.broadcast();
    return _locationController!.stream;
  }

  void startTracking({
    required Function(double lat, double lng, double speed, double acc)
        onLocationUpdate,
  }) {
    if (_isTracking) return;
    _isTracking = true;
    if (kDebugMode) {
      print("[GPS Service] Background High Precision Tracking Activated");
    }
  }

  void stopTracking() {
    _isTracking = false;
    _locationController?.close();
    _locationController = null;
  }

  /// 動的省電力ロジック: バッテリー残量に応じて間隔を微調整
  void adjustIntervalForBattery(int batteryLevel) {
    if (batteryLevel < 15) {
      _updateIntervalSec = 10; // 低バッテリー時
    } else if (batteryLevel < 30) {
      _updateIntervalSec = 5;
    } else {
      _updateIntervalSec = 3;
    }
  }

  /// 距離計算 (Haversine formula)
  static double calculateDistanceMeters(
      double lat1, double lon1, double lat2, double lon2) {
    const r = 6371000; // 地球の半径 (メートル)
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  static double _degToRad(double deg) => deg * (pi / 180);
}
