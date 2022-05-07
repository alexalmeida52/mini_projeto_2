//developed by José Alex

import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:mini_projeto_2/components/TarefaForm.dart';
import 'package:mini_projeto_2/components/TarefaLista.dart';
import 'package:mini_projeto_2/models/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeto_2/screens/tarefa.dart';
import 'package:mini_projeto_2/utils/app_routes.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        AppRoutes.HOME: (ctx) => MyHomePage(),
        AppRoutes.TAREFA_DETAIL: (ctx) => TarefaScreen(),
      },
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
        obs: obs);

    setState(() {
      _tarefas.add(novaTarefa);
      _applyFilter(this._priority, this._isChecked, this._dataSelecionada);
    });

    print(titulo);
  }

  _removerTarefa(index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  List<Tarefa> _tarefas = [
    Tarefa(
        id: 't0',
        titulo: 'Estudar',
        data: DateTime.now(),
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        priority: 1,
        obs: 'Nada a declarar'),
    Tarefa(
        id: 't1',
        titulo: 'Jogar',
        data: DateTime.now().add(Duration(days: 5)),
        createdAt: DateTime.now().subtract(Duration(days: 7)),
        priority: 2,
        obs: 'Preciso lembrar'),
    Tarefa(
        id: 't2',
        titulo: 'Assistir',
        data: DateTime.now().subtract(Duration(days: 5)),
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        priority: 3,
        obs: 'Spider Man'),
    Tarefa(
        id: 't3',
        titulo: 'Correr',
        data: DateTime.now().subtract(Duration(days: 21)),
        createdAt: DateTime.now(),
        priority: 1,
        obs: 'Toda manhã'),
    Tarefa(
        id: 't4',
        titulo: 'Cozinhar',
        data: DateTime.now().subtract(Duration(days: 13)),
        createdAt: DateTime.now(),
        priority: 2,
        obs: 'Manhã, tarde e noite')
  ];

  List<Tarefa> _tarefasFiltradas = [];

  initState() {
    // at the beginning, all users are shown
    _tarefasFiltradas = _tarefas;
    super.initState();
  }

  int _priority = 0;
  bool _isChecked = false;
  DateTime _dataSelecionada = DateTime.now();

  void _applyFilter(int priority, bool isChecked, DateTime dataSelecionada) {
    this._priority = priority;
    this._isChecked = isChecked;
    this._dataSelecionada = dataSelecionada;

    print('Aplicando filtros');
    List<Tarefa> ls = this
        ._tarefas
        .where((tarefa) =>
            returnItem(tarefa, priority, isChecked, dataSelecionada))
        .toList();
    setState(() {
      _tarefasFiltradas = ls;
      print(_tarefasFiltradas.length);
    });
  }

  bool returnItem(
      Tarefa tarefa, int priority, bool isChecked, DateTime _dataSelecionada) {
    if (priority == 0) {
      if (isChecked) {
        return compareDate(tarefa.data, _dataSelecionada);
      } else {
        return true;
      }
    } else {
      if (tarefa.priority == priority) {
        if (isChecked) {
          return compareDate(tarefa.data, _dataSelecionada);
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
  }

  bool compareDate(DateTime date, DateTime date2) {
    return DateFormat('d MMM y').format(date) ==
        DateFormat('d MMM y').format(date2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TarefaLista(_tarefasFiltradas, _removerTarefa, _applyFilter),
              ],
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Powered by José Alex",
                  style: GoogleFonts.adventPro(
                      fontStyle: FontStyle.italic,
                      color: Colors.black.withOpacity(0.4))),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(child: TarefaForm(_novaTarefa));
            },
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
