import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/calm_flight_screen.dart';

class VestibularCalmApp extends StatelessWidget {
  const VestibularCalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const CalmFlightScreen(),
    );
  }
}
