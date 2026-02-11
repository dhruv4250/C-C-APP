import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: CarbonWalletApp()));
}

class CarbonWalletApp extends StatelessWidget {
  const CarbonWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F5), // Soft Mint Grey
        primaryColor: const Color(0xFF00D09C), // Bright Eco Green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D09C),
          primary: const Color(0xFF00D09C),
          secondary: const Color(0xFF1E3A34), // Dark Forest Green
        ),
        textTheme: GoogleFonts.poppinsTextTheme(), // The font from your reference
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}