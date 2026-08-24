import 'package:flutter/material.dart';
import 'screens/marathon_main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PaceSyncMarathonApp());
}

class PaceSyncMarathonApp extends StatelessWidget {
  const PaceSyncMarathonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaceSync Marathon GPS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        useMaterial3: true,
      ),
      home: const MarathonMainScreen(),
    );
  }
}
