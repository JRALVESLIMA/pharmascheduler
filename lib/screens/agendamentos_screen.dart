import 'package:flutter/material.dart';
import 'detalhes_agendamento_screen.dart';
import '../services/database_service.dart';
import '../model/agendamento.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  late Future<List<Agendamento>> _futureAgendamentos;

  @override
  void initState() {
    super.initState();
    _refreshAgendamentos();
  }

  ///Recarrega os agendamentos do banco
  void _refreshAgendamentos() {
    setState(() {
      _futureAgendamentos = DatabaseService.getAgendamentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamentos"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Agendamento>>(
        future: _futureAgendamentos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final agendamentos = snapshot.data ?? [];
          if (agendamentos.isEmpty) {
            return const Center(child: Text("Nenhum agendamento encontrado"));
          }

          return ListView.builder(
            itemCount: agendamentos.length,
            itemBuilder: (context, index) {
              final agendamento = agendamentos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event_note, color: Colors.blue),
                  title: Text(
                    "${agendamento.titulo} - "
                        "${agendamento.dataHora.hour.toString().padLeft(2, '0')}:"
                        "${agendamento.dataHora.minute.toString().padLeft(2, '0')}",
                  ),
                  subtitle: Text(
                    "${agendamento.dataHora.day}/${agendamento.dataHora.month}/${agendamento.dataHora.year}"
                        " • ${agendamento.local ?? '-'}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () async {
                      final atualizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalhesAgendamentoScreen(agendamento: agendamento),
                        ),
                      );
                      if (atualizado == true) {
                        _refreshAgendamentos();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final criado = await Navigator.pushNamed(context, '/novoAgendamento');
          if (criado == true) {
            _refreshAgendamentos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}