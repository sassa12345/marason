import 'package:flutter/material.dart';
import '../models/marathon_route.dart';

class HostRouteBuilderWidget extends StatefulWidget {
  final MarathonRoute currentRoute;
  final Function(MarathonRoute updatedRoute) onSaveRoute;

  const HostRouteBuilderWidget({
    super.key,
    required this.currentRoute,
    required this.onSaveRoute,
  });

  @override
  State<HostRouteBuilderWidget> createState() => _HostRouteBuilderWidgetState();
}

class _HostRouteBuilderWidgetState extends State<HostRouteBuilderWidget> {
  late TextEditingController _nameController;
  late List<Waypoint> _waypoints;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentRoute.name);
    _waypoints = List<Waypoint>.from(widget.currentRoute.waypoints);
  }

  void _addWaypoint() {
    setState(() {
      _waypoints.add(
        Waypoint(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          lat: 35.6812,
          lng: 139.7671,
          title: "給水所 #${_waypoints.length + 1}",
          type: "water",
          distanceFromStartMeters: (_waypoints.length + 1) * 2500.0,
        ),
      );
    });
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text("ホスト専用: コース編集 & ポイント設置"),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent),
            onPressed: () {
              final newRoute = MarathonRoute(
                id: widget.currentRoute.id,
                name: _nameController.text,
                totalDistanceKm: widget.currentRoute.totalDistanceKm,
                coordinates: widget.currentRoute.coordinates,
                waypoints: _waypoints,
              );
              widget.onSaveRoute(newRoute);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossCrossAxisAlignment: CrossAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "コース名",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "チェックポイント / 給水所一覧",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addWaypoint,
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text("追加"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.shade700,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _waypoints.length,
                itemBuilder: (context, index) {
                  final wp = _waypoints[index];
                  return Card(
                    color: Colors.black54,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: wp.type == 'water'
                            ? Colors.blue
                            : wp.type == 'start'
                                ? Colors.green
                                : Colors.amber,
                        child: Icon(
                          wp.type == 'water'
                              ? Icons.local_drink
                              : wp.type == 'start'
                                  ? Icons.flag
                                  : Icons.location_on,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        wp.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "スタートから ${(wp.distanceFromStartMeters / 1000).toStringAsFixed(1)}km 地点",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeWaypoint(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
