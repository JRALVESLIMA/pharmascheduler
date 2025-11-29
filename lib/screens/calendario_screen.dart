import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/database_service.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> eventos = {};

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  ///Carrega eventos do banco de dados
  Future<void> _loadEventos() async {
    final data = await DatabaseService.getAgendamentos();
    setState(() {
      eventos.clear();
      for (var item in data) {
        final date = item.dataHora;
        final key = DateTime.utc(date.year, date.month, date.day);

        eventos.putIfAbsent(key, () => []);
        eventos[key]!.add({
          "id": item.id,
          "titulo": item.titulo,
          "descricao": item.descricao,
          "tipo": item.tipo,
          "data": item.dataHora.toIso8601String(),
          "local": item.local,
        });
      }
    });
  }


  ///Retorna eventos do dia selecionado
  List<Map<String, dynamic>> _getEventosDoDia(DateTime day) {
    return eventos[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  ///Ícone por tipo
  Icon _getIconPorTipo(String tipo) {
    switch (tipo) {
      case "visita":
        return const Icon(Icons.local_pharmacy, color: Colors.green);
      case "apresentacao":
        return const Icon(Icons.medical_services, color: Colors.redAccent);
      default:
        return const Icon(Icons.event, color: Colors.blueGrey);
    }
  }

  ///Cor por tipo
  Color _getCorPorTipo(String tipo) {
    switch (tipo) {
      case "farmacia":
        return Colors.green.shade100;
      case "drogaria":
        return Colors.red.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  ///Excluir agendamento
  Future<void> _deleteAgendamento(int id) async {
    await DatabaseService.deleteAgendamento(id);
    await _loadEventos();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Agendamento excluído")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventosDoDia = _getEventosDoDia(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendário de Agendamentos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              await _loadEventos();
            },
            eventLoader: (day) =>
                _getEventosDoDia(day).map((e) => e["titulo"] as String).toList(),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: eventosDoDia.map((evento) {
                return Card(
                  color: _getCorPorTipo(evento["tipo"]),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: _getIconPorTipo(evento["tipo"]),
                    title: Text("${evento["titulo"]} - ${evento["descricao"]}"),
                    subtitle: Text(
                        "Data: ${DateTime.parse(evento["data"]).day}/${DateTime.parse(evento["data"]).month}/${DateTime.parse(evento["data"]).year}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAgendamento(evento["id"]),
                    ),
                    onTap: () {

                      Navigator.pushNamed(
                        context,
                        '/novoAgendamento',
                        arguments: evento,
                      ).then((value) {
                        if (value == true) _loadEventos();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}