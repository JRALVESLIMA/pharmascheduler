import 'package:flutter/material.dart';
import '../model/agendamento.dart';
import '../services/database_service.dart';
import 'editar_agendamento_screen.dart';

class DetalhesAgendamentoScreen extends StatelessWidget {
  final Agendamento agendamento;

  const DetalhesAgendamentoScreen({super.key, required this.agendamento});

  String _formatarTipo(String tipo) {
    switch (tipo) {
      case "reuniao":
        return "Reunião";
      case "visita":
        return "Visita";
      case "apresentacao":
        return "Apresentação";
      case "outro":
        return "Outro";
      default:
        return "Outro";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Agendamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cliente: ${agendamento.titulo}",
                    style: const TextStyle(fontSize: 16)),
                Text("Local: ${agendamento.local ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                Text(
                  "Data: ${agendamento.dataHora.day}/${agendamento.dataHora.month}/${agendamento.dataHora.year}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Hora: ${agendamento.dataHora.hour.toString().padLeft(2, '0')}:${agendamento.dataHora.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text("Tipo: ${_formatarTipo(agendamento.tipo)}",
                    style: const TextStyle(fontSize: 16)),
                Text("Descrição: ${agendamento.descricao}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Editar"),
                      onPressed: () async {
                        final atualizado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditarAgendamentoScreen(agendamento: agendamento),
                          ),
                        );
                        if (atualizado == true) {
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("Excluir"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        if (agendamento.id != null) {
                          await DatabaseService.deleteAgendamento(agendamento.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Agendamento excluído!")),
                          );
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}