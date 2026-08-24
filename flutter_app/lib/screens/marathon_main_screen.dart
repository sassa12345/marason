import 'dart:async';
import 'package:flutter/material.dart';
import '../models/runner_state.dart';
import '../models/marathon_route.dart';
import '../models/cheer_message.dart';
import '../services/background_gps_service.dart';
import '../services/route_navigation_service.dart';
import '../services/audio_tts_service.dart';
import '../widgets/runner_hud_widget.dart';
import '../widgets/leaderboard_widget.dart';
import '../widgets/host_route_builder_widget.dart';
import '../widgets/cheer_overlay_widget.dart';

class MarathonMainScreen extends StatefulWidget {
  const MarathonMainScreen({super.key});

  @override
  State<MarathonMainScreen> createState() => _MarathonMainScreenState();
}

class _MarathonMainScreenState extends State<MarathonMainScreen> {
  final AudioTtsService _ttsService = AudioTtsService();
  final BackgroundGpsService _gpsService = BackgroundGpsService();

  late RunnerState _me;
  late MarathonRoute _route;
  List<RunnerState> _allRunners = [];
  CheerMessage? _activeCheer;
  Timer? _simulationTimer;

  bool _isLeaderboardOpen = false;

  @override
  void initState() {
    super.initState();
    _initDemoData();
    _startRunnerSimulation();
  }

  void _initDemoData() {
    _me = RunnerState(
      id: "runner_me",
      name: "あなた (ランナー)",
      avatar: "🏃‍♂️",
      isHost: true,
      lat: 35.6812,
      lng: 139.7671,
      speedKmH: 10.5,
      distanceMeters: 4200,
      accuracyMeters: 3.5,
      batteryPercent: 88,
      isOffCourse: false,
      distToCourseMeters: 4.2,
      lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _route = MarathonRoute(
      id: "tokyo_5k",
      name: "皇居周回 5km スペシャルコース",
      totalDistanceKm: 5.0,
      coordinates: [
        [35.6812, 139.7671],
        [35.6825, 139.7685],
        [35.6840, 139.7690],
        [35.6860, 139.7680],
        [35.6880, 139.7650],
      ],
      waypoints: [
        Waypoint(
          id: "wp1",
          lat: 35.6812,
          lng: 139.7671,
          title: "スタート地点 (大手町)",
          type: "start",
          distanceFromStartMeters: 0,
        ),
        Waypoint(
          id: "wp2",
          lat: 35.6840,
          lng: 139.7690,
          title: "第1給水所 (竹橋)",
          type: "water",
          distanceFromStartMeters: 2200,
        ),
      ],
    );

    _allRunners = [
      _me,
      RunnerState(
        id: "runner_2",
        name: "サトシ",
        avatar: "⚡",
        isHost: false,
        lat: 35.6820,
        lng: 139.7680,
        speedKmH: 11.2,
        distanceMeters: 4650,
        accuracyMeters: 4.0,
        batteryPercent: 72,
        isOffCourse: false,
        distToCourseMeters: 2.1,
        lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      RunnerState(
        id: "runner_3",
        name: "ケンジ",
        avatar: "🚴",
        isHost: false,
        lat: 35.6800,
        lng: 139.7660,
        speedKmH: 9.8,
        distanceMeters: 3800,
        accuracyMeters: 5.0,
        batteryPercent: 91,
        isOffCourse: true,
        distToCourseMeters: 42.0,
        lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
  }

  void _startRunnerSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        // ランナー位置の疑似前進
        final newDist = _me.distanceMeters + 8.5;
        final newLat = _me.lat + 0.00008;
        final newLng = _me.lng + 0.00006;

        final navEval = RouteNavigationService.evaluatePosition(
          currentLat: newLat,
          currentLng: newLng,
          route: _route,
        );

        _me = RunnerState(
          id: _me.id,
          name: _me.name,
          avatar: _me.avatar,
          isHost: _me.isHost,
          lat: newLat,
          lng: newLng,
          speedKmH: 10.8,
          distanceMeters: newDist,
          accuracyMeters: 3.0,
          batteryPercent: _me.batteryPercent > 10 ? _me.batteryPercent - 1 : 100,
          isOffCourse: navEval.isOffCourse,
          distToCourseMeters: navEval.distanceToCourseMeters,
          lastUpdatedTimestamp: DateTime.now().millisecondsSinceEpoch,
        );

        // ランナー更新
        _allRunners[0] = _me;

        if (navEval.isOffCourse) {
          _ttsService.speakText("注意！コースから脱線しています！");
        }
      });
    });
  }

  void _sendCheerDemo() {
    final cheer = CheerMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: "サポーター田中",
      targetRunnerId: _me.id,
      messageText: "ラストスパート！自己ベスト更新狙おう！🔥",
      audioEffect: "cheer",
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _activeCheer = cheer;
    });

    _ttsService.playCheerWithAudio(
      senderName: cheer.senderName,
      messageText: cheer.messageText,
      audioEffect: cheer.audioEffect,
    );
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _gpsService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navEval = RouteNavigationService.evaluatePosition(
      currentLat: _me.lat,
      currentLng: _me.lng,
      route: _route,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade950,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(Icons.directions_run, color: Colors.cyanAccent),
            const SizedBox(width: 8),
            Text(_route.name, style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _ttsService.isMuted ? Icons.volume_off : Icons.volume_up,
              color: _ttsService.isMuted ? Colors.red : Colors.greenAccent,
            ),
            onPressed: () {
              setState(() {
                _ttsService.toggleMute();
              });
            },
          ),
          if (_me.isHost)
            IconButton(
              icon: const Icon(Icons.edit_road, color: Colors.amberAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HostRouteBuilderWidget(
                      currentRoute: _route,
                      onSaveRoute: (updatedRoute) {
                        setState(() {
                          _route = updatedRoute;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // 地図ビューエリア (プレースホルダー / 実機環境ではGoogleMapsWidget)
          Positioned.fill(
            child: Container(
              color: Colors.blueGrey.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.cyanAccent.shade700),
                  const SizedBox(height: 12),
                  Text(
                    "高精度リアルタイムGPSマップ稼働中 (${_allRunners.length}名)",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "現在座標: Lat ${_me.lat.toStringAsFixed(4)}, Lng ${_me.lng.toStringAsFixed(4)}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // 応援エフェクトオーバーレイ
          CheerOverlayWidget(
            latestCheer: _activeCheer,
            onDismiss: () {
              setState(() {
                _activeCheer = null;
              });
            },
          ),

          // トップステータスHUD
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: RunnerHudWidget(
              me: _me,
              isOffCourse: navEval.isOffCourse,
              navInstruction: navEval.nextInstructionText,
            ),
          ),

          // 下部アクション & 順位表ドロワー
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                if (_isLeaderboardOpen)
                  SizedBox(
                    height: 240,
                    child: LeaderboardWidget(
                      runners: _allRunners,
                      currentRunnerId: _me.id,
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isLeaderboardOpen = !_isLeaderboardOpen;
                          });
                        },
                        icon: Icon(_isLeaderboardOpen
                            ? Icons.keyboard_arrow_down
                            : Icons.leaderboard),
                        label: Text(_isLeaderboardOpen ? "閉じる" : "順位表を見る"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _sendCheerDemo,
                      icon: const Icon(Icons.campaign),
                      label: const Text("応援テスト"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
