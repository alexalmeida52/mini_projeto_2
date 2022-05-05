import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarefa.dart';

class TarefaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Tarefa tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa;

    return Scaffold(
      appBar: AppBar(title: Text("Tarefa")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          color: Colors.purple,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Título: ${tarefa.titulo}", style: TextStyle(color: Colors.white, fontSize: 30)),
                Text("Data: ${DateFormat('dd/MM/y').format(tarefa.data)}", style: TextStyle(color: Colors.white, fontSize: 30)),
                Text("Obs.: ${tarefa.obs}", style: TextStyle(color: Colors.white, fontSize: 30)),
                Text(
                    "Criado em: ${DateFormat('dd/MM/y').format(tarefa.createdAt)}"
                    , style: TextStyle(color: Colors.white, fontSize: 30))
              ]),
        ),
      ),
    );
  }
}
