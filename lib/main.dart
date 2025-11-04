import 'package:brisa_supply_chain/features/auth/domain/usecases/auth_wrapper.dart';
import 'package:brisa_supply_chain/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:developer'; // <-- Impor ini untuk 'log'

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// --- PERUBAHAN DIMULAI DI SINI ---

// 1. Ubah MyApp dari StatelessWidget menjadi StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// 2. Buat class State-nya (di sinilah 'initState' tinggal)
class _MyAppState extends State<MyApp> {
  // final AuthService _authService = AuthService(); // <-- Bisa dipindah ke sini

  // INI YANG KAMU CARI
  @override
  void initState() {
    super.initState();

    // Taruh kode inisialisasi kamu di sini.
    // Kode ini cuma jalan SEKALI pas widget ini pertama kali dibuat.
    log('✅ MyApp initState() berhasil dipanggil!');

    // Contoh:
    // _authService.setupListener();
    // Inisialisasi controller, dll.
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller atau listener di sini
    super.dispose();
  }

  // 3. Pindahkan method 'build' kamu ke dalam class State ini
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthWrapper(),
    );
  }
}
