import 'package:flutter/material.dart';
import 'package:registration/core/constants/app_strings.dart';
import 'package:registration/presentation/screens/onbording/start_page.dart';
import 'package:registration/presentation/screens/Bottom%20App%20Bar/Batton_aoo_bar.dart';

class AppRouter {


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Start:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case BottomNav:
        return MaterialPageRoute(builder: (_) => const ModernBottomNav());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}
