import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function _addTransaction;
  AddTransaction(this._addTransaction);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String inputAmount = "";

  DateTime _selectedDate = DateTime.now();
  void _submitButton() {
    final _enteredTitle = titleController.text;
    final _amountEntered = int.parse(amountController.text);
    if (_enteredTitle == null && _amountEntered == null) {
      return;
    }
    widget._addTransaction(_enteredTitle, _amountEntered, _selectedDate);
  }

  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  hintText: "Item name", hintStyle: TextStyle(fontSize: 15)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                  hintText: "Amount", hintStyle: TextStyle(fontSize: 15)),
            ),
            Row(
              children: [
                Text("Date Selected- " +
                    DateFormat.yMMMd().format(_selectedDate)),
                FlatButton(
                    onPressed: _datePicker,
                    child: Text(
                      "Change date",
                      style: TextStyle(color: Colors.purple),
                    ))
              ],
            ),
            RaisedButton(
                color: Colors.purple,
                onPressed: _submitButton,
                child: Text(
                  "Add Transaction",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
