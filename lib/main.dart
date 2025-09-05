import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/event_cubit.dart';
import 'package:registration/Logic/cubit/internet_cubit.dart';
import 'package:registration/Logic/cubit/qr_scan_cubit.dart';
import 'package:registration/core/constants/app_strings.dart';
import 'package:registration/core/route/app_router.dart';
import 'package:registration/data/repositories/attendee_repository.dart';
import 'package:registration/data/repositories/event_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tmxvrsprlocndjmlhuld.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRteHZyc3BybG9jbmRqbWxodWxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3NTg4MjEsImV4cCI6MjA3MjMzNDgyMX0.P27BVnFsf3VRJdmMadQDi0uLJc3Bwewxzdo9j7KeI2k',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final branchMembersRepository = AuthRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BranchMembersCubit(branchMembersRepository),
        ),
        BlocProvider(create: (_) => InternetCubit()),
        BlocProvider(create: (_) => QrScanCubit(branchMembersRepository)),
        BlocProvider(create: (_) => EventCubit(EventRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Start,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
