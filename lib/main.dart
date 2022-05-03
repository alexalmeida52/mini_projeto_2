//developed by Jean Lima

import 'dart:math';

import 'package:mini_projeto_2/components/TarefaForm.dart';
import 'package:mini_projeto_2/components/TarefaLista.dart';
import 'package:mini_projeto_2/models/tarefa.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData().copyWith(
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: Colors.purple, secondary: Colors.amber),
          textTheme: ThemeData().textTheme.copyWith(
              headline6: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _novaTarefa(String titulo, DateTime data, int priority, String obs) {
    Tarefa novaTarefa = Tarefa(
        id: Random().nextInt(9999).toString(), 
        titulo: titulo, 
        data: data, 
        createdAt: DateTime.now(), 
        priority: priority,
        obs: obs
      );

    setState(() {
      _tarefas.add(novaTarefa);
    });

    print(titulo);
  }

  _removerTarefa(index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  List<Tarefa> _tarefas = [
    Tarefa(id: 't0', titulo: 'Estudar', data: DateTime.now(), createdAt: DateTime.now().subtract(Duration(days: 15)), priority: 1, obs: 'Nada a declarar'),
    Tarefa(id: 't1', titulo: 'Jogar', data: DateTime.now().add(Duration(days: 5)), createdAt: DateTime.now().subtract(Duration(days: 7)), priority: 2, obs: 'Preciso lembrar'),
    Tarefa(id: 't2', titulo: 'Assistir', data: DateTime.now().subtract(Duration(days: 5)), createdAt: DateTime.now(), priority: 3, obs: 'Spider Man'),
    Tarefa(id: 't3', titulo: 'Correr', data: DateTime.now().subtract(Duration(days: 21)), createdAt: DateTime.now(), priority: 1, obs: 'Toda manhã'),
    Tarefa(id: 't4', titulo: 'Cozinhar', data: DateTime.now().subtract(Duration(days: 13)), createdAt: DateTime.now(), priority: 2, obs: 'Manhã, tarde e noite')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TarefaForm(_novaTarefa),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  TarefaLista(_tarefas, _removerTarefa),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
