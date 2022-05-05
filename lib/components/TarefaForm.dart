import 'package:mini_projeto_2/models/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TarefaForm extends StatefulWidget {
  void Function(String, DateTime, int, String) onSubmit;

  TarefaForm(this.onSubmit);

  @override
  State<TarefaForm> createState() => _TarefaFormState();
}

class _TarefaFormState extends State<TarefaForm> {
  int priority = 2;
  final _tarefaController = TextEditingController();
  final _obsController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();

  _submitForm() {
    final titulo = _tarefaController.text;
    final obs = _obsController.text;

    if (titulo.isEmpty || priority < 1 || priority > 3) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salvo com sucesso!')),
    );
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    widget.onSubmit(titulo, _dataSelecionada, priority, obs);
    Navigator.pop(context);
  }

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2023))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dataSelecionada = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        controller: _tarefaController,
        decoration: InputDecoration(labelText: 'Tarefa'),
      ),
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                  'Data selecionada ${DateFormat('dd/MM/y').format(_dataSelecionada)}'),
            ),
            TextButton(
                onPressed: _showDatePicker, child: Text('Selecionar data'))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: Container(
          child: Text('Prioridade: ' + Tarefa.getPriorityLabel(priority)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _setLowPriority,
                  child: Text('Baixa'),
                  style: ElevatedButton.styleFrom(
                      primary: priority == 1 ? Colors.green : Colors.white,
                      onPrimary: priority == 1 ? Colors.white : Colors.green,
                      side: BorderSide(width: 3.0, color: Colors.green)),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _setNormalPriority,
                child: Text('Normal'),
                style: ElevatedButton.styleFrom(
                    primary: priority == 2 ? Colors.blue : Colors.white,
                    onPrimary: priority == 2 ? Colors.white : Colors.blue,
                    side: BorderSide(width: 3.0, color: Colors.blue)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _setHighPriority,
                child: Text('Alta'),
                style: ElevatedButton.styleFrom(
                    primary: priority == 3 ? Colors.red : Colors.white,
                    onPrimary: priority == 3 ? Colors.white : Colors.red,
                    side: BorderSide(width: 3.0, color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
      TextFormField(
        minLines: 3,
        maxLines: 20,
        keyboardType: TextInputType.multiline,
        controller: _obsController,
        decoration: InputDecoration(
          hintText: "Obs.:",
          border: OutlineInputBorder(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(onPressed: _submitForm, child: Text('Confirmar')),
      ),
    ]);
  }

  void _setLowPriority() {
    setState(() {
      priority = 1;
    });
  }

  void _setNormalPriority() {
    setState(() {
      priority = 2;
    });
  }

  void _setHighPriority() {
    setState(() {
      priority = 3;
    });
  }
}
