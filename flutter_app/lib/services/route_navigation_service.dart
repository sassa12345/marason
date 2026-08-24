import 'dart:math';
import '../models/marathon_route.dart';
import 'background_gps_service.dart';

class NavigationResult {
  final bool isOffCourse;
  final double distanceToCourseMeters;
  final String nextInstructionText;
  final double distanceToNextWaypointMeters;

  NavigationResult({
    required this.isOffCourse,
    required this.distanceToCourseMeters,
    required this.nextInstructionText,
    required this.distanceToNextWaypointMeters,
  });
}

class RouteNavigationService {
  static const double offCourseThresholdMeters = 35.0; // 35m以上離れたら警告

  static NavigationResult evaluatePosition({
    required double currentLat,
    required double currentLng,
    required MarathonRoute route,
  }) {
    if (route.coordinates.isEmpty) {
      return NavigationResult(
        isOffCourse: false,
        distanceToCourseMeters: 0,
        nextInstructionText: 'コースデータがありません',
        distanceToNextWaypointMeters: 0,
      );
    }

    // 1. 最寄りのコース座標ラインとの最小距離を算出
    double minDistance = double.infinity;
    for (int i = 0; i < route.coordinates.length; i++) {
      final point = route.coordinates[i];
      final dist = BackgroundGpsService.calculateDistanceMeters(
        currentLat,
        currentLng,
        point[0],
        point[1],
      );
      if (dist < minDistance) {
        minDistance = dist;
      }
    }

    final bool isOff = minDistance > offCourseThresholdMeters;

    // 2. 次のチェックポイント / 給水所の案内
    String instruction = 'コース順調に巡航中';
    double nextWpDist = double.infinity;

    for (final wp in route.waypoints) {
      final wpDist = BackgroundGpsService.calculateDistanceMeters(
        currentLat,
        currentLng,
        wp.lat,
        wp.lng,
      );
      if (wpDist < nextWpDist) {
        nextWpDist = wpDist;
        if (wpDist < 100) {
          instruction = 'まもなく ${wp.title} （残り${wpDist.round()}m）';
        } else {
          instruction = '次の目的地: ${wp.title} （${(wpDist / 1000).toStringAsFixed(1)}km先）';
        }
      }
    }

    if (isOff) {
      instruction = '⚠️ コースから脱線しています！ コースへ戻回してください（${minDistance.round()}m離脱）';
    }

    return NavigationResult(
      isOffCourse: isOff,
      distanceToCourseMeters: minDistance,
      nextInstructionText: instruction,
      distanceToNextWaypointMeters: nextWpDist == double.infinity ? 0 : nextWpDist,
    );
  }
}
