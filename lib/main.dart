import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const SaurioNavidadApp());
}

class SaurioNavidadApp extends StatelessWidget {
  const SaurioNavidadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaurioNavidad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCFB46D),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
