import 'package:mini_projeto_2/models/tarefa.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../utils/app_routes.dart';

class TarefaLista extends StatefulWidget {
  List<Tarefa> _tarefaLista;
  void Function(int) onSubmit;
  void Function(int, bool, DateTime) _applyFilters;

  TarefaLista(this._tarefaLista, this.onSubmit, this._applyFilters);

  @override
  State<TarefaLista> createState() => _TarefaListaState();
}

class _TarefaListaState extends State<TarefaLista> {

  void _selectedTarefa(BuildContext context, Tarefa tarefa) {
    /*
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CountryPlacesScreen(country);
    }));
    */
    Navigator.of(context).pushNamed(
      AppRoutes.TAREFA_DETAIL,
      arguments: tarefa
    );
  }

  static const Map<String, int> itens = {
    "Todas": 0,
    "Baixa": 1,
    "Normal": 2,
    "Alta": 3,
  };

  int _itemValue = 0;
  DateTime _dataSelecionada = DateTime.now();
  bool isChecked = false;

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2023))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dataSelecionada = pickedDate;
      });

      widget._applyFilters(_itemValue, isChecked, _dataSelecionada);
    });
  }

  Color getColorCheckbox(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.purple;
    }
    return Colors.purple;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColorCheckbox),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          widget._applyFilters(_itemValue, isChecked, _dataSelecionada);
                        });
                      },
                    ),
                    Text(
                        'Filtrar data ${DateFormat('dd/MM/y').format(_dataSelecionada)}'),
                    TextButton(
                        onPressed: _showDatePicker,
                        child: Text('Selecionar data')),
                  ],
                ),
                Row(
                  children: [
                    Text('Prioridade: '),
                    DropdownButton<int>(
                      icon: Icon(Icons.arrow_drop_down,
                          color: getColor(_itemValue)),
                      elevation: 16,
                      style: TextStyle(color: getColor(_itemValue)),
                      underline: Container(
                        height: 2,
                        color: getColor(_itemValue),
                      ),
                      items: itens
                          .map((description, value) {
                            return MapEntry(
                                description,
                                DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(description),
                                ));
                          })
                          .values
                          .toList(),
                      value: _itemValue,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _itemValue = newValue;
                            widget._applyFilters(_itemValue, isChecked, _dataSelecionada);
                          });
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        Container(
          child: widget._tarefaLista.isEmpty
              ? Text('Nenhuma tarefa cadastrada')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget._tarefaLista.length,
                  itemBuilder: (context, index) {
                    final tarefa = widget._tarefaLista[index];
                    return InkWell(
                      onTap: () => {
                        _selectedTarefa(context, tarefa)
                      },
                      child: Card(
                        child: Stack(children: [
                          Row(
                            children: [
                              Stack(children: [
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: 
                                          DateTime.now().isBefore(tarefa.data)
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : isSameDay(tarefa.data)
                                                  ? Colors.orange
                                                  : Colors.red),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        DateFormat('d MMM y').format(tarefa.data),
                                        style: TextStyle(
                                            color: DateTime.now()
                                                    .isBefore(tarefa.data)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : isSameDay(tarefa.data)
                                                    ? Colors.orange
                                                    : Colors.red))),
                                Container(
                                    color: tarefa.priority == 1
                                        ? Colors.green
                                        : tarefa.priority == 2
                                            ? Colors.blue
                                            : Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        Tarefa.getPriorityLabel(tarefa.priority),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ]),
                              Text(tarefa.titulo),
                            ],
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(tarefa.createdAt),
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withOpacity(0.5)))),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    widget.onSubmit(index);
                                  },
                                ),
                              ))
                        ]),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime date) {
    return DateFormat('d MMM y').format(DateTime.now()) ==
        DateFormat('d MMM y').format(date);
  }

  Color getColor(int priority) {
    Color color;
    if (priority == 1) {
      color = Colors.green;
    } else if (priority == 2) {
      color = Colors.blue;
    } else if (priority == 3) {
      color = Colors.red;
    } else {
      color = Colors.purple;
    }

    return color;
  }
}
