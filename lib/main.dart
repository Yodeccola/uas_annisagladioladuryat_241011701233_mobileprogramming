import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';
import 'screen/login_screen.dart';

void main() async {
  // Wajib ditambahkan agar inisialisasi Firebase berjalan lancar sebelum app tampil
  WidgetsFlutterBinding.ensureInitialized();
  
  // Proses menyalakan Firebase menggunakan data yang kamu simpan tadi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS Mobile Programming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}