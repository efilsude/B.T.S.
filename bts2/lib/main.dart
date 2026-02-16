import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/report_provider.dart';
import 'screens/home_screen.dart';

/// Trafo Bakım Raporlama Uygulaması
/// Ana giriş noktası
void main() {
  runApp(const TrafoRaporApp());
}

/// Uygulama Widget'ı
class TrafoRaporApp extends StatelessWidget {
  const TrafoRaporApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: MaterialApp(
        title: 'Trafo Bakım Raporu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Kurumsal mavi renk teması
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.blueGrey[800],
          scaffoldBackgroundColor: Colors.grey[100],
          
          // AppBar teması
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey[800],
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Buton teması
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Input teması
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueGrey[800]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            labelStyle: TextStyle(color: Colors.grey[600]),
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          
          // Card teması
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
          ),
          
          // FloatingActionButton teması
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blueGrey[800],
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
