import 'dart:io';

import 'package:flutter/cupertino.dart';
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
    final String _enteredTitle = titleController.text;
    final _amountEntered = int.parse(amountController.text);

    print(_enteredTitle.isEmpty);
    if (_enteredTitle.isEmpty || _amountEntered == 0) {
      return;
    }
    widget._addTransaction(_enteredTitle, _amountEntered, _selectedDate);
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  void _dateAndroidPicker() {
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

  void _dateIOSPicker() {
    _showDialog(
      CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        // firstDate: DateTime(2022),
        // lastDate: DateTime.now(),
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            if (_selectedDate.year > DateTime.now().year &&
                _selectedDate.month > DateTime.now().month &&
                _selectedDate.day > DateTime.now().day) {
              return;
            }
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(

            // change 1
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,

            // change 2
            left: 10,
            right: 10),
        child: Card(


          
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Platform.isIOS
                    ? CupertinoTextField(
                        controller: titleController,
                        placeholder: "Item name",
                      )
                    : TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            hintText: "Item name",
                            hintStyle: TextStyle(fontSize: 15)),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Platform.isIOS
                    ? CupertinoTextField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        placeholder: "Enter amount",
                      )
                    : TextField(
                        controller: amountController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: "Amount",
                            hintStyle: TextStyle(fontSize: 15)),
                      ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Date Selected- " +
                        DateFormat.yMMMd().format(_selectedDate)),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              "Change date",
                              style: TextStyle(color: Colors.purple),
                            ),
                            onPressed: _dateIOSPicker)
                        : TextButton(
                            onPressed: _dateAndroidPicker,
                            child: const Text(
                              "Change date",
                              style: TextStyle(color: Colors.purple),
                            ))
                  ],
                ),
                RaisedButton(
                    color: Colors.purple,
                    onPressed: () {
                      _submitButton();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Add Transaction",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
