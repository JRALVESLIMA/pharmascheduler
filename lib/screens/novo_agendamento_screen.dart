import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/database_service.dart';

class NovoAgendamentoScreen extends StatefulWidget {
  const NovoAgendamentoScreen({super.key});

  @override
  State<NovoAgendamentoScreen> createState() => _NovoAgendamentoScreenState();
}

class _NovoAgendamentoScreenState extends State<NovoAgendamentoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController clienteController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String _tipoSelecionado = "reuniao";
  int? agendamentoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      agendamentoId = args["id"];
      clienteController.text = args["titulo"] ?? "";
      localController.text = args["local"] ?? "";
      descricaoController.text = args["descricao"] ?? "";
      _tipoSelecionado = args["tipo"] ?? "reuniao";

      final data = DateTime.parse(args["data"]);
      _dataSelecionada = data;
      _horaSelecionada = TimeOfDay(hour: data.hour, minute: data.minute);
    }
  }

  Future<void> _salvarAgendamento() async {
    if (_formKey.currentState!.validate() &&
        _dataSelecionada != null &&
        _horaSelecionada != null) {
      final dataHoraAgendamento = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );

      if (agendamentoId == null) {
        await DatabaseService.addAgendamento(
          titulo: clienteController.text,
          descricao: descricaoController.text,
          data: dataHoraAgendamento,
          tipo: _tipoSelecionado,
          local: localController.text,
        );
      } else {
        await DatabaseService.updateAgendamento(
          id: agendamentoId!,
          titulo: clienteController.text,
          descricao: descricaoController.text,
          data: dataHoraAgendamento,
          tipo: _tipoSelecionado,
        );
      }

      try {
        await NotificationService.scheduleNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "Agendamento: ${clienteController.text}",
          body:
          "Local: ${localController.text} às ${_horaSelecionada!.format(context)}",
          scheduledDate: dataHoraAgendamento,
        );

        await NotificationService.scheduleReminder(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 1,
          title: "Agendamento: ${clienteController.text}",
          body:
          "Local: ${localController.text} às ${_horaSelecionada!.format(context)}",
          scheduledDate: dataHoraAgendamento,
        );
      } catch (e) {
        debugPrint("Erro ao agendar notificação: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Agendamento salvo, mas houve erro ao configurar notificações."),
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(agendamentoId == null
              ? "Agendamento salvo!"
              : "Agendamento atualizado!"),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(agendamentoId == null ? "Novo Agendamento" : "Editar Agendamento"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: clienteController,
                decoration: const InputDecoration(
                  labelText: "Cliente",
                  icon: Icon(Icons.person),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Informe o cliente" : null,
              ),
              TextFormField(
                controller: localController,
                decoration: const InputDecoration(
                  labelText: "Local",
                  icon: Icon(Icons.location_on),
                ),
              ),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  icon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(_dataSelecionada == null
                    ? "Selecione a data"
                    : "Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dataSelecionada ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => _dataSelecionada = picked);
                  }
                },
              ),
              ListTile(
                title: Text(_horaSelecionada == null
                    ? "Selecione a hora"
                    : "Hora: ${_horaSelecionada!.hour.toString().padLeft(2, '0')}:${_horaSelecionada!.minute.toString().padLeft(2, '0')}"),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _horaSelecionada ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => _horaSelecionada = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                items: const [
                  DropdownMenuItem(value: "reuniao", child: Text("Reunião")),
                  DropdownMenuItem(value: "visita", child: Text("Visita")),
                  DropdownMenuItem(value: "apresentacao", child: Text("Apresentação")),
                  DropdownMenuItem(value: "outro", child: Text("Outro")),
                ],
                onChanged: (value) => setState(() => _tipoSelecionado = value!),
                decoration: const InputDecoration(
                  labelText: "Tipo de Agendamento",
                  icon: Icon(Icons.category),
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(agendamentoId == null ? "Salvar" : "Atualizar"),
                onPressed: _salvarAgendamento,
              ),
            ],
          ),
        ),
      ),
    );
  }
}