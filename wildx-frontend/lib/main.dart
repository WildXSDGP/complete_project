import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/accommodation/screens/accommodation_screen.dart';
import 'features/accommodation/screens/accommodation_detail_screen.dart';
import 'features/accommodation/screens/booking_screen.dart';
import 'features/accommodation/screens/booking_confirmation_screen.dart';
import 'features/accommodation/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const WildXApp());
}

const _green        = Color(0xFF2E7D32);
const _greenDark    = Color(0xFF1B5E20);
const _greenLight   = Color(0xFF4CAF50);
const _greenSurface = Color(0xFFE8F5E9);

class WildXApp extends StatelessWidget {
  const WildXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WildX',
      debugShowCheckedModeBanner: false,
      // ── Global Green Theme ───────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _green,
          primary: _green,
          secondary: _greenLight,
          surface: Colors.white,
          background: const Color(0xFFF3F4F6),
        ),
        primaryColor: _green,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 19,
            fontWeight: FontWeight.w700, letterSpacing: -0.3,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _green, foregroundColor: Colors.white,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: _greenSurface,
          selectedColor: _green,
          labelStyle: TextStyle(fontSize: 12),
          side: BorderSide.none,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: _green),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: _green,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: _green, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: _green),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? _green : null),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? _greenLight.withOpacity(0.5) : null),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        AppRoutes.accommodations:      (_) => const AccommodationScreen(),
        AppRoutes.accommodationDetail: (_) => const AccommodationDetailScreen(),
        AppRoutes.booking:             (_) => const BookingScreen(),
        AppRoutes.bookingConfirmation: (_) => const BookingConfirmationScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
        return null;
      },
    );
  }
}
