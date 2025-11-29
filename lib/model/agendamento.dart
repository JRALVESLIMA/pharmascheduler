class Agendamento {
  final int? id;
  final String titulo;
  final String descricao;
  final DateTime dataHora;
  final String tipo;
  final String? local;

  Agendamento({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataHora,
    required this.tipo,
    this.local,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': dataHora.toIso8601String(),
      'tipo': tipo,
      'local': local,
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['data']),
      tipo: map['tipo'],
      local: map['local'],
    );
  }
}