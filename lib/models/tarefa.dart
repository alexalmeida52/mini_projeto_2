class Tarefa {
  String id;
  String titulo;
  DateTime data;
  DateTime createdAt;
  int priority;
  String obs;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.data,
    required this.createdAt,
    required this.priority,
    required this.obs
  });

  static String getPriorityLabel(int priority) {
    return priority == 1
        ? 'Baixa'
        : priority == 2
            ? 'Normal'
            : priority == 3 ? 'Alta' : '';
  }
}
