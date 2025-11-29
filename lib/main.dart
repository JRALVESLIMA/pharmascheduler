import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/agendamentos_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/novo_agendamento_screen.dart';
import 'screens/calendario_screen.dart';
import 'services/notification_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const PharmaSchedulerApp());
}


class PharmaSchedulerApp extends StatelessWidget {
  const PharmaSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaScheduler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          primary: const Color(0xFF1976D2),
          secondary: const Color(0xFF64B5F6),
        ),
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/agendamentos': (context) => const AgendamentosScreen(),
        '/calendario': (context) => const CalendarioScreen(),
        '/configuracoes': (context) => const Placeholder(),
        '/novoAgendamento': (context) => const NovoAgendamentoScreen(),
      },
    );
  }
}