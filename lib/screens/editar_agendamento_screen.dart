import 'package:flutter/material.dart';
import '../model/agendamento.dart';
import '../services/database_service.dart';

class EditarAgendamentoScreen extends StatefulWidget {
  final Agendamento agendamento;

  const EditarAgendamentoScreen({super.key, required this.agendamento});

  @override
  State<EditarAgendamentoScreen> createState() => _EditarAgendamentoScreenState();
}

class _EditarAgendamentoScreenState extends State<EditarAgendamentoScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _localController;
  late DateTime _dataHora;
  late String _tipo;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.agendamento.titulo);
    _descricaoController = TextEditingController(text: widget.agendamento.descricao);
    _localController = TextEditingController(text: widget.agendamento.local ?? '');
    _dataHora = widget.agendamento.dataHora;


    const tiposValidos = ["reuniao", "visita", "apresentacao", "outro"];
    _tipo = tiposValidos.contains(widget.agendamento.tipo)
        ? widget.agendamento.tipo
        : "outro";
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _localController.dispose();
    super.dispose();
  }

  Future<void> _salvarAgendamento() async {
    if (widget.agendamento.id != null) {
      await DatabaseService.updateAgendamento(
        id: widget.agendamento.id!,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        data: _dataHora,
        tipo: _tipo,
        local: _localController.text,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Agendamento atualizado com sucesso!")),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Agendamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            TextField(
              controller: _localController,
              decoration: const InputDecoration(labelText: "Local"),
            ),
            const SizedBox(height: 16),


            Row(
              children: [
                Expanded(
                  child: Text(
                    "Data: ${_dataHora.day}/${_dataHora.month}/${_dataHora.year}",
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final novaData = await showDatePicker(
                      context: context,
                      initialDate: _dataHora,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (novaData != null) {
                      setState(() {
                        _dataHora = DateTime(
                          novaData.year,
                          novaData.month,
                          novaData.day,
                          _dataHora.hour,
                          _dataHora.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),

            // Campo de Hora
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Hora: ${_dataHora.hour.toString().padLeft(2, '0')}:${_dataHora.minute.toString().padLeft(2, '0')}",
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final novaHora = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dataHora),
                    );
                    if (novaHora != null) {
                      setState(() {
                        _dataHora = DateTime(
                          _dataHora.year,
                          _dataHora.month,
                          _dataHora.day,
                          novaHora.hour,
                          novaHora.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _tipo,
              items: const [
                DropdownMenuItem(value: "reuniao", child: Text("Reunião")),
                DropdownMenuItem(value: "visita", child: Text("Visita")),
                DropdownMenuItem(value: "apresentacao", child: Text("Apresentação")),
                DropdownMenuItem(value: "outro", child: Text("Outro")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _tipo = value);
                }
              },
              decoration: const InputDecoration(labelText: "Tipo"),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Salvar"),
              onPressed: _salvarAgendamento,
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Cancelar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),

          ],
        ),
      ),
    );
  }
}