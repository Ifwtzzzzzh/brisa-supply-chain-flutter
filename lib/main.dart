import 'package:brisa_supply_chain/features/auth/domain/usecases/auth_wrapper.dart';
import 'package:brisa_supply_chain/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:brisa_supply_chain/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final AuthService _authService = AuthService();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // TESTING QUESTION SCREEN
      home: const AuthWrapper(),
    );
  }
}
