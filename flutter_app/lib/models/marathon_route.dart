class Waypoint {
  final String id;
  final double lat;
  final double lng;
  final String title;
  final String type; // 'start', 'water', 'turn', 'checkpoint', 'finish'
  final double distanceFromStartMeters;

  Waypoint({
    required this.id,
    required this.lat,
    required this.lng,
    required this.title,
    required this.type,
    required this.distanceFromStartMeters,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': lat,
        'lng': lng,
        'title': title,
        'type': type,
        'distanceFromStartMeters': distanceFromStartMeters,
      };

  factory Waypoint.fromMap(Map<String, dynamic> map) => Waypoint(
        id: map['id'] ?? '',
        lat: (map['lat'] as num).toDouble(),
        lng: (map['lng'] as num).toDouble(),
        title: map['title'] ?? '',
        type: map['type'] ?? 'water',
        distanceFromStartMeters:
            (map['distanceFromStartMeters'] as num).toDouble(),
      );
}

class MarathonRoute {
  final String id;
  final String name;
  final double totalDistanceKm;
  final List<List<double>> coordinates; // [[lat, lng], ...]
  final List<Waypoint> waypoints;

  MarathonRoute({
    required this.id,
    required this.name,
    required this.totalDistanceKm,
    required this.coordinates,
    required this.waypoints,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'totalDistanceKm': totalDistanceKm,
        'coordinates': coordinates,
        'waypoints': waypoints.map((w) => w.toMap()).toList(),
      };

  factory MarathonRoute.fromMap(Map<String, dynamic> map) {
    return MarathonRoute(
      id: map['id'] ?? '',
      name: map['name'] ?? 'カスタムコース',
      totalDistanceKm: (map['totalDistanceKm'] as num?)?.toDouble() ?? 5.0,
      coordinates: (map['coordinates'] as List? ?? [])
          .map((c) => (c as List).map((e) => (e as num).toDouble()).toList())
          .toList(),
      waypoints: (map['waypoints'] as List? ?? [])
          .map((w) => Waypoint.fromMap(Map<String, dynamic>.from(w)))
          .toList(),
    );
  }
}
