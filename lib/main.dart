import 'package:flutter/material.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://tmxvrsprlocndjmlhuld.supabase.co',
    anonKey: '<prefer publishable key instead of anon key for mobile and desktop apps>',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ,
    );
  }
}

