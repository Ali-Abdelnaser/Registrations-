import 'package:flutter/material.dart';
import 'package:registration/core/constants/app_strings.dart';
import 'package:registration/core/route/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tmxvrsprlocndjmlhuld.supabase.co',
    anonKey:
        '<prefer publishable key instead of anon key for mobile and desktop apps>',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Start,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
