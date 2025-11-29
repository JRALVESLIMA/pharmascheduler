import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PharmaScheduler"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(
              context,
              icon: Icons.list_alt,
              label: "Agendamentos",
              onTap: () {
                Navigator.pushNamed(context, '/agendamentos');
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.calendar_month,
              label: "Calendário",
              onTap: () {
                Navigator.pushNamed(context, '/calendario');
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.settings,
              label: "Configurações",
              onTap: () {
                Navigator.pushNamed(context, '/configuracoes');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onTap,
    );
  }
}